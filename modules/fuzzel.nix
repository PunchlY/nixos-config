{lib, ...}: {
  flake.homeModules.base = {config, ...}: {
    config = lib.mkIf config.programs.fuzzel.enable {
      programs.fuzzel = {
        settings = {
          main = {
            keyboard-focus = "on-demand";
          };
        };
      };
    };
  };

  flake.homeModules.theme = {
    osConfig,
    config,
    ...
  }: let
    inherit (osConfig.theme) font colors opacity;
  in {
    config = lib.mkIf config.programs.fuzzel.enable {
      programs.fuzzel = {
        settings = {
          main = {
            font = "monospace:size=${toString font.size}";
            horizontal-pad = 16;
            vertical-pad = 8;
            inner-pad = 2;
            image-size-ratio = 1;
          };
          border = {
            width = 2;
            radius = 0;
            selection-radius = 0;
          };
          colors = with colors; {
            background = "${surface.hex_stripped}${
              lib.fixedWidthString 2 "0" (lib.toHexString (builtins.ceil (opacity * 255)))
            }";
            text = "${on_surface.hex_stripped}ff";
            message = "${yellow.hex_stripped}ff";
            prompt = "${secondary.hex_stripped}ff";
            placeholder = "${tertiary.hex_stripped}ff";
            input = "${primary.hex_stripped}ff";
            match = "${primary.hex_stripped}ff";
            selection = "${primary.hex_stripped}ff";
            selection-text = "${on_primary.hex_stripped}ff";
            selection-match = "${on_primary.hex_stripped}ff";
            counter = "${secondary.hex_stripped}ff";
            border = "${primary.hex_stripped}ff";
          };
        };
      };
    };
  };
}
