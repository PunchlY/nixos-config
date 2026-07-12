{
  config,
  self,
  lib,
  ...
}: {
  options.nixpkgs = {
    config = {
      allowUnfreePackages = lib.mkOption {
        type = lib.types.listOf lib.types.singleLineStr;
        default = [];
      };
      permittedInsecurePackages = lib.mkOption {
        type = lib.types.listOf lib.types.singleLineStr;
        default = [];
      };
    };
  };

  config = {
    flake-file.inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    flake-file.nixConfig = {
      substituters = [
        "https://mirrors.ustc.edu.cn/nix-channels/store"
        "https://nix-community.cachix.org"
        "https://cache.nixos.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    flake.nixosModules = self.modules.nixos;

    flake.modules.nixos.base = {
      nixpkgs.config = config.nixpkgs.config;
    };
  };
}
