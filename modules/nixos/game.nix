{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [
    inputs.jovian.nixosModules.default
  ];

  jovian.steam = lib.mkIf config.jovian.steam.enable {
    user = config.user.name;
    environment.PROTON_USE_RAW_INPUT = "1";
  };

  services.displayManager.defaultSession = lib.mkIf config.jovian.steam.autoStart (
    lib.mkForce config.jovian.steam.desktopSession
  );
}
