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
    extraPackages = with pkgs; [
      # glow
      hexyl
    ];
    settings.plugin.prepend_previewers = [
      # {
      #   url = "*.md";
      #   run = ''piper -- CLICOLOR_FORCE=1 glow -w=$w -s=dark "$1"'';
      # }
    ];
    settings.plugin.append_previewers = [
      {
        url = "*";
        run = ''piper -- hexyl --border=none --terminal-width=$w "$1"'';
      }
    ];
  };
}
