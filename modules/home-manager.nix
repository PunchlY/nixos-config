{
  self,
  inputs,
  ...
}: {
  flake-file.inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  imports = [inputs.home-manager.flakeModules.default];

  flake.modules.nixos.base = {
    imports = [inputs.home-manager.nixosModules.default];
    home-manager = {
      sharedModules = [self.modules.homeManager.nixos];
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";
    };
  };

  flake.modules.homeManager.nixos = {osConfig, ...}: {
    imports = [self.modules.homeManager.base];

    home.stateVersion = osConfig.system.stateVersion;
  };

  flake.homeModules = self.modules.homeManager;
}
