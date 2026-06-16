{
  stdenvNoCC,
  runCommandLocal,
  bun2nix,
  bun,
  lib,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "bun-types";
  version = "1.3.14";
  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./package.json
      ./bun.lock
    ];
  };

  bunDeps = bun2nix.fetchBunDeps {
    bunNix = ./bun.nix;
    overrides = {
      "typescript@6.0.3" = pkg:
        runCommandLocal "typescript-patched" {
          src = pkg;
          push = ''
            /// <reference path="../../@types/bun/index.d.ts" />
          '';
        } ''
          cp -R "$src" "$out"
          chmod -R u+w "$out"
          echo "$push" >> "$out/lib/lib.esnext.d.ts"
        '';
    };
  };

  nativeBuildInputs = [bun];

  buildPhase = ''
    export BUN_INSTALL_CACHE_DIR="$(mktemp -d)"
    cp -r "$bunDeps"/share/bun-cache/. "$BUN_INSTALL_CACHE_DIR"
    bun install --linker hoisted
  '';

  installPhase = ''
    mkdir $out
    mv * $out
  '';

  passthru.tsdk.path = "${finalAttrs.finalPackage}/node_modules/typescript/lib";
})
