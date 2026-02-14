{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.shellAliases = {
    spawn = ''niri msg action spawn -- env --chdir="$(pwd)"'';
  };

  xdg.portal = {
    extraPortals = with pkgs; [
      xdg-desktop-portal-termfilechooser
    ];
    config.niri = {
      "org.freedesktop.impl.portal.FileChooser" = "termfilechooser";
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

  programs.niri.settings = {
    environment = {
      TERMINAL = "xdg-terminal-exec";
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

    screenshot-path = "${config.xdg.userDirs.extraConfig.SCREENSHOTS}/%Y-%m-%d-%H%M%S.png";

    window-rules = [
      {
        matches = [ { app-id = "^Waydroid$"; } ];
        open-fullscreen = true;
      }
      {
        matches = [
          { app-id = "^footclient$"; }
          { app-id = "^foot$"; }
          { app-id = "^Alacritty$"; }
        ];
        default-column-width.proportion = 1. / 3;
      }
      {
        matches = [ { app-id = "^gcr-prompter$"; } ];
        block-out-from = "screencast";
      }
      {
        matches = [
          { app-id = "^term-file-chooser$"; }
          { app-id = "^term-dmenu-desktop$"; }
        ];
        open-floating = true;
      }
    ];

    layer-rules = [
      {
        matches = [ { namespace = "^wallpaper$"; } ];
        place-within-backdrop = true;
      }
      {
        matches = [
          { namespace = "^notifications$"; }
          { namespace = "^fuzzel-polkit-agent$"; }
        ];
        block-out-from = "screencast";
      }
    ];

    binds = {
      "Mod+D" = {
        hotkey-overlay.title = "Open Application Launcher";
        action.spawn = [
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
        hotkey-overlay.title = "Open File Manager";
        action.spawn-sh = "exec xdg-open ~";
      };
      "Mod+V" = {
        hotkey-overlay.title = "Open Clipboard";
        action.spawn = lib.getExe pkgs.fuzzel-clipboard;
      };
      "Mod+T" = {
        hotkey-overlay.title = "Open Terminal";
        action.spawn = "xdg-terminal-exec";
      };
      "Mod+Escape" = {
        hotkey-overlay.title = "Open Command Menu";
        action.spawn-sh =
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
        action.spawn = "swaylock";
      };
    };
  };
}
