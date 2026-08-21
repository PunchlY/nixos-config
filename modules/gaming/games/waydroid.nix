{
  flake.modules.homeManager.base = {
    config,
    pkgs,
    lib,
    ...
  }: {
    programs.steam.config = lib.mkIf config.programs.steam.config.enable {
      nonSteamApps.Waydroid = {
        enable = lib.mkDefault false;
        target = pkgs.waydroid-launcher;
        desktopEntry.enable = false;

        artwork = {
          cover = pkgs.fetchurl {
            url = "https://cdn2.steamgriddb.com/grid/3326cc06add44197e71b0b7e6e266bab.png";
            hash = "sha256-9uEIUd/VmHw8QIM6r+SS+OeBkmrl7Cj+p1z8vCgVX1E=";
          };
          header = pkgs.fetchurl {
            url = "https://cdn2.steamgriddb.com/grid/fe92ffa3e171450671eea26a3f5246e1.jpg";
            hash = "sha256-Gu5GyI3lFtM17VYEs/StkrquqQjWhKflpoFegw2ghAo=";
          };
          hero = pkgs.fetchurl {
            url = "https://cdn2.steamgriddb.com/hero/ee22b2f4c529c8dcc05e24ba6f7e7f34.jpg";
            hash = "sha256-9uZQ6ZJBD9QXhY/x2jB2mAa3Hjvmx/Ttr5lewn/GeTw=";
          };
          icon = pkgs.fetchurl {
            url = "https://cdn2.steamgriddb.com/icon/d6de4f0418bf4015017f5c65cdecc46e.png";
            hash = "sha256-ZQNyP8k4caAhQzk99bvyKjizPtiGSMFNqW2okpaeH1g=";
          };
          logo = pkgs.fetchurl {
            url = "https://cdn2.steamgriddb.com/logo/eb23fe2641003ad07d93ebdd63300629.png";
            hash = "sha256-z/mxLo5QoZDacuadbcCtQVY6/+TNiSyoCGUL+DKwbOo=";
          };
        };
      };
    };
  };
}
