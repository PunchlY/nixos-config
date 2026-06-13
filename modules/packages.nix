{inputs, ...}: {
  imports = [inputs.flake-parts.flakeModules.easyOverlay];

  flake.modules.nixos.base = {
    nixpkgs.overlays = [inputs.self.overlays.default];
  };

  perSystem = {
    config,
    final,
    pkgs,
    lib,
    ...
  }: {
    overlayAttrs = config.packages;
    packages = let
      directory = ../packages;
      prev = pkgs;
      newScope = scope: final.newScope (scope // {inherit inputs prev;});
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
  };
}
