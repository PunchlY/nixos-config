{config, ...}: {
  flake.nixosModules.theme = {
    home-manager = {
      sharedModules = [config.flake.homeModules.theme];
    };
  };
}
