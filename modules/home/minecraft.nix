{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.minecraft;
in {
  options.programs.minecraft = {
    enable = lib.mkEnableOption "minecraft";

    package = lib.mkPackageOption pkgs "prismlauncher" {};
  };

  config = lib.mkIf cfg.enable {
    home.packages = [cfg.package];

    services.steam = lib.mkIf config.services.steam.enable {
      shortcuts.minecraft = {
        appname = "Minecraft: Java Edition";
        exe = lib.getExe cfg.package;
        icon = pkgs.fetchurl {
          url = "https://cdn2.steamgriddb.com/icon/34306fb932bcbe823afb4a0c675e3ece.png";
          hash = "sha256-RNU/rF9pnhQ+9tN8DgfF/5MStkgwgZ5V09RnRSa7VX0=";
        };
      };
      grids.minecraft = {
        grid = pkgs.fetchurl {
          url = "https://cdn2.steamgriddb.com/grid/726c858fb9844f1d203177e1bebdff2d.png";
          hash = "sha256-dbcwc4oDiYWArbWFJ2KYtFLVc0vWa4Cj6qYp21SF/1A=";
        };
        horizontal = pkgs.fetchurl {
          url = "https://cdn2.steamgriddb.com/grid/1635519c5c7da7f0f4c46e2238c769da.png";
          hash = "sha256-lQowuaX2+pyKohtBHGrkAU/Capif1h7SYBDyKxC1uI4=";
        };
        hero = pkgs.fetchurl {
          url = "https://cdn2.steamgriddb.com/hero/b86f5e9fc129f5803294ec6020153049.png";
          hash = "sha256-DnP/AQDmNhO4SHV4pp6I45w15iqidQpJjTNLBeDcvME=";
        };
        logo = pkgs.fetchurl {
          url = "https://cdn2.steamgriddb.com/logo/a8e864d04c95572d1aece099af852d0a.png";
          hash = "sha256-l1dutFU56CfeJV6P6BNBh53LSsxUXuSgoX5r51Y1dh0=";
        };
      };
    };
  };
}
