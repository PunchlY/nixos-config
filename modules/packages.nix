{inputs, ...}: {
  imports = [
    inputs.flake-parts.flakeModules.easyOverlay
    ../packages
  ];

  flake.modules.nixos.base = {
    nixpkgs.overlays = [inputs.self.overlays.default];
  };

  perSystem = {
    system,
    config,
    ...
  }: {
    packages = config.overlayAttrs;

    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  };
}
