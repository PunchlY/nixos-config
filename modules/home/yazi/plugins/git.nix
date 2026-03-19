{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.yazi = {
    plugins = {
      inherit (pkgs.yaziPlugins) git;
    };
    initLua = ''
      require("git"):setup()
    '';
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
  };
}
