{
  flake.modules.homeManager.base = {
    config,
    pkgs,
    lib,
    ...
  }: {
    programs.steam.config = lib.mkIf config.programs.steam.config.enable {
      apps.Helltaker = {
        enable = lib.mkDefault false;
        id = 1289310;
        files.game.place = let
          helltaker-chinese = pkgs.fetchzip {
            url = "https://github.com/SeaEpoch/Helltaker-Chinese/releases/download/v1.2/Helltaker.zh_CN.v1.2.zip";
            hash = "sha256-e+yscW4bSjOxUN7L7qL36ZExVocHufUhIMIfqbegNTA=";
          };
        in {
          "local".source = "${helltaker-chinese}/local";
          "localHM".source = "${helltaker-chinese}/localHM";
        };
      };
    };
  };
}
