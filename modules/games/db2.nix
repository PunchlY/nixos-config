{
  flake.modules.homeManager.base = {
    config,
    pkgs,
    lib,
    ...
  }: let
    cfg = config.games.BD2;
  in {
    options.games.BD2 = {
      enable = lib.mkEnableOption "Brown Dust 2";

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.fetchurl {
          url = "https://web.archive.org/web/20260531104225/https://pc.bd2.pmang.cloud/browndust2starter/starter/update/BD2StarterSetup.exe";
          hash = "sha256-rgPocObAKePWEY6UVYeTdPWsj2elazV30q1DhDcaNic=";
        };
      };
    };

    config = lib.mkIf cfg.enable {
      services.steam = lib.mkIf config.services.steam.enable {
        shortcuts.BD2 = {
          appname = "Brown Dust 2";
          exe = [cfg.package];
          icon = pkgs.fetchurl {
            url = "https://cdn2.steamgriddb.com/icon/e45a7c5931ad7229fd89e9fe455f599f.ico";
            hash = "sha256-cq7Ktz0XYgvQGWctybif82GHWurH5zIShVNqAwfLAz0=";
          };
        };

        grids.BD2 = {
          grid = pkgs.fetchurl {
            url = "https://cdn2.steamgriddb.com/grid/710474d4f5b8c047af09ffa1f4cfd352.png";
            hash = "sha256-2DuOD9u5xEJbcjd81f3V0zcNHvR8zzVvb7YxwnRrooI=";
          };
          horizontal = pkgs.fetchurl {
            url = "https://cdn2.steamgriddb.com/grid/a997f6e1434bd6dd7c772df03eba6b8e.png";
            hash = "sha256-9czxwEDKhLmzXzofRj3aMggsSPMwHduJozFlL1PvxdM=";
          };
          hero = pkgs.fetchurl {
            url = "https://cdn2.steamgriddb.com/hero/24529cc88c135c55c5e3582ad8026185.png";
            hash = "sha256-QHyYMv1/plwIGyM2i8KgRecOyvITFCfsekLBD/qDCj8=";
          };
          logo = pkgs.fetchurl {
            url = "https://cdn2.steamgriddb.com/logo/cb10f554d73e40f723febf42a006a887.png";
            hash = "sha256-eXX9DbAEzagSYlSSXHICru23upCVzAhIN6BD2nDToqY=";
          };
        };
      };
    };
  };
}
