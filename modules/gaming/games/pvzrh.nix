{
  nixpkgs.config = {
    allowUnfreePackages = [
      "PlantsVsZombiesRH.zip"
    ];
  };

  flake.modules.homeManager.base = {
    config,
    pkgs,
    lib,
    ...
  }: {
    programs.steam.config = lib.mkIf config.programs.steam.config.enable {
      nonSteamApps."Plants vs. Zombies: RH" = {
        enable = lib.mkDefault false;
        target = "${pkgs.pvz-rh}/PlantsVsZombiesRH.exe";
        compatTool = "proton_experimental";
      };
    };
  };
}
