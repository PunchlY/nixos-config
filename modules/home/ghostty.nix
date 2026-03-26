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
      themes.md3 = with colors; {
        palette = builtins.genList (i: "${toString i}=${colors."color${toString i}".hex}") 256;
        palette-generate = true;
        selection-background = primary.hex_stripped;
        selection-foreground = on_primary.hex_stripped;
        background = surface.hex_stripped;
        foreground = on_surface.hex_stripped;
        background-opacity = opacity.hex_stripped;
        cursor-color = on_surface.hex_stripped;
        cursor-text = surface.hex_stripped;
        cursor-style = "block";
        minimum-contrast = 1.1;
      };
    };
  };
}
