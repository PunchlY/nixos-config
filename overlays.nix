{
  jovian,
  aagl,
  waydroid-script,
  agenix,
  md3,
  ...
}@inputs:

[
  jovian.overlays.default
  aagl.overlays.default
  agenix.overlays.default
  (
    final: prev:
    let
      inherit (prev.stdenvNoCC.hostPlatform) system;
    in
    {
      md3 = md3.packages.${system}.default;
      waydroid-script = waydroid-script.packages.${system}.default;
    }
  )
  (
    final: prev:
    builtins.listToAttrs (
      map (file: {
        name = builtins.replaceStrings [ ".nix" ] [ "" ] file;
        value = final.callPackage ./packages/${file} { };
      }) (builtins.attrNames (builtins.readDir ./packages))
    )
  )
  (
    final: prev:
    builtins.listToAttrs (
      map (file: {
        name = builtins.replaceStrings [ ".nix" ] [ "" ] file;
        value = import ./overlays/${file} final prev;
      }) (builtins.attrNames (builtins.readDir ./overlays))
    )
  )
]
