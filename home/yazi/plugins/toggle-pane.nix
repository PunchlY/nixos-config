{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.yazi = {
    plugins = {
      inherit (pkgs.yaziPlugins) toggle-pane;
    };
    initLua = ''
      require("toggle-pane"):entry("min-parent")
    '';
    keymap.mgr.prepend_keymap = [
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
  };
}
