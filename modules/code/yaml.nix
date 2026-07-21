{
  flake.modules.homeManager.base = {
    config,
    pkgs,
    lib,
    ...
  }: {
    programs.vscodium.profiles.default = lib.mkIf config.programs.vscodium.enable {
      extensions = with pkgs.vscode-marketplace; [
        thegeeklab.yamlfmt-ng
      ];
      userSettings = {
        "yamlfmt.path" = lib.getExe pkgs.yamlfmt;
        "yamlfmt.autoInstall" = false;
      };
      userSettings."[yaml]" = {
        "editor.defaultFormatter" = "thegeeklab.yamlfmt-ng";
      };
    };
  };
}
