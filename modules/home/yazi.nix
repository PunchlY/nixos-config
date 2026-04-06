{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  config = lib.mkIf config.programs.yazi.enable {
    xdg.mimeApps.defaultApplicationPackages = [
      config.programs.yazi.package
    ];

    programs.yazi = {
      package = pkgs.yazi.override {
        _7zz = pkgs._7zz-rar;
        yazi-unwrapped = inputs.yazi.packages.${pkgs.stdenv.hostPlatform.system}.yazi-unwrapped;
      };
      extraPackages = with pkgs; [
        hexyl
      ];
      enableBashIntegration = true;
      shellWrapperName = "y";
      theme = {
        icon.prepend_dirs = lib.mapAttrsToList (name: text: {inherit name text;}) {
          dls = "";
          doc = "";
          med = "";
          music = "";
          pictures = "";
          videos = "";
          games = "";
          src = "";
          nixos-config = "";
          ".minecraft" = "󰍳";
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
          on = [
            "g"
            "d"
          ];
          run = "cd $XDG_DOWNLOAD_DIR";
        }
        {
          desc = "Chmod on selected files";
          on = [
            "c"
            "m"
          ];
          run = "plugin chmod";
        }
        {
          desc = "Mount devices";
          on = "M";
          run = "plugin mount";
        }
        {
          desc = "Hidden or showed the parent pane";
          on = [
            "T"
            "a"
          ];
          run = "plugin toggle-pane min-parent";
        }
        {
          desc = "Hidden or showed the preview pane";
          on = [
            "T"
            "c"
          ];
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
        inherit (pkgs.yaziPlugins) chmod;
        inherit (pkgs.yaziPlugins) git;
        inherit (pkgs.yaziPlugins) mount;
        inherit (pkgs.yaziPlugins) piper;
        inherit (pkgs.yaziPlugins) sudo;
        inherit (pkgs.yaziPlugins) toggle-pane;
      };
      settings.plugin.prepend_fetchers = [
        {
          id = "git";
          url = "*";
          run = "git";
        }
        {
          id = "git";
          url = "*/";
          run = "git";
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
}
