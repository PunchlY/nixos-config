{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = builtins.map (name: ./plugins/${name}) (builtins.attrNames (builtins.readDir ./plugins));

  config = lib.mkIf config.programs.yazi.enable {
    programs.yazi = {
      enableBashIntegration = true;
      shellWrapperName = "y";
      theme = {
        icon.prepend_dirs = lib.mapAttrsToList (name: text: { inherit name text; }) {
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
      ];
      initLua = ''
        Header:children_add(function()
          if ya.target_family() ~= "unix" then
            return ""
          end
          return ui.Span(ya.user_name() .. "@" .. ya.host_name() .. ":"):fg("blue")
        end, 500, Header.LEFT)
      '';
    };
  };
}
