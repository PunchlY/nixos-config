{inputs, ...}: {
  flake-file.inputs = {
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  flake.nixosModules.base = {
    imports = [inputs.nix-index-database.nixosModules.default];

    # programs.nix-index.enable = false;
    programs.nix-index = {
      enableBashIntegration = false;
      enableZshIntegration = false;
      enableFishIntegration = false;
    };
    programs.nix-index-database.comma.enable = true;
  };
}
