{
  nixpkgs.config = {
    allowUnfreePackages = [
      "celeste64"
    ];
  };

  flake.modules.homeManager.base = {
    config,
    pkgs,
    lib,
    ...
  }: let
    cfg = config.programs.celeste64;
  in {
    options.programs.celeste64 = {
      enable = lib.mkEnableOption "Celeste 64: Fragments of the Mountain";

      package = lib.mkPackageOption pkgs "celeste64" {};
    };

    config = lib.mkIf cfg.enable {
      home.packages = [cfg.package];

      programs.steam.config = lib.mkIf config.programs.steam.config.enable {
        nonSteamApps."Celeste 64: Fragments of the Mountain" = {
          desktopEntry.enable = false;

          target = cfg.package;

          artwork = {
            cover = pkgs.fetchurl {
              url = "https://cdn2.steamgriddb.com/grid/7e9566feb214f97558cf849d6f4f11df.jpg";
              hash = "sha256-JBeCnmN6flemK1ybJSUBw5ACJ4qItttqMVv7qKI4+dA=";
            };
            header = pkgs.fetchurl {
              url = "https://cdn2.steamgriddb.com/grid/2ef67da9eb8cd5e9b52dc8295950c668.png";
              hash = "sha256-X1U/L3+izeMzc+uTS4Bq5R7ITrmr3nfXCrQzcaeI4JM=";
            };
            hero = pkgs.fetchurl {
              url = "https://cdn2.steamgriddb.com/hero/aa9154f281790cc5675cae6f38528b7d.png";
              hash = "sha256-dAdS0a0KqNlm7L/T4eRoc4CV1tw1uEA+vIVc2gvok3U=";
            };
            icon = pkgs.fetchurl {
              url = "https://cdn2.steamgriddb.com/icon/e22b311ea7579db8a9a841ee49fb96d5.png";
              hash = "sha256-Y4ImK/aiZphP2nmEXGRo9x92kPfFPbefcVSPYB+ytiI=";
            };
            logo = pkgs.fetchurl {
              url = "https://cdn2.steamgriddb.com/logo/6c8f44a2a0ff2073e8f68a1546e5d917.png";
              hash = "sha256-Txsg5bvjl3/jUodgVqTMbslaOY1e8+Qd0n20opt1kQ4=";
            };
          };
        };
      };
    };
  };
}
