{
  jovian,
  aagl,
  waydroid-script,
  agenix,
  md3,
  ...
}@inputs:

[
  (final: prev: {
    # inherit (inputs) river-src;
  })
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
      fuzzel = prev.fuzzel.overrideAttrs (oldAttrs: {
        version = "1.14.0";
        src = final.fetchFromGitea {
          domain = "codeberg.org";
          owner = "dnkl";
          repo = "fuzzel";
          rev = "1.14.0";
          sha256 = "sha256-9O6CABh149ZtNu3sEhuycsM7pinVrBzU+rLxCAbxobs=";
        };
      });
      cmd-polkit = prev.cmd-polkit.overrideAttrs (oldAttrs: {
        version = "git";
        src = final.fetchFromGitHub {
          owner = "OmarCastro";
          repo = "cmd-polkit";
          rev = "0b52f76";
          sha256 = "sha256-vECq18kRlWvg/OMpa2H+vFqYRpCmeOAGI56DBWYF0lA=";
        };
      });
      yazi = prev.yazi.override {
        _7zz = prev._7zz-rar;
      };
    }
  )
  (
    final: prev:
    builtins.listToAttrs (
      map (file: {
        name = builtins.replaceStrings [ ".nix" ] [ "" ] file;
        value = final.callPackage ./pkgs/${file} { };
      }) (builtins.attrNames (builtins.readDir ./pkgs))
    )
  )
]
