{
  nixosConfig,
  config,
  lib,
  ...
}: let
  inherit (nixosConfig.theme) colors font opacity;
  alpha = lib.toHexString (builtins.ceil (opacity * 255));
in {
  config = lib.mkIf config.services.mako.enable {
    services.mako = {
      settings = with colors; {
        outer-margin = 0;
        margin = 8;
        padding = "8,16";
        # border-radius = 8;
        border-size = 2;
        default-timeout = 5000;
        font = "${font.name} ${toString font.size}";
        background-color = "${primary_container.hex}${alpha}";
        text-color = on_primary_container.hex;
        border-color = primary.hex;
        "urgency=low" = {
          background-color = "${secondary_container.hex}${alpha}";
          text-color = on_secondary_container.hex;
          border-color = secondary.hex;
        };
        "urgency=normal" = {
          background-color = "${primary_container.hex}${alpha}";
          text-color = on_primary_container.hex;
          border-color = primary.hex;
        };
        "urgency=high" = {
          default-timeout = 0;
          background-color = "${error_container.hex}${alpha}";
          text-color = on_error_container.hex;
          border-color = error.hex;
        };
      };
    };
  };
}
