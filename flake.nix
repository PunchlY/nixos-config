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

    jovian.url = "github:Jovian-Experiments/Jovian-NixOS";

    waydroid-script.url = "github:casualsnek/waydroid_script";

    md3.url = "github:PunchlY/md3";

    niri.url = "github:sodiboo/niri-flake";

    browser-previews = {
      url = "github:nix-community/browser-previews";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    yazi.url = "github:sxyazi/yazi";
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
    inputs:
    let
      inherit (inputs.nixpkgs) lib;
      eachSystem = lib.genAttrs (import inputs.systems);
      readModules =
        path: builtins.map (name: path + "/${name}") (builtins.attrNames (builtins.readDir path));
      me = import ./me.nix;
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
        import inputs.nixpkgs {
          inherit system;
          overlays = [
            inputs.self.overlays.default
          ];
          config.allowUnfree = true;
        }
      );

      nixosConfigurations =
        builtins.mapAttrs
          (
            hostName:
            { system }:
            lib.nixosSystem {
              inherit system;
              specialArgs = {
                inherit inputs me;
              };
              modules = [
                inputs.home-manager.nixosModules.default
                {
                  networking.hostName = hostName;

                  nixpkgs = {
                    overlays = [
                      inputs.self.overlays.default
                    ];
                    config.allowUnfree = true;
                  };

                  nix.registry.self.flake = inputs.self;

                  home-manager = {
                    sharedModules = readModules ./modules/home;
                    extraSpecialArgs = {
                      inherit inputs me;
                    };
                    useGlobalPkgs = true;
                    useUserPackages = true;
                    backupFileExtension = "backup";
                  };
                }
              ]
              ++ (readModules ./modules/nixos)
              ++ (readModules ./host/${hostName});
            }
          )
          {
            winmax2.system = "x86_64-linux";
            nixos.system = "x86_64-linux";
          };
    };
}
