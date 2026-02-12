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
            FONTCONFIG_FILE = pkgs.makeFontsConf {
              fontDirectories = [ nixosConfig.theme.font.package ];
            };
          }
          ''
            ln -s "$(fc-match ${lib.escapeShellArg nixosConfig.theme.font.name} --format %{file})" "$out"
          '';
    };

    services.steam-shortcuts.shortcuts.wiliwili = lib.mkIf config.services.steam-shortcuts.enable {
      appname = "WiliWili";
      exe = lib.getExe cfg.package;
    };
  };
}
