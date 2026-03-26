{
  nixosConfig,
  config,
  lib,
  ...
}:
let
  inherit (nixosConfig.theme) font colors wallpaper;
in
{
  config = lib.mkIf config.programs.swaylock.enable {
    programs.swaylock = {
      settings = with colors; {
        image = "${wallpaper}";

        color = background.hex_stripped;
        inside-color = surface_container.hex_stripped;
        inside-clear-color = secondary_container.hex_stripped;
        inside-ver-color = primary_container.hex_stripped;
        inside-wrong-color = error_container.hex_stripped;
        inside-caps-lock-color = orange.hex_stripped;
        ring-color = primary.hex_stripped;
        ring-clear-color = secondary.hex_stripped;
        ring-ver-color = primary.hex_stripped;
        ring-wrong-color = error.hex_stripped;
        ring-caps-lock-color = orange.hex_stripped;
        text-color = on_background.hex_stripped;
        text-clear-color = on_secondary_container.hex_stripped;
        text-ver-color = on_primary_container.hex_stripped;
        text-wrong-color = on_error_container.hex_stripped;
        text-caps-lock-color = on_orange.hex_stripped;
        key-hl-color = cyan.hex_stripped;
        layout-bg-color = surface_container_low.hex_stripped;
        layout-border-color = outline_variant.hex_stripped;
        layout-text-color = on_surface_variant.hex_stripped;
        separator-color = "00000000";
        line-uses-inside = true;
      };
    };
  };
}
