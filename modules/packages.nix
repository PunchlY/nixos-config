{
  inputs,
  lib,
  ...
}: {
  flake.overlays.default = final: prev: let
    newScope = extra: lib.callPackageWith (final // extra // {inherit prev inputs;});
  in
    lib.filesystem.packagesFromDirectoryRecursive {
      inherit newScope;
      callPackage = newScope {};
      directory = ../packages;
    };

  flake.nixosModules.base = {
    nixpkgs.overlays = [inputs.self.overlays.default];
  };

  perSystem = {
    self',
    pkgs,
    ...
  }: {
    packages = inputs.self.overlays.default pkgs pkgs;
    devShells =
      lib.mapAttrsRecursiveCond
      (as: !lib.isDerivation as)
      (
        _path: package:
          (
            if package.stdenv.hasCC
            then pkgs.mkShell
            else pkgs.mkShellNoCC
          ) {
            packages = with pkgs; [bashInteractive];
            inputsFrom = [package];
          }
      )
      self'.packages;
  };
}
