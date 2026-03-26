{
  nixosConfig,
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (nixosConfig.theme) colors font opacity;
in
{
  config = lib.mkIf config.programs.ghostty.enable {
    programs.ghostty = {
      systemd.enable = true;
      settings = {
        font-family = font.name;
        font-size = font.size;
        theme = "md3";
      };
      themes.md3 = with colors.hex_stripped; {
        palette = [
          "0=#${black}"
          "1=#${red_dim}"
          "2=#${green_dim}"
          "3=#${yellow_dim}"
          "4=#${blue_dim}"
          "5=#${magenta_dim}"
          "6=#${cyan_dim}"
          "7=#${white}"
          "8=#${gray}"
          "9=#${red}"
          "10=#${green}"
          "11=#${yellow}"
          "12=#${blue}"
          "13=#${magenta}"
          "14=#${cyan}"
          "15=#${white_bright}"
        ];
        palette-generate = true;
        selection-background = primary;
        selection-foreground = on_primary;
        background = surface;
        foreground = on_surface;
        background-opacity = opacity;
        cursor-color = on_surface;
        cursor-text = surface;
        cursor-style = "block";
        minimum-contrast = 1.1;
      };
    };
  };
}
