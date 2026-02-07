{
  config,
  lib,
  pkgs,
  gpd-fan-driver,
  ...
}:
let
  cfg = config.hardware.gpd;
in
{
  imports = [
    gpd-fan-driver.nixosModules.default
  ];

  options.hardware.gpd = {
    # Linux default PPT is 24-22-22, BIOS default PPT is 35-32-28. It can be controlled by ryzenadj.
    # NOTICE: Whenever you can limit PPT to 15W by pressing Fn + Shift to enter quiet mode.
    ppt = {
      enable = lib.mkEnableOption "Enable PPT control for device by ryzenadj." // {
        # Default increase PPT to the BIOS default when power adapter plugin to increase performance.
        default = false;
      };

      adapter = {
        fast-limit = lib.mkOption {
          description = "Fast PTT Limit(milliwatt) when power adapter plugin.";
          default = 35000;
          type = lib.types.ints.unsigned;
        };
        slow-limit = lib.mkOption {
          description = "Slow PTT Limit(milliwatt) when power adapter plugin.";
          default = 32000;
          type = lib.types.ints.unsigned;
        };
        stapm-limit = lib.mkOption {
          description = "Stapm PTT Limit(milliwatt) when power adapter plugin.";
          default = 28000;
          type = lib.types.ints.unsigned;
        };
      };

      battery = {
        fast-limit = lib.mkOption {
          description = "Fast PTT Limit(milliwatt) when using battery.";
          default = 24000;
          type = lib.types.ints.unsigned;
        };
        slow-limit = lib.mkOption {
          description = "Slow PTT Limit(milliwatt) when using battery.";
          default = 22000;
          type = lib.types.ints.unsigned;
        };
        stapm-limit = lib.mkOption {
          description = "Stapm PTT Limit(milliwatt) when using battery.";
          default = 22000;
          type = lib.types.ints.unsigned;
        };
      };
    };
  };

  config = lib.mkIf cfg.ppt.enable {
    environment.systemPackages = [ pkgs.ryzenadj ];
    services.udev.extraRules = ''
      SUBSYSTEM=="power_supply", KERNEL=="ADP1", ATTR{online}=="1", RUN+="${pkgs.ryzenadj}/bin/ryzenadj --stapm-limit ${toString cfg.ppt.adapter.stapm-limit} --fast-limit ${toString cfg.ppt.adapter.fast-limit} --slow-limit ${toString cfg.ppt.adapter.slow-limit}"
      SUBSYSTEM=="power_supply", KERNEL=="ADP1", ATTR{online}=="0", RUN+="${pkgs.ryzenadj}/bin/ryzenadj --stapm-limit ${toString cfg.ppt.battery.stapm-limit} --fast-limit ${toString cfg.ppt.battery.fast-limit} --slow-limit ${toString cfg.ppt.battery.slow-limit}"
    '';
  };
}
