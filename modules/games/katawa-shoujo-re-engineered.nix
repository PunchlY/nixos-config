{
  flake.modules.nixos.base = {lib, ...}: {
    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "katawa-shoujo-re-engineered"
      ];
    nixpkgs.config.permittedInsecurePackages = [
      "python3.12-ecdsa-0.19.1"
    ];
  };

  flake.modules.homeManager.base = {
    config,
    pkgs,
    lib,
    ...
  }: let
    cfg = config.programs.katawa-shoujo-re-engineered;
  in {
    options.programs.katawa-shoujo-re-engineered = {
      enable = lib.mkEnableOption "Katawa Shoujo: Re-Engineered";

      package = lib.mkPackageOption pkgs "katawa-shoujo-re-engineered" {};
    };

    config = lib.mkIf cfg.enable {
      home.packages = [cfg.package];

      programs.steam.config = lib.mkIf config.programs.steam.config.enable {
        nonSteamApps."Katawa Shoujo: Re-Engineered" = {
          desktopEntry.enable = false;

          target = cfg.package;

          artwork = {
            cover = "${cfg.package}/share/kataswa-shoujo-re-engineered/game/presplash_background.png";
            header = "${cfg.package}/share/kataswa-shoujo-re-engineered/game/presplash_background.png";
            hero = "${cfg.package}/share/kataswa-shoujo-re-engineered/game/event/other_iwanako.png";
            icon = "${cfg.package}/share/icons/hicolor/512x512/apps/katawa-shoujo-re-engineered.png";
            logo = "${cfg.package}/share/kataswa-shoujo-re-engineered/game/gui/logo/credo.png";
          };
        };
      };
    };
  };
}
