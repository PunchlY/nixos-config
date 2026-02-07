{
  nixosConfig,
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (nixosConfig.theme) cursor colors;
in
{
  home.shellAliases = {
    spawn = ''niri msg action spawn -- env --chdir="$(pwd)"'';
  };

  xdg.portal = {
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
      xdg-desktop-portal-termfilechooser
    ];
    config.niri = {
      default = [
        "gnome"
        "gtk"
      ];
      "org.freedesktop.impl.portal.Access" = "gtk";
      "org.freedesktop.impl.portal.Notification" = "gtk";
      "org.freedesktop.impl.portal.FileChooser" = "termfilechooser";
      "org.freedesktop.impl.portal.Secret" = "gnome-keyring";
    };
  };

  xdg.configFile."xdg-desktop-portal-termfilechooser/config".text = lib.generators.toINI { } {
    filechooser = {
      cmd = "${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh";
      default_dir = config.xdg.userDirs.download;
      env = lib.strings.toShellVars {
        TERMCMD = "xdg-terminal-exec --app-id=term-file-chooser --";
      };
      open_mode = "suggested";
      save_mode = "last";
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

  xdg.configFile."niri/config.kdl".text = config.lib.generators.toKDL { } {
    spawn-sh-at-startup = "${pkgs.dbus}/bin/dbus-update-activation-environment --systemd --all && systemctl --user stop niri-session.target && systemctl --user start niri-session.target";

    environment = {
      TERMINAL = "xdg-terminal-exec";
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

      LANG = "zh_CN.UTF-8";
      LC_ADDRESS = "zh_CN.UTF-8";
      LC_IDENTIFICATION = "zh_CN.UTF-8";
      LC_MEASUREMENT = "zh_CN.UTF-8";
      LC_MONETARY = "zh_CN.UTF-8";
      LC_NAME = "zh_CN.UTF-8";
      LC_NUMERIC = "zh_CN.UTF-8";
      LC_PAPER = "zh_CN.UTF-8";
      LC_TELEPHONE = "zh_CN.UTF-8";
      LC_TIME = "zh_CN.UTF-8";
    };

    screenshot-path = "${config.xdg.userDirs.extraConfig.XDG_SCREENSHOTS_DIR}/%Y-%m-%d-%H%M%S.png";

    cursor = {
      xcursor-size = cursor.size;
      xcursor-theme = cursor.name;
      hide-after-inactive-ms = 3000;
    };
    layout.focus-ring.off = { };
    layout.border = {
      on = { };
      active-color = colors.hex.primary;
      inactive-color = colors.hex.surface_variant;
    };
    layout.background-color = "transparent";
    overview = {
      backdrop-color = colors.hex.background;
      workspace-shadow.off = { };
    };

    clipboard.disable-primary = { };

    xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

    prefer-no-csd = { };

    layout = {
      gaps = 8;
      center-focused-column = "on-overflow";
      always-center-single-column = { };
      focus-ring.off = { };
      border.width = 2;
      preset-column-widths._children = [
        { proportion = 1. / 3.; }
        { proportion = 1. / 2.; }
        { proportion = 2. / 3.; }
      ];
      default-column-width.proportion = 2. / 3.;
    };
    gestures.hot-corners.off = { };

    hotkey-overlay.skip-at-startup = { };

    input.mouse.accel-speed = 1.0;
    input.touchpad = {
      tap = { };
      natural-scroll = { };
    };

    _children = [
      {
        output = {
          _args = [ "eDP-1" ];
          focus-at-startup = { };
          mode = "2560x1440@60.009";
          scale = 1.50;
        };
      }
      {
        output = {
          _args = [ "HDMI-A-1" ];
          scale = 1.50;
        };
      }
      {
        window-rule = {
          draw-border-with-background = false;
          geometry-corner-radius = 8.0;
          clip-to-geometry = true;
          open-maximized-to-edges = false;
        };
      }
      {
        window-rule = {
          match._props.app-id = "^Waydroid$";
          open-fullscreen = true;
        };
      }
      {
        window-rule._children = [
          { match._props.app-id = "^footclient$"; }
          { match._props.app-id = "^foot$"; }
          { match._props.app-id = "^Alacritty$"; }
          {
            default-column-width.proportion = 1. / 3;
          }
        ];
      }
      {
        window-rule._children = [
          { match._props.app-id = "^term-file-chooser$"; }
          { match._props.app-id = "^term-dmenu-desktop$"; }
          {
            open-floating = true;
          }
        ];
      }
      {
        window-rule = {
          match._props.app-id = "^gcr-prompter$";
          block-out-from = "screencast";
        };
      }
      {
        layer-rule = {
          match._props.namespace = "^wallpaper$";
          place-within-backdrop = true;
        };
      }
      {
        layer-rule._children = [
          { match._props.namespace = "^notifications$"; }
          { match._props.namespace = "^fuzzel-polkit-agent$"; }
          {
            block-out-from = "screencast";
          }
        ];
      }
    ];

    binds = {
      "Mod+D" = {
        _props.hotkey-overlay-title = "Open Application Launcher";
        spawn = [
          "fuzzel"
        ]
        ++ lib.cli.toCommandLineGNU { } {
          show-actions = true;
          terminal = "xdg-terminal-exec -- {cmd}";
          launch-prefix = pkgs.writeShellScript "launch-prefix" ''
            if [ -z "$DESKTOP_ENTRY_ID" ]; then
              set -- xdg-terminal-exec -- "$@"
            fi
            exec niri msg action spawn -- "$@"
          '';
        };
      };
      "Mod+E" = {
        _props.hotkey-overlay-title = "Open File Manager";
        spawn-sh = "exec xdg-open ~";
      };
      "Mod+V" = {
        _props.hotkey-overlay-title = "Open Clipboard";
        spawn = lib.getExe pkgs.fuzzel-clipboard;
      };
      "Mod+T" = {
        _props.hotkey-overlay-title = "Open Terminal";
        spawn = "xdg-terminal-exec";
      };
      "Mod+Escape" = {
        _props.hotkey-overlay-title = "Open Command Menu";
        spawn-sh =
          let
            menu = [
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
          in
          ''
            cmds=( ${lib.escapeShellArgs (lib.attrsets.catAttrs "cmd" menu)} )
            index=$(fuzzel --dmenu --index --only-match --minimal-lines <<< ${lib.escapeShellArg (lib.concatStringsSep "\n" (lib.attrsets.catAttrs "key" menu))})
            [ -z "$index" ] && exit 0
            [ "$index" -lt 0 ] && exit 0
            eval "''${cmds[$index]}"
          '';
      };
      "Mod+Alt+L" = {
        _props.hotkey-overlay-title = "Lock the Screen";
        _props.allow-inhibiting = false;
        spawn = "swaylock";
      };

      "Mod+O".toggle-overview = { };

      "Mod+F1".show-hotkey-overlay = { };
      "Mod+Shift+Q".close-window = { };

      "Mod+Left".focus-column-left = { };
      "Mod+Down".focus-window-down = { };
      "Mod+Up".focus-window-up = { };
      "Mod+Right".focus-column-right = { };
      "Mod+Shift+WheelScrollUp".focus-column-left = { };
      "Mod+Shift+WheelScrollDown".focus-column-right = { };
      "Mod+H".focus-column-left = { };
      "Mod+J".focus-window-down = { };
      "Mod+K".focus-window-up = { };
      "Mod+L".focus-column-right = { };

      "Mod+Ctrl+Left".move-column-left = { };
      "Mod+Ctrl+Down".move-window-down = { };
      "Mod+Ctrl+Up".move-window-up = { };
      "Mod+Ctrl+Right".move-column-right = { };
      "Mod+Ctrl+H".move-column-left = { };
      "Mod+Ctrl+J".move-window-down = { };
      "Mod+Ctrl+K".move-window-up = { };
      "Mod+Ctrl+L".move-column-right = { };

      "Mod+Minus".set-column-width = "-10%";
      "Mod+Equal".set-column-width = "+10%";
      "Mod+Shift+Minus".set-window-height = "-10%";
      "Mod+Shift+Equal".set-window-height = "+10%";

      "Mod+1".focus-workspace = 1;
      "Mod+2".focus-workspace = 2;
      "Mod+3".focus-workspace = 3;
      "Mod+4".focus-workspace = 4;
      "Mod+5".focus-workspace = 5;
      "Mod+6".focus-workspace = 6;
      "Mod+7".focus-workspace = 7;
      "Mod+8".focus-workspace = 8;
      "Mod+9".focus-workspace = 9;

      "Mod+Ctrl+1".move-column-to-workspace = 1;
      "Mod+Ctrl+2".move-column-to-workspace = 2;
      "Mod+Ctrl+3".move-column-to-workspace = 3;
      "Mod+Ctrl+4".move-column-to-workspace = 4;
      "Mod+Ctrl+5".move-column-to-workspace = 5;
      "Mod+Ctrl+6".move-column-to-workspace = 6;
      "Mod+Ctrl+7".move-column-to-workspace = 7;
      "Mod+Ctrl+8".move-column-to-workspace = 8;
      "Mod+Ctrl+9".move-column-to-workspace = 9;

      "Mod+Ctrl+Page_Down".move-column-to-workspace-down = { };
      "Mod+Ctrl+Page_Up".move-column-to-workspace-up = { };
      "Mod+Ctrl+U".move-column-to-workspace-down = { };
      "Mod+Ctrl+I".move-column-to-workspace-up = { };

      "Mod+Shift+E".quit = { };

      "Mod+R".switch-preset-column-width = { };
      "Mod+F11".fullscreen-window = { };
      "Mod+Shift+F11".toggle-windowed-fullscreen = { };
      "Mod+F".maximize-column = { };
      "Mod+Shift+F".maximize-window-to-edges = { };

      Print.screenshot = {
        _props.show-pointer = false;
      };
      "Ctrl+Print".screenshot-screen = {
        _props.write-to-disk = true;
      };
      "Alt+Print".screenshot-window = {
        _props.write-to-disk = true;
      };

      XF86AudioRaiseVolume = {
        _props.allow-when-locked = true;
        spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
      };
      XF86AudioLowerVolume = {
        _props.allow-when-locked = true;
        spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
      };
      XF86AudioMute = {
        _props.allow-when-locked = true;
        spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      };
      XF86AudioMicMute = {
        _props.allow-when-locked = true;
        spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
      };

      XF86AudioNext = {
        _props.allow-when-locked = true;
        spawn-sh = "playerctl next";
      };
      XF86AudioPlay = {
        _props.allow-when-locked = true;
        spawn-sh = "playerctl play-pause";
      };
      XF86AudioPrev = {
        _props.allow-when-locked = true;
        spawn-sh = "playerctl previous";
      };
      XF86AudioStop = {
        _props.allow-when-locked = true;
        spawn-sh = "playerctl pause";
      };

      XF86MonBrightnessDown = {
        _props.allow-when-locked = true;
        spawn-sh = "brightnessctl set 5%-";
      };
      XF86MonBrightnessUp = {
        _props.allow-when-locked = true;
        spawn-sh = "brightnessctl set 5%+";
      };
    };
  };

}
