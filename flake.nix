{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    treefmt-nix.url = "github:numtide/treefmt-nix";

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

  outputs = inputs: let
    inherit (inputs.nixpkgs) lib;
    eachSystem = lib.genAttrs (import inputs.systems);

    treefmtEval = eachSystem (system: inputs.treefmt-nix.lib.evalModule inputs.nixpkgs.legacyPackages.${system} ./treefmt.nix);

    readModules = path: lib.map (name: path + "/${name}") (lib.attrNames (lib.readDir path));

    callFunctionWith = autoArgs: fn:
      if lib.isFunction fn
      then (fn (lib.intersectAttrs (lib.functionArgs fn) autoArgs))
      else fn;

    packages = lib.mapAttrs' (file: _: {
      name = lib.removeSuffix ".nix" file;
      value = ./packages/${file};
    }) (lib.readDir ./packages);

    me = callFunctionWith inputs (import ./me.nix);

    nixpkgsConfig = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "python3.12-ecdsa-0.19.1"
      ];
    };
  in {
    overlays.default = final: prev: let
      callPackage = final.newScope {inherit prev inputs;};
    in
      lib.mapAttrs (_: file: callPackage file {}) packages;

    packages = eachSystem (
      system:
        lib.intersectAttrs packages (
          import inputs.nixpkgs {
            inherit system;
            overlays = [
              inputs.self.overlays.default
            ];
            config = nixpkgsConfig;
          }
        )
    );

    formatter = eachSystem (system: treefmtEval.${system}.config.build.wrapper);

    checks = eachSystem (system: {
      formatting = treefmtEval.${system}.config.build.check inputs.self;
    });

    nixosConfigurations =
      lib.mapAttrs
      (
        hostName: {system}:
          lib.nixosSystem {
            inherit system;
            specialArgs = {
              inherit inputs me;
            };
            modules =
              [
                inputs.home-manager.nixosModules.default
                {
                  networking.hostName = hostName;

                  nixpkgs = {
                    overlays = [
                      inputs.self.overlays.default
                    ];
                    config = nixpkgsConfig;
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
