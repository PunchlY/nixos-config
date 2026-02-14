{
  nixosConfig,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.wiliwili;
in
{
  options.programs.wiliwili = {
    enable = lib.mkEnableOption "wiliwili";

    package = lib.mkPackageOption pkgs "wiliwili" { nullable = true; };
  };

  config = lib.mkIf cfg.enable {
    home.packages = lib.mkIf (cfg.package != null) [ cfg.package ];

    xdg.configFile."wiliwili/gamecontrollerdb.txt" = {
      source = "${pkgs.sdl_gamecontrollerdb}/share/gamecontrollerdb.txt";
    };

    xdg.configFile."wiliwili/font.ttf" = {
      source =
        pkgs.runCommand "wiliwili-font"
          {
            nativeBuildInputs = [ pkgs.fontconfig ];
            fontName = nixosConfig.theme.font.name;
            FONTCONFIG_FILE = pkgs.makeFontsConf {
              fontDirectories = [ nixosConfig.theme.font.package ];
            };
          }
          ''
            ln -s "$(fc-match "$fontName" --format %{file})" "$out"
          '';
    };

    services.steam = lib.mkIf config.services.steam.enable {
      shortcuts.wiliwili = {
        appname = "WiliWili";
        exe = lib.getExe cfg.package;
      };
      grids.wiliwili = {
        grid = pkgs.fetchurl {
          url = "https://cdn2.steamgriddb.com/grid/cdb2e2fb22b25e5aaacad92dbcd518d3.png";
          hash = "sha256-E/iNjTJQkARR/pT9TTyktZ6dRaPSEAlA7nWCOYmtG8A=";
        };
        horizontal = pkgs.fetchurl {
          url = "https://cdn2.steamgriddb.com/grid/daec4b0d5441a48f49a0dd948a924aac.png";
          hash = "sha256-E3NfTl5MaHHlEubXdjhE2LHMKeQbgZd9zUWY0OWjnes=";
        };
        hero = pkgs.fetchurl {
          url = "https://cdn2.steamgriddb.com/hero/00ac8c9b984ddfc64cb9f1923348e225.png";
          hash = "sha256-E9WMkdS9Smkr9COeTJPRRG3on7+dvmdE9wGp7P7jbi8=";
        };
        logo = pkgs.fetchurl {
          url = "https://cdn2.steamgriddb.com/logo/2cd53de4b464155d7881d78b935b1624.png";
          hash = "sha256-xTtfRKZnK3xmKkxls3KEUdTW2oLpYeseDiy0Qu00e8o=";
        };
      };
    };
  };
}
