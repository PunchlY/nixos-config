{inputs, ...}: {
  flake-file.inputs = {
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  flake.modules.nixos.base = {
    nixpkgs.overlays = [inputs.nur.overlays.default];
  };
}
