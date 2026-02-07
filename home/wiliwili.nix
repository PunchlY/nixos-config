{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    wiliwili
  ];

  xdg.configFile."wiliwili/gamecontrollerdb.txt" = {
    source = "${pkgs.sdl_gamecontrollerdb}/share/gamecontrollerdb.txt";
  };

  xdg.configFile."wiliwili/font.ttf" = {
    source =
      pkgs.runCommand "wiliwili-font"
        {
          nativeBuildInputs = [ pkgs.fontconfig ];
          FONTCONFIG_FILE = pkgs.makeFontsConf {
            fontDirectories = [ config.theme.font.package ];
          };
        }
        ''
          ln -s "$(fc-match ${lib.escapeShellArg config.theme.font.name} --format %{file})" "$out"
        '';
  };
}
