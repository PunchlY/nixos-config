{self, ...}: {
  flake.modules.nixos.theme = {
    home-manager = {
      sharedModules = [self.modules.homeManager.theme];
    };
  };
}
