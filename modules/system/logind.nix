{lib, ...}: {
  flake.modules.nixos.base = {config, ...}: {
    config = lib.mkIf config.services.logind.enable {
      services.logind.settings.Login = {
        HandlePowerKey = lib.mkDefault "suspend";
        HandlePowerKeyLongPress = "poweroff";
        HandleLidSwitch = lib.mkDefault "suspend";
        HandleLidSwitchExternalPower = lib.mkDefault "suspend";
        HandleLidSwitchDocked = "ignore";
      };
    };
  };
}
