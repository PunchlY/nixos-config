{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.theme) colors font emoji;
  rgbToKmscon = name: with colors.${name}.rgb; "${toString r},${toString g},${toString b}";
in
{
  config = lib.mkIf config.services.kmscon.enable {
    services.kmscon = {
      fonts = [
        { inherit (font) name package; }
        { inherit (emoji) name package; }
      ];
      extraConfig = ''
        font-size=${toString font.size}
        palette=custom
        palette-black=${rgbToKmscon "color0"}
        palette-red=${rgbToKmscon "color1"}
        palette-green=${rgbToKmscon "color2"}
        palette-yellow=${rgbToKmscon "color3"}
        palette-blue=${rgbToKmscon "color4"}
        palette-magenta=${rgbToKmscon "color5"}
        palette-cyan=${rgbToKmscon "color6"}
        palette-light-grey=${rgbToKmscon "color7"}
        palette-dark-grey=${rgbToKmscon "color8"}
        palette-light-red=${rgbToKmscon "color9"}
        palette-light-green=${rgbToKmscon "color10"}
        palette-light-yellow=${rgbToKmscon "color11"}
        palette-light-blue=${rgbToKmscon "color12"}
        palette-light-magenta=${rgbToKmscon "color13"}
        palette-light-cyan=${rgbToKmscon "color14"}
        palette-light-white=${rgbToKmscon "color15"}
        palette-foreground=${rgbToKmscon "on_surface"}
        palette-background=${rgbToKmscon "surface"}
      '';
    };
  };
}
