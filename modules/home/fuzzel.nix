{
  nixosConfig,
  config,
  lib,
  ...
}:
let
  inherit (nixosConfig.theme) font colors opacity;
in
{
  config = lib.mkIf config.programs.fuzzel.enable {
    programs.fuzzel = {
      settings = {
        main = {
          font = "monospace:size=${toString font.size}";
          keyboard-focus = "on-demand";
          horizontal-pad = 16;
          vertical-pad = 8;
          inner-pad = 2;
          image-size-ratio = 1;
        };
        border = {
          width = 2;
          radius = 8;
          selection-radius = 8;
        };
        colors = with colors.hex_stripped; {
          background = "${surface}${lib.toHexString (builtins.ceil (opacity * 255))}";
          text = "${on_surface}ff";
          message = "${orange}ff";
          prompt = "${secondary}ff";
          placeholder = "${tertiary}ff";
          input = "${primary}ff";
          match = "${primary}ff";
          selection = "${primary}ff";
          selection-text = "${on_primary}ff";
          selection-match = "${on_primary}ff";
          counter = "${secondary}ff";
          border = "${primary}ff";
        };
      };
    };
  };
}
