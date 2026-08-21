{
  flake.modules.homeManager.base = {
    config,
    pkgs,
    lib,
    ...
  }: let
    cfg = config.programs.shattered-pixel-dungeon;
  in {
    options.programs.shattered-pixel-dungeon = {
      enable = lib.mkEnableOption "Shattered Pixel Dungeon";

      package = lib.mkPackageOption pkgs "shattered-pixel-dungeon" {};
    };

    config = lib.mkIf cfg.enable {
      home.packages = [cfg.package];

      programs.steam.config = lib.mkIf config.programs.steam.config.enable {
        nonSteamApps."Shattered Pixel Dungeon" = {
          desktopEntry.enable = false;

          target = cfg.package;

          artwork = {
            cover = pkgs.fetchurl {
              url = "https://cdn2.steamgriddb.com/grid/998b26e04f385d6ac7854955c483518c.jpg";
              hash = "sha256-bkE2+oHKJ1YsLoq7h2iqkpHfbKXFaRk0jly8hAG3754=";
            };
            header = pkgs.fetchurl {
              url = "https://cdn2.steamgriddb.com/grid/d2087d2dbcd6a18c29e2025f0abcb76c.jpg";
              hash = "sha256-G7axgZyuOIZV3oSxg2WqHSCVrU5ag1+Q0YXlN7AxLvw=";
            };
            hero = pkgs.fetchurl {
              url = "https://cdn2.steamgriddb.com/hero/cd179de58c6340faf5c9e4e921638f79.png";
              hash = "sha256-cWD7YIwxwYCTNSTHKLKyL6Vd4BVnFrKrMVE2VpaLkt8=";
            };
            icon = pkgs.fetchurl {
              url = "https://cdn2.steamgriddb.com/icon/bd50f363001990ee1fe5d798702b1d5b.ico";
              hash = "sha256-gbFQaShrmEcZN/nFQZv81koWl2Xp0I7HwBK5nJ3e/yQ=";
            };
            logo = pkgs.fetchurl {
              url = "https://cdn2.steamgriddb.com/logo/d6804b4136e70e8332b569f55e8a80c5.png";
              hash = "sha256-yHI8CAziYwSsir4nwFuRpqUcuhaSX0ESn6Z5udsqDec=";
            };
          };
        };
      };
    };
  };
}
