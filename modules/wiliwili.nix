{lib, ...}: {
  flake.modules.homeManager.base = {
    config,
    pkgs,
    ...
  }: let
    cfg = config.programs.wiliwili;
  in {
    options.programs.wiliwili = {
      enable = lib.mkEnableOption "wiliwili";

      package = lib.mkPackageOption pkgs "wiliwili" {};
    };

    config = lib.mkIf cfg.enable {
      home.packages = [cfg.package];

      xdg.configFile."wiliwili/gamecontrollerdb.txt" = {
        source = "${pkgs.sdl_gamecontrollerdb}/share/gamecontrollerdb.txt";
      };

      programs.steam.config = lib.mkIf config.programs.steam.config.enable {
        nonSteamApps."WiliWili" = {
          desktopEntry.enable = false;

          target = cfg.package;

          artwork = {
            cover = pkgs.fetchurl {
              url = "https://cdn2.steamgriddb.com/grid/cdb2e2fb22b25e5aaacad92dbcd518d3.png";
              hash = "sha256-E/iNjTJQkARR/pT9TTyktZ6dRaPSEAlA7nWCOYmtG8A=";
            };
            header = pkgs.fetchurl {
              url = "https://cdn2.steamgriddb.com/grid/daec4b0d5441a48f49a0dd948a924aac.png";
              hash = "sha256-E3NfTl5MaHHlEubXdjhE2LHMKeQbgZd9zUWY0OWjnes=";
            };
            hero = pkgs.fetchurl {
              url = "https://cdn2.steamgriddb.com/hero/00ac8c9b984ddfc64cb9f1923348e225.png";
              hash = "sha256-E9WMkdS9Smkr9COeTJPRRG3on7+dvmdE9wGp7P7jbi8=";
            };
            icon = pkgs.fetchurl {
              url = "https://cdn2.steamgriddb.com/icon/875668539d0d91f5501966dfe31fa372.png";
              hash = "sha256-qkWYPYDzuFa96rOuUF47rHT1W9KszGM8ndTX4yxN0l4=";
            };
            logo = pkgs.fetchurl {
              url = "https://cdn2.steamgriddb.com/logo/2cd53de4b464155d7881d78b935b1624.png";
              hash = "sha256-xTtfRKZnK3xmKkxls3KEUdTW2oLpYeseDiy0Qu00e8o=";
            };
          };
        };
      };
    };
  };

  flake.modules.homeManager.theme = {config, ...}: let
    inherit (config.theme) font;
    cfg = config.programs.wiliwili;
  in {
    config = lib.mkIf cfg.enable {
      xdg.configFile."wiliwili/font.ttf".source = font.path;
    };
  };
}
