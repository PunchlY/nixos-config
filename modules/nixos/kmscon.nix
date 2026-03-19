{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.theme) colors font emoji;
  rgbToKmscon = name: with colors.rgb.${name}; "${toString r},${toString g},${toString b}";
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
        palette-black=${rgbToKmscon "black"}
        palette-red=${rgbToKmscon "red_dim"}
        palette-green=${rgbToKmscon "green_dim"}
        palette-yellow=${rgbToKmscon "yellow_dim"}
        palette-blue=${rgbToKmscon "blue_dim"}
        palette-magenta=${rgbToKmscon "magenta_dim"}
        palette-cyan=${rgbToKmscon "cyan_dim"}
        palette-light-grey=${rgbToKmscon "white"}
        palette-dark-grey=${rgbToKmscon "gray"}
        palette-light-red=${rgbToKmscon "red"}
        palette-light-green=${rgbToKmscon "green"}
        palette-light-yellow=${rgbToKmscon "yellow"}
        palette-light-blue=${rgbToKmscon "blue"}
        palette-light-magenta=${rgbToKmscon "magenta"}
        palette-light-cyan=${rgbToKmscon "cyan"}
        palette-light-white=${rgbToKmscon "white_bright"}
        palette-foreground=${rgbToKmscon "white"}
        palette-background=${rgbToKmscon "black"}
      '';
    };
  };
}
