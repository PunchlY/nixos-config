{
  nixosConfig,
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (nixosConfig.theme) cursor colors;
  cfg = config.programs.niri;
in {
  imports = [inputs.niri.lib.internal.settings-module];

  options.programs.niri = {
    enable =
      lib.mkEnableOption "niri"
      // {
        default = nixosConfig.programs.niri.enable;
      };

    package =
      lib.mkPackageOption pkgs "niri" {}
      // {
        default = nixosConfig.programs.niri.package;
      };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [cfg.package];

    xdg.configFile."niri/config.kdl".source =
      inputs.niri.lib.internal.validated-config-for pkgs cfg.package
      cfg.finalConfig;

    programs.uwsm.desktopEnv.niri = lib.mkIf config.programs.uwsm.enable {
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

    programs.niri.settings = {
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
          active.color = colors.primary.hex;
          inactive.color = colors.surface_variant.hex;
        };
        background-color = "transparent";
        preset-column-widths = [
          {proportion = 1. / 3.;}
          {proportion = 1. / 2.;}
          {proportion = 2. / 3.;}
        ];
        default-column-width.proportion = 2. / 3.;
      };

      overview = {
        backdrop-color = colors.background.hex;
        workspace-shadow.enable = false;
      };

      xwayland-satellite.path = lib.mkDefault (lib.getExe pkgs.xwayland-satellite);

      clipboard.disable-primary = true;

      prefer-no-csd = true;

      gestures.hot-corners.enable = false;
      hotkey-overlay.skip-at-startup = true;

      screenshot-path = "${
        config.xdg.userDirs.extraConfig.SCREENSHOTS
          or "${config.xdg.userDirs.pictures or "${config.home.homeDirectory}/Pictures"}/Screenshots"
      }/%Y-%m-%d-%H%M%S.png";

      window-rules = [
        {
          draw-border-with-background = false;
          # geometry-corner-radius = {
          #   bottom-left = 8.0;
          #   bottom-right = 8.0;
          #   top-left = 8.0;
          #   top-right = 8.0;
          # };
          clip-to-geometry = true;
          # open-maximized-to-edges = false;
        }
        {
          matches = [
            {app-id = "^term-file-chooser$";}
          ];
          open-floating = true;
        }
        {
          matches = [
            {app-id = "^gcr-prompter$";}
          ];
          block-out-from = "screencast";
        }
        {
          matches = [{app-id = "^Waydroid$";}];
          open-fullscreen = true;
        }
        {
          matches = [
            {app-id = "^footclient$";}
            {app-id = "^foot$";}
            {app-id = "^Alacritty$";}
          ];
          default-column-width.proportion = 1. / 3;
        }
      ];

      layer-rules = [
        {
          matches = [
            {namespace = "^wallpaper$";}
          ];
          place-within-backdrop = true;
        }
        {
          matches = [
            {namespace = "^notifications$";}
            {namespace = "^fuzzel-polkit-agent$";}
          ];
          block-out-from = "screencast";
        }
      ];

      spawn-at-startup = [
        (lib.mkIf config.programs.uwsm.enable {
          sh = "uwsm finalize";
        })
      ];

      binds = {
        "Mod+E" = {
          hotkey-overlay.title = "Open File Manager";
          action.spawn-sh = "xdg-open ~";
        };
        "Mod+T" = {
          hotkey-overlay.title = "Open Terminal";
          action.spawn = "xdg-terminal-exec";
        };

        "Mod+D" = {
          hotkey-overlay.title = "Open Application Launcher";
          action.spawn-sh = "fuzzel ${lib.cli.toCommandLineShellGNU {} {
            show-actions = true;
            terminal = "xdg-terminal-exec -- {cmd}";
            launch-prefix = "sh -c ${lib.escapeShellArg ''
              if [ -z "$DESKTOP_ENTRY_ID" ]; then
                set -- xdg-terminal-exec -- "$@"
              fi
              exec niri msg action spawn -- "$@"
            ''} _";
          }}";
        };
        "Mod+V" = {
          hotkey-overlay.title = "Open Clipboard";
          action.spawn = "cliphist-fuzzel-img";
        };
        "Mod+Escape" = {
          hotkey-overlay.title = "Open Command Menu";
          action.spawn-sh = let
            menu = [
              {
                key = "Game Mode";
                cmd = "steamosctl switch-to-game-mode";
              }
              {
                key = "Suspend";
                cmd = "systemctl suspend";
              }
              {
                key = "Reboot";
                cmd = "systemctl reboot";
              }
              {
                key = "Shutdown";
                cmd = "systemctl poweroff";
              }
            ];
          in ''
            cmds=( ${lib.escapeShellArgs (lib.catAttrs "cmd" menu)} )
            index=$(fuzzel --dmenu --index --only-match --minimal-lines <<< ${lib.escapeShellArg (lib.concatStringsSep "\n" (lib.catAttrs "key" menu))})
            [ -z "$index" ] && exit 0
            [ "$index" -lt 0 ] && exit 0
            eval "''${cmds[$index]}"
          '';
        };
        "Mod+Alt+L" = {
          hotkey-overlay.title = "Lock the Screen";
          allow-inhibiting = false;
          action.spawn-sh = "loginctl lock-session";
        };

        "Mod+O".action.toggle-overview = {};

        "Mod+F1".action.show-hotkey-overlay = {};
        "Mod+Shift+Q".action.close-window = {};

        "Mod+Left".action.focus-column-left = {};
        "Mod+Down".action.focus-window-down = {};
        "Mod+Up".action.focus-window-up = {};
        "Mod+Right".action.focus-column-right = {};
        "Mod+Shift+WheelScrollUp".action.focus-column-left = {};
        "Mod+Shift+WheelScrollDown".action.focus-column-right = {};
        "Mod+H".action.focus-column-left = {};
        "Mod+J".action.focus-window-down = {};
        "Mod+K".action.focus-window-up = {};
        "Mod+L".action.focus-column-right = {};

        "Mod+Ctrl+Left".action.move-column-left = {};
        "Mod+Ctrl+Down".action.move-window-down = {};
        "Mod+Ctrl+Up".action.move-window-up = {};
        "Mod+Ctrl+Right".action.move-column-right = {};
        "Mod+Ctrl+H".action.move-column-left = {};
        "Mod+Ctrl+J".action.move-window-down = {};
        "Mod+Ctrl+K".action.move-window-up = {};
        "Mod+Ctrl+L".action.move-column-right = {};

        "Mod+Minus".action.set-column-width = "-10%";
        "Mod+Equal".action.set-column-width = "+10%";
        "Mod+Shift+Minus".action.set-window-height = "-10%";
        "Mod+Shift+Equal".action.set-window-height = "+10%";

        "Mod+1".action.focus-workspace = 1;
        "Mod+2".action.focus-workspace = 2;
        "Mod+3".action.focus-workspace = 3;
        "Mod+4".action.focus-workspace = 4;
        "Mod+5".action.focus-workspace = 5;
        "Mod+6".action.focus-workspace = 6;
        "Mod+7".action.focus-workspace = 7;
        "Mod+8".action.focus-workspace = 8;
        "Mod+9".action.focus-workspace = 9;

        "Mod+Ctrl+1".action.move-column-to-workspace = 1;
        "Mod+Ctrl+2".action.move-column-to-workspace = 2;
        "Mod+Ctrl+3".action.move-column-to-workspace = 3;
        "Mod+Ctrl+4".action.move-column-to-workspace = 4;
        "Mod+Ctrl+5".action.move-column-to-workspace = 5;
        "Mod+Ctrl+6".action.move-column-to-workspace = 6;
        "Mod+Ctrl+7".action.move-column-to-workspace = 7;
        "Mod+Ctrl+8".action.move-column-to-workspace = 8;
        "Mod+Ctrl+9".action.move-column-to-workspace = 9;

        "Mod+Ctrl+Page_Down".action.move-column-to-workspace-down = {};
        "Mod+Ctrl+Page_Up".action.move-column-to-workspace-up = {};
        "Mod+Ctrl+U".action.move-column-to-workspace-down = {};
        "Mod+Ctrl+I".action.move-column-to-workspace-up = {};

        "Mod+R".action.switch-preset-column-width = {};
        "Mod+F11".action.fullscreen-window = {};
        "Mod+Shift+F11".action.toggle-windowed-fullscreen = {};
        "Mod+F".action.maximize-column = {};
        "Mod+Shift+F".action.maximize-window-to-edges = {};

        "Print".action.screenshot = {
          show-pointer = false;
        };
        "Ctrl+Print".action.screenshot-screen = {
          write-to-disk = true;
        };
        "Alt+Print".action.screenshot-window = {
          write-to-disk = true;
        };

        "XF86AudioRaiseVolume" = {
          allow-when-locked = true;
          action.spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
        };
        "XF86AudioLowerVolume" = {
          allow-when-locked = true;
          action.spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        };
        "XF86AudioMute" = {
          allow-when-locked = true;
          action.spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        };
        "XF86AudioMicMute" = {
          allow-when-locked = true;
          action.spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
        };

        "XF86AudioNext" = {
          allow-when-locked = true;
          action.spawn-sh = "playerctl next";
        };
        "XF86AudioPlay" = {
          allow-when-locked = true;
          action.spawn-sh = "playerctl play-pause";
        };
        "XF86AudioPrev" = {
          allow-when-locked = true;
          action.spawn-sh = "playerctl previous";
        };
        "XF86AudioStop" = {
          allow-when-locked = true;
          action.spawn-sh = "playerctl pause";
        };

        "XF86MonBrightnessDown" = {
          allow-when-locked = true;
          action.spawn-sh = "brightnessctl set 5%-";
        };
        "XF86MonBrightnessUp" = {
          allow-when-locked = true;
          action.spawn-sh = "brightnessctl set 5%+";
        };
      };
    };
  };
}
