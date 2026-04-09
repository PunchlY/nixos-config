{
  nixosConfig,
  config,
  lib,
  ...
}: let
  inherit (nixosConfig.theme) font colors opacity;
  cfg = config.programs.swayimg;
  opacity_hex = lib.fixedWidthString 2 "0" (lib.toHexString (builtins.ceil (opacity * 255)));
in {
  config = lib.mkIf cfg.enable {
    xdg.mimeApps.defaultApplicationPackages = [
      cfg.package
    ];
    programs.swayimg = {
      settings = with colors; {
        font = {
          name = font.name;
          size = font.size;
          color = "${on_surface.hex}ff";
          shadow = "#00000000";
          # shadow = "${shadow.hex}ff";
          # background = "#00000000";
          background = "${surface.hex}${opacity_hex}";
        };
        viewer = {
          window = "${surface.hex}${opacity_hex}";
          transparency = "grid";
        };
        slideshow = {
          window = "${surface.hex}${opacity_hex}";
          transparency = "#000000ff";
        };
        gallery = {
          select = "${surface_bright.hex}ff";
          background = "${surface_dim.hex}ff";
          border_color = "${primary.hex}ff";
          window = "${surface.hex}${opacity_hex}";
        };
      };
    };
  };
}
