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

  imports = [inputs.home-manager.flakeModules.default];

  flake.nixosModules.base = {
    imports = [inputs.home-manager.nixosModules.default];
    home-manager = {
      sharedModules = [config.flake.homeModules.nixos];
      useGlobalPkgs = true;
      # useUserPackages = true;
      backupFileExtension = "backup";
    };
  };

  flake.homeModules.nixos = {nixosConfig, ...}: {
    imports = [config.flake.homeModules.base];

    home.stateVersion = nixosConfig.system.stateVersion;
  };
}
