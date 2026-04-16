{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.services.logind.enable {
    services.logind.settings.Login = {
      powerKey = "suspend";
      powerKeyLongPress = "poweroff";
      lidSwitch = "suspend";
      lidSwitchDocked = "ignore";
      lidSwitchExternalPower = "suspend";
    };
  };
}
