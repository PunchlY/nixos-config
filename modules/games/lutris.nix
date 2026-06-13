{lib, ...}: {
  flake.modules.homeManager.base = {
    config,
    osConfig,
    pkgs,
    ...
  }: {
    config = lib.mkIf config.programs.lutris.enable {
      programs.lutris = {
        steamPackage = osConfig.programs.steam.package;
        defaultWinePackage = pkgs.proton-ge-bin;
        protonPackages = [pkgs.proton-ge-bin];
        winePackages = [pkgs.wineWow64Packages.full];
      };
    };
  };
}
