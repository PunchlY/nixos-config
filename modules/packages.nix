{
  inputs,
  lib,
  ...
}: {
  flake.overlays.default = final: prev: let
    directory = ../packages;
    callPackage = final.newScope (self // {inherit prev inputs;});
    self = lib.concatMapAttrs (
      name: type: let
        path = "${directory}/${name}";
      in
        if type == "directory"
        then {
          "${name}" = callPackage "${path}/package.nix" {};
        }
        else if type == "regular" && lib.hasSuffix ".nix" name
        then {
          "${lib.removeSuffix ".nix" name}" = callPackage path {};
        }
        else {}
    ) (builtins.readDir directory);
  in
    self;

  flake.nixosModules.base = {
    nixpkgs.overlays = [inputs.self.overlays.default];
  };

  perSystem = {pkgs, ...}: {
    packages = inputs.self.overlays.default pkgs pkgs;
  };
}
