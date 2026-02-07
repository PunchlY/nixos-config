{
  nixosConfig,
  lib,
  ...
}:
let
  inherit (nixosConfig.theme) font colors wallpaper;
in
{
  config = lib.mkIf config.programs.swaylock.enable {
    programs.swaylock = {
      enable = true;
      settings = with colors.hex_stripped; {
        image = "${wallpaper}";

        color = background;
        inside-color = surface_container;
        inside-clear-color = secondary_container;
        inside-ver-color = primary_container;
        inside-wrong-color = error_container;
        inside-caps-lock-color = orange;
        ring-color = primary;
        ring-clear-color = secondary;
        ring-ver-color = primary;
        ring-wrong-color = error;
        ring-caps-lock-color = orange;
        text-color = on_background;
        text-clear-color = on_secondary_container;
        text-ver-color = on_primary_container;
        text-wrong-color = on_error_container;
        text-caps-lock-color = on_orange;
        key-hl-color = cyan;
        layout-bg-color = surface_container_low;
        layout-border-color = outline_variant;
        layout-text-color = on_surface_variant;
        separator-color = "00000000";
        line-uses-inside = true;
      };
    };
  };
}
