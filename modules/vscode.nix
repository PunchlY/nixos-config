{lib, ...}: {
  flake.homeModules.base = {
    config,
    pkgs,
    ...
  }: {
    config = lib.mkIf config.programs.vscode.enable {
      home.packages = with pkgs; [
        biome
      ];
      programs.vscode = {
        mutableExtensionsDir = true;
      };
    };
  };
}
