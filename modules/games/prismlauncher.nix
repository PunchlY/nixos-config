{
  flake.modules.homeManager.base = {
    config,
    pkgs,
    lib,
    ...
  }: let
    cfg = config.programs.prismlauncher;
  in {
    config = lib.mkIf cfg.enable {
      programs.prismlauncher.package = pkgs.prismlauncher.override {
        jdks = with pkgs; [
          zulu25
          zulu21
          zulu17
          zulu8
        ];
      };

      programs.steam.config = lib.mkIf config.programs.steam.config.enable {
        nonSteamApps."Minecraft: Java Edition" = {
          desktopEntry.enable = false;

          target = cfg.package;

          artwork = {
            cover = pkgs.fetchurl {
              url = "https://cdn2.steamgriddb.com/grid/726c858fb9844f1d203177e1bebdff2d.png";
              hash = "sha256-dbcwc4oDiYWArbWFJ2KYtFLVc0vWa4Cj6qYp21SF/1A=";
            };
            header = pkgs.fetchurl {
              url = "https://cdn2.steamgriddb.com/grid/1635519c5c7da7f0f4c46e2238c769da.png";
              hash = "sha256-lQowuaX2+pyKohtBHGrkAU/Capif1h7SYBDyKxC1uI4=";
            };
            hero = pkgs.fetchurl {
              url = "https://cdn2.steamgriddb.com/hero/b86f5e9fc129f5803294ec6020153049.png";
              hash = "sha256-DnP/AQDmNhO4SHV4pp6I45w15iqidQpJjTNLBeDcvME=";
            };
            icon = pkgs.fetchurl {
              url = "https://cdn2.steamgriddb.com/icon/34306fb932bcbe823afb4a0c675e3ece.png";
              hash = "sha256-RNU/rF9pnhQ+9tN8DgfF/5MStkgwgZ5V09RnRSa7VX0=";
            };
            logo = pkgs.fetchurl {
              url = "https://cdn2.steamgriddb.com/logo/a8e864d04c95572d1aece099af852d0a.png";
              hash = "sha256-l1dutFU56CfeJV6P6BNBh53LSsxUXuSgoX5r51Y1dh0=";
            };
          };
        };
      };
    };
  };
}
