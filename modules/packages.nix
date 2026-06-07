{
  inputs,
  lib,
  ...
}: {
  flake.overlays.default = final: prev: let
    directory = ../packages;
    newScope = scope: final.newScope (scope // {inherit prev inputs;});
  in
    lib.makeScope newScope (
      self:
        builtins.readDir directory
        |> lib.concatMapAttrs (
          name: type: let
            path = "${directory}/${name}";
          in
            if type == "directory"
            then {
              "${name}" = self.callPackage "${path}/package.nix" {};
            }
            else if type == "regular" && lib.hasSuffix ".nix" name
            then {
              "${lib.removeSuffix ".nix" name}" = self.callPackage path {};
            }
            else {}
        )
    )
    |> lib.flip builtins.removeAttrs [
      "callPackage"
      "newScope"
      "overrideScope"
      "packages"
    ];

  flake.nixosModules.base = {
    nixpkgs.overlays = [inputs.self.overlays.default];
  };

  perSystem = {pkgs, ...}: {
    packages = inputs.self.overlays.default pkgs pkgs;
  };
}
