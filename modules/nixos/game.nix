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
}
