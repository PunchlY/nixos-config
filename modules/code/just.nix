{
  flake.modules.homeManager.base = {
    config,
    pkgs,
    lib,
    ...
  }: {
    programs.vscodium.profiles.default = lib.mkIf config.programs.vscodium.enable {
      extensions = with pkgs.vscode-extensions; [
        nefrob.vscode-just-syntax
      ];
      userSettings = {
        "vscode-just.lspPath" = lib.getExe pkgs.just-lsp;
      };
      userSettings."[just]" = {
        "editor.defaultFormatter" = "nefrob.vscode-just-syntax";
      };
    };
  };
}
