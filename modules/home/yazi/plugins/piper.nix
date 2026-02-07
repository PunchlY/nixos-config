{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.yazi = {
    plugins = {
      inherit (pkgs.yaziPlugins) piper;
    };
    settings = {
      plugin.prepend_previewers = [
        # {
        #   name = "*.md";
        #   run = ''piper -- CLICOLOR_FORCE=1 ${lib.getExe pkgs.glow} -w=$w -s=dark "$1"'';
        # }
      ];
      plugin.append_previewers = [
        {
          name = "*";
          run = ''piper -- ${lib.getExe pkgs.hexyl} --border=none --terminal-width=$w "$1"'';
        }
      ];
    };
  };
}
