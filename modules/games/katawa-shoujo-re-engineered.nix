{lib, ...}: {
  flake.nixosModules.base = {
    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "katawa-shoujo-re-engineered"
      ];
    nixpkgs.config.permittedInsecurePackages = [
      "python3.12-ecdsa-0.19.1"
    ];
  };

  flake.homeModules.base = {
    config,
    pkgs,
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

      services.steam = lib.mkIf config.services.steam.enable {
        shortcuts.katawa-shoujo-re-engineered = {
          appname = "Katawa Shoujo: Re-Engineered";
          exe = lib.getExe cfg.package;
          icon = "${cfg.package}/share/icons/hicolor/512x512/apps/katawa-shoujo-re-engineered.png";
        };
        grids.katawa-shoujo-re-engineered = {
          grid = "${cfg.package}/share/kataswa-shoujo-re-engineered/game/presplash_background.png";
          horizontal = "${cfg.package}/share/kataswa-shoujo-re-engineered/game/presplash_background.png";
          hero = "${cfg.package}/share/kataswa-shoujo-re-engineered/game/event/other_iwanako.png";
          logo = "${cfg.package}/share/kataswa-shoujo-re-engineered/game/gui/logo/credo.png";
        };
      };
    };
  };
}
