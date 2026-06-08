{inputs, ...}: {
  flake-file.inputs = {
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  flake.nixosModules.base = {
    nixpkgs.overlays = [inputs.nur.overlays.default];
  };
}
