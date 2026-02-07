{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.yazi = {
    plugins = {
      inherit (pkgs.yaziPlugins) sudo;
    };
  };
}
