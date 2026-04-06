{
  config,
  lib,
  ...
}: let
  inherit (config.theme) colors;
in {
  config = lib.mkIf config.console.enable {
    console = {
      colors = builtins.genList (i: colors."color${toString i}".hex_stripped) 16;
    };
  };
}
