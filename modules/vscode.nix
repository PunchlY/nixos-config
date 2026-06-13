{
  flake.modules.homeManager.base = {
    config,
    pkgs,
    lib,
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
