{
  config,
  lib,
  ...
}:
let
  inherit (config.programs.kdeconnect) enable package;
in
{
  config.home-manager.sharedModules = lib.singleton {
    services.kdeconnect = lib.mkIf enable {
      inherit package;
      enable = lib.mkDefault true;
      indicator = lib.mkDefault true;
    };
  };
}
