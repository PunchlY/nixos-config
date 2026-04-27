{config, ...}: {
  flake.nixosModules.base = {enableTheme, ...}:
    if enableTheme
    then {
      imports = [config.flake.nixosModules.theme];
      home-manager = {
        sharedModules = [config.flake.homeModules.theme];
      };
    }
    else {};
}
