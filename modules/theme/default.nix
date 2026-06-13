{
  self,
  lib,
  ...
}: {
  flake.modules.nixos.theme = {options, ...}: {
    config = lib.optionalAttrs (options ? home-manager) {
      home-manager = {
        sharedModules = [self.modules.homeManager.theme];
      };
    };
  };
}
