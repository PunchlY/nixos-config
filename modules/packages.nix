{
  inputs,
  lib,
  ...
}: let
  packages = lib.mapAttrs' (
    file: type:
      if type == "directory"
      then {
        name = file;
        value = ../packages/${file}/package.nix;
      }
      else if type == "regular" && lib.hasSuffix ".nix" file
      then {
        name = lib.removeSuffix ".nix" file;
        value = ../packages/${file};
      }
      else null
  ) (lib.readDir ../packages);
  devShells =
    lib.mapAttrs'
    (file: _: {
      name = file;
      value = ../packages/${file}/develop.nix;
    })
    (lib.filterAttrs (file: type: type == "directory" && builtins.pathExists ../packages/${file}/develop.nix) (lib.readDir ../packages));

  mkOverlays = packages: final: prev: let
    callPackage = final.newScope {inherit prev inputs;};
  in
    lib.mapAttrs (_: file: callPackage file {}) packages;
in {
  flake.overlays.default = mkOverlays packages;

  flake.nixosModules.base = {
    nixpkgs.overlays = [inputs.self.overlays.default];
  };

  perSystem = {system, ...}: {
    packages = lib.intersectAttrs packages (
      import inputs.nixpkgs {
        inherit system;
        overlays = [inputs.self.overlays.default];
      }
    );
    devShells = lib.intersectAttrs devShells (
      import inputs.nixpkgs {
        inherit system;
        overlays = [(mkOverlays devShells)];
      }
    );
  };
}
