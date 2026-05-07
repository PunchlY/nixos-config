{
  inputs,
  lib,
  ...
}: let
  packages =
    lib.readDir ../packages
    |> lib.mapAttrs' (
      fileName: type:
        if type == "directory"
        then {
          name = fileName;
          value = ../packages/${fileName}/package.nix;
        }
        else if type == "regular" && lib.hasSuffix ".nix" fileName
        then {
          name = lib.removeSuffix ".nix" fileName;
          value = ../packages/${fileName};
        }
        else null
    );
  devShells =
    lib.readDir ../packages
    |> lib.filterAttrs (file: type: type == "directory" && builtins.pathExists ../packages/${file}/develop.nix)
    |> lib.mapAttrs (fileName: _: ../packages/${fileName}/develop.nix);

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
