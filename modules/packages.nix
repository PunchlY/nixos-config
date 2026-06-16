{inputs, ...}: {
  imports = [
    inputs.flake-parts.flakeModules.easyOverlay
    ../packages
  ];

  flake.modules.nixos.base = {
    nixpkgs.overlays = [inputs.self.overlays.default];
  };

  perSystem = {config, ...}: {
    packages = config.overlayAttrs;
  };
}
