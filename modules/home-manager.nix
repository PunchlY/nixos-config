{
  config,
  inputs,
  ...
}: {
  flake-file.inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  flake.modules.nixos.base = {
    imports = [inputs.home-manager.nixosModules.default];
    home-manager = {
      sharedModules = [config.flake.modules.homeManager.nixos];
      useGlobalPkgs = true;
      # useUserPackages = true;
      backupFileExtension = "backup";
    };
  };

  flake.modules.homeManager.nixos = {nixosConfig, ...}: {
    imports = [config.flake.modules.homeManager.base];

    home.stateVersion = nixosConfig.system.stateVersion;
  };
}
