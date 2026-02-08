{
  config,
  pkgs,
  lib,
  jovian,
  ...
}:
{
  imports = [
    jovian.nixosModules.default
  ];

  jovian.steam.environment.PROTON_USE_RAW_INPUT = "1";

}
