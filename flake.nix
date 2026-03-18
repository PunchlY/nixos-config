{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    systems.url = "github:nix-systems/default";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    templates.url = "github:MordragT/nix-templates";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix.url = "github:ryantm/agenix";

    gpd-fan-driver = {
      url = "github:Cryolitia/gpd-fan-driver";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    jovian.url = "github:Jovian-Experiments/Jovian-NixOS";

    waydroid-script.url = "github:casualsnek/waydroid_script";

    aagl.url = "github:ezKEa/aagl-gtk-on-nix";

    md3.url = "github:PunchlY/md3";

    niri.url = "github:sodiboo/niri-flake";

    browser-previews = {
      url = "github:nix-community/browser-previews";
      inputs.nixpkgs.follows = "nixpkgs";
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
      systems,
      home-manager,
      ...
    }@inputs:
    let
      inherit (nixpkgs) lib;
      eachSystem = lib.genAttrs (import systems);
      readModules =
        path: builtins.map (name: path + "/${name}") (builtins.attrNames (builtins.readDir path));
    in
    {
      overlays.default =
        final: prev:
        builtins.listToAttrs (
          map (file: {
            name = builtins.replaceStrings [ ".nix" ] [ "" ] file;
            value = final.callPackage ./packages/${file} { };
          }) (builtins.attrNames (builtins.readDir ./packages))
        )
        // builtins.listToAttrs (
          map (file: {
            name = builtins.replaceStrings [ ".nix" ] [ "" ] file;
            value = import ./overlays/${file} final prev;
          }) (builtins.attrNames (builtins.readDir ./overlays))
        );

      packages = eachSystem (
        system:
        import nixpkgs {
          inherit system;
          overlays = [
            self.overlays.default
          ];
          config.allowUnfree = true;
        }
      );

      nixosConfigurations =
        builtins.mapAttrs
          (
            hostName:
            { system, users }:
            lib.nixosSystem {
              inherit system;
              specialArgs = inputs;
              modules = [
                home-manager.nixosModules.default
                {
                  networking.hostName = hostName;

                  nixpkgs = {
                    overlays = [
                      self.overlays.default
                    ];
                    config.allowUnfree = true;
                  };

                  home-manager = {
                    sharedModules = readModules ./modules/home;
                    extraSpecialArgs = inputs;
                  };
                }
              ]
              ++ (readModules ./modules/nixos)
              ++ (readModules ./host/${hostName})
              ++ (map (username: {
                home-manager.users.${username}.imports = readModules ./home/${username};
              }) users);
            }
          )
          {
            winmax2 = {
              system = "x86_64-linux";
              users = [ "punchly" ];
            };
            nixos = {
              system = "x86_64-linux";
              users = [ "punchly" ];
            };
          };
    };
}
