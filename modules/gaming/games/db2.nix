{
  flake.modules.homeManager.base = {
    config,
    pkgs,
    lib,
    ...
  }: {
    programs.steam.config = lib.mkIf config.programs.steam.config.enable {
      nonSteamApps."Brown Dust 2" = {
        enable = lib.mkDefault false;

        compatTool = pkgs.dwproton-bin;
        target = "${pkgs.db2}/BD2StarterSetup.exe";

        artwork = {
          cover = pkgs.fetchurl {
            url = "https://cdn2.steamgriddb.com/grid/710474d4f5b8c047af09ffa1f4cfd352.png";
            hash = "sha256-2DuOD9u5xEJbcjd81f3V0zcNHvR8zzVvb7YxwnRrooI=";
          };
          header = pkgs.fetchurl {
            url = "https://cdn2.steamgriddb.com/grid/a997f6e1434bd6dd7c772df03eba6b8e.png";
            hash = "sha256-9czxwEDKhLmzXzofRj3aMggsSPMwHduJozFlL1PvxdM=";
          };
          hero = pkgs.fetchurl {
            url = "https://cdn2.steamgriddb.com/hero/24529cc88c135c55c5e3582ad8026185.png";
            hash = "sha256-QHyYMv1/plwIGyM2i8KgRecOyvITFCfsekLBD/qDCj8=";
          };
          icon = pkgs.fetchurl {
            url = "https://cdn2.steamgriddb.com/icon/e45a7c5931ad7229fd89e9fe455f599f.ico";
            hash = "sha256-cq7Ktz0XYgvQGWctybif82GHWurH5zIShVNqAwfLAz0=";
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
