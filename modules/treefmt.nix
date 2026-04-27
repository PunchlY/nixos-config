{inputs, ...}: {
  imports = [inputs.treefmt-nix.flakeModule];

  flake-file.inputs.treefmt-nix = {
    url = "github:numtide/treefmt-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  perSystem = {
    treefmt = {
      projectRootFile = "flake.nix";
      programs.deadnix = {
        enable = true;
        priority = 1;
      };

      programs.alejandra = {
        enable = true;
        priority = 2;
      };

      programs.just.enable = true;

      programs.shfmt.enable = true;

      programs.isort = {
        enable = true;
        priority = 1;
      };
      programs.black = {
        enable = true;
        priority = 2;
      };
    };
  };
}
