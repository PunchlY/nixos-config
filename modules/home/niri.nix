{
  nixosConfig,
  config,
  lib,
  pkgs,
  niri,
  ...
}:
let
  inherit (nixosConfig.theme) cursor colors;
  cfg = config.programs.niri;
in
{
  imports = [ niri.lib.internal.settings-module ];

  options.programs.niri = {
    enable = lib.mkEnableOption "niri" // {
      default = nixosConfig.programs.niri.enable;
    };
    package = lib.mkOption {
      type = lib.types.package;
      default = nixosConfig.programs.niri.package;
    };
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile."niri/config.kdl".source = pkgs.concatText "config.kdl" [
      (pkgs.writeText "host.kdl" ''
        include "/etc/niri/config.kdl"
      '')
      (niri.lib.internal.validated-config-for pkgs cfg.package cfg.finalConfig)
    ];

    xdg.portal = {
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-gnome
      ];
      config.niri = {
        default = [
          "gnome"
          "gtk"
        ];
        "org.freedesktop.impl.portal.Access" = "gtk";
        "org.freedesktop.impl.portal.Notification" = "gtk";
        "org.freedesktop.impl.portal.Secret" = "gnome-keyring";
      };
    };

    systemd.user.targets.niri-session = {
      Unit = {
        Description = "niri compositor session";
        Documentation = [ "man:systemd.special(7)" ];
        BindsTo = [ "graphical-session.target" ];
        Wants = [ "graphical-session-pre.target" ];
        After = [ "graphical-session-pre.target" ];
      };
    };

    systemd.user.services.fuzzel-polkit-agent = {
      Unit = {
        Description = "Fuzzel Polkit Agent";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        Type = "simple";
        ExecStart = "${pkgs.fuzzel-polkit-agent}/libexec/fuzzel-polkit-agent";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };

      Install = {
        WantedBy = [ "niri.service" ];
      };
    };

    systemd.user.services.wbg = {
      Unit = {
        ConditionEnvironment = "WAYLAND_DISPLAY";
        PartOf = [ "niri.service" ];
        After = [ "niri.service" ];
      };

      Service = {
        ExecStart = "${lib.getExe pkgs.wbg} --stretch ${nixosConfig.theme.wallpaper}";
        Restart = "always";
        RestartSec = "10";
      };

      Install = {
        WantedBy = [ "niri.service" ];
      };
    };

    programs.niri.settings = with colors.hex; {
      environment = {
        MOZ_ENABLE_WAYLAND = "1";
        GTK_USE_PORTAL = "1";
        NIXOS_OZONE_WL = "1";
        QT_QPA_PLATFORM = "wayland;xcb";
        ELECTRON_OZONE_PLATFORM_HINT = "auto";
        SDL_VIDEODRIVER = "wayland";
        STEAM_USE_WAYLAND = "1";
        GDK_BACKEND = "wayland";
        QT_AUTO_SCREEN_SCALE_FACTOR = "1";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        GTK_CSD = "0";
      };

      cursor = {
        size = cursor.size;
        theme = cursor.name;
        hide-after-inactive-ms = 3000;
      };

      layout = {
        focus-ring.enable = false;
        gaps = 8;
        center-focused-column = "on-overflow";
        always-center-single-column = true;
        border = {
          enable = true;
          width = 2;
          active.color = primary;
          inactive.color = surface_variant;
        };
        background-color = "transparent";
        preset-column-widths = [
          { proportion = 1. / 3.; }
          { proportion = 1. / 2.; }
          { proportion = 2. / 3.; }
        ];
        default-column-width.proportion = 2. / 3.;
      };

      overview = {
        backdrop-color = background;
        workspace-shadow.enable = false;
      };

      xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

      clipboard.disable-primary = true;

      prefer-no-csd = true;

      gestures.hot-corners.enable = false;
      hotkey-overlay.skip-at-startup = true;

      window-rules = [
        {
          draw-border-with-background = false;
          geometry-corner-radius = {
            bottom-left = 8.0;
            bottom-right = 8.0;
            top-left = 8.0;
            top-right = 8.0;
          };
          clip-to-geometry = true;
          # open-maximized-to-edges = false;
        }
      ];

      spawn-at-startup = [
        {
          sh = "${pkgs.dbus}/bin/dbus-update-activation-environment --systemd --all && systemctl --user stop niri-session.target && systemctl --user start niri-session.target";
        }
      ];
    };
  };
}
