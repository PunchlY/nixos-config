{
  flake.modules.homeManager.base = {
    config,
    pkgs,
    lib,
    ...
  }: {
    config = lib.mkIf config.programs.yazi.enable {
      xdg.mimeApps.defaultApplicationPackages = [
        config.programs.yazi.package
      ];

      programs.yazi = {
        extraPackages = with pkgs; [
          hexyl
        ];
        enableBashIntegration = true;
        shellWrapperName = "y";
        theme = {
          icon.prepend_globs = lib.mapAttrsToList (url: text: {inherit url text;}) {
            "${config.xdg.userDirs.documents}/" = "";
            "${config.xdg.userDirs.download}/" = "";
            "${config.xdg.userDirs.extraConfig.MEDIA}/" = "";
            "${config.xdg.userDirs.music}/" = "";
            "${config.xdg.userDirs.pictures}/" = "";
            "${config.xdg.userDirs.videos}/" = "";
            "${config.xdg.userDirs.extraConfig.GAME}/" = "";
            "${config.xdg.userDirs.extraConfig.PROJECTS}/" = "";
          };
          icon.prepend_dirs = lib.mapAttrsToList (name: text: {inherit name text;}) {
            nixos-config = "";
            ".minecraft" = "󰍳";
            "minecraft" = "󰍳";
          };
        };
        keymap.input.prepend_keymap = [
          {
            on = "<Esc>";
            run = "close";
            desc = "Cancel input";
          }
        ];
        keymap.mgr.prepend_keymap = [
          {
            desc = "Go to download dir";
            on = ["g" "d"];
            run = "cd ${config.xdg.userDirs.download}";
          }
          {
            desc = "Chmod on selected files";
            on = ["c" "m"];
            run = "plugin chmod";
          }
          {
            desc = "Mount devices";
            on = "M";
            run = "plugin mount";
          }
          {
            desc = "Hidden or showed the parent pane";
            on = ["T" "a"];
            run = "plugin toggle-pane min-parent";
          }
          {
            desc = "Hidden or showed the preview pane";
            on = ["T" "c"];
            run = "plugin toggle-pane min-preview";
          }
        ];
        initLua = ''
          Header:children_add(function()
            if ya.target_family() ~= "unix" then
              return ""
            end
            return ui.Span(ya.user_name() .. "@" .. ya.host_name() .. ":"):fg("blue")
          end, 500, Header.LEFT)

          require("git"):setup()

          require("toggle-pane"):entry("min-parent")
        '';
        plugins = {
          inherit
            (pkgs.yaziPlugins)
            chmod
            git
            mount
            piper
            sudo
            toggle-pane
            ;
        };
        settings.plugin.prepend_fetchers = [
          {
            url = "*";
            run = "git";
            group = "git";
          }
          {
            url = "*/";
            run = "git";
            group = "git";
          }
        ];
        settings.plugin.append_previewers = [
          {
            url = "*";
            run = ''piper -- hexyl --border=none --terminal-width=$w "$1"'';
          }
        ];
      };
    };
  };
}
