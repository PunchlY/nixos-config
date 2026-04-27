{
  inputs,
  lib,
  ...
}: let
  packages = lib.mapAttrs' (file: _: {
    name = lib.removeSuffix ".nix" file;
    value = ../packages/${file};
  }) (lib.readDir ../packages);
in {
  flake.overlays.default = final: prev: let
    callPackage = final.newScope {inherit prev inputs;};
  in
    lib.mapAttrs (_: file: callPackage file {}) packages;

  flake.modules.nixos.base = {
    nixpkgs.overlays = [inputs.self.overlays.default];
  };

  perSystem = {system, ...}: {
    packages = lib.intersectAttrs packages (
      import inputs.nixpkgs {
        inherit system;
        overlays = [
          inputs.self.overlays.default
        ];
      }
    );
  };
}
