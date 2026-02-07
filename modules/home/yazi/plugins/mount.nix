{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.yazi = {
    plugins = {
      inherit (pkgs.yaziPlugins) mount;
    };
    keymap.mgr.prepend_keymap = [
      {
        desc = "Mount devices";
        on = "M";
        run = "plugin mount";
      }
    ];
  };
}
