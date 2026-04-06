{
  config,
  lib,
  ...
}: {
  hardware.bluetooth = lib.mkIf config.hardware.bluetooth.enable {
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
        FastConnectable = true;
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };
}
