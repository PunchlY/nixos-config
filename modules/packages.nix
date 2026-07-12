{inputs, ...}: {
  imports = [
    inputs.flake-parts.flakeModules.easyOverlay
    ../packages
  ];

  nixpkgs.overlays = [inputs.self.overlays.default];

  perSystem = {config, ...}: {
    packages = config.overlayAttrs;
  };
}
