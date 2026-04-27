{lib, ...}: {
  flake.homeModules.base = {config, ...}: {
    config = lib.mkIf config.programs.imv.enable {
      xdg.mimeApps.defaultApplicationPackages = [
        config.programs.imv.package
      ];
      programs.imv = {
        settings.options = {
          overlay = true;
          overlay_text = ''$imv_current_index/$imv_file_count — $(basename -- "$imv_current_file")  [$imv_scale%]'';
          title_text = ''$(basename -- "$imv_current_file")'';
        };
      };
    };
  };

  flake.homeModules.theme = {
    nixosConfig,
    config,
    ...
  }: let
    inherit (nixosConfig.theme) font colors opacity;
  in {
    config = lib.mkIf config.programs.imv.enable {
      programs.imv = {
        settings.options = with colors; {
          background = surface.hex_stripped;
          overlay_text_color = on_surface.hex_stripped;
          overlay_font = "monospace:${toString font.size}";
          overlay_background_color = surface.hex_stripped;
          overlay_background_alpha = lib.fixedWidthString 2 "0" (
            lib.toHexString (builtins.ceil (opacity * 255))
          );
        };
      };
    };
  };
}
