{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    templates.url = "github:MordragT/nix-templates";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    gpd-fan-driver = {
      url = "github:Cryolitia/gpd-fan-driver";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    jovian.url = "github:Jovian-Experiments/Jovian-NixOS";

    waydroid-script = {
      url = "github:casualsnek/waydroid_script";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    md3 = {
      url = "github:PunchlY/md3";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    filestash.url = "github:dermetfan/filestash.nix";
  };

  inputs = {
    river-src = {
      url = "github:riverwm/river";
      flake = false;
    };
  };

  nixConfig.substituters = [
    "https://mirrors.ustc.edu.cn/nix-channels/store"
    "https://nix-community.cachix.org"
    "https://cache.nixos.org"
  ];
  nixConfig.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      home-manager,
      agenix,
      ...
    }@inputs:
    let
      lib = nixpkgs.lib;
      overlays = import ./overlays.nix inputs;
      importAll =
        path: builtins.map (name: path + "/${name}") (builtins.attrNames (builtins.readDir path));
    in
    flake-utils.lib.eachDefaultSystem (system: {
      packages = import nixpkgs {
        inherit system overlays;
      };
    })
    // {
      nixosConfigurations.winmax2 =
        let
          system = "x86_64-linux";
          username = "punchly";
          specialArgs = inputs;
        in
        lib.nixosSystem {
          inherit system specialArgs;
          modules = [
            home-manager.nixosModules.default
            agenix.nixosModules.default
          ]
          ++ (importAll ./modules)
          ++ (importAll ./host)
          ++ (lib.singleton {
            nixpkgs = {
              inherit overlays;
              config = {
                allowUnfree = true;
                allowBroken = true;
              };
            };

            nix.registry = {
              nixpkgs.flake = nixpkgs;
              self.flake = self;
              templates.flake = inputs.templates;
            };

            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              extraSpecialArgs = specialArgs;
              users.${username} = {
                imports = importAll ./home;
                home = {
                  inherit username;
                  homeDirectory = "/home/${username}";
                };
              };
            };
          });
        };
    };
}
