{
  stdenvNoCC,
  bun2nix,
  bun,
  lib,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "bun-types";
  version = "1.4.0";
  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./package.json
      ./bun.lock
    ];
  };

  bunDeps = bun2nix.fetchBunDeps {
    bunNix = ./bun.nix;
  };

  nativeBuildInputs = [bun];

  env.BUN_INSTALL_CACHE_DIR = "${finalAttrs.bunDeps}/share/bun-cache";

  installPhase = ''
    runHook preInstall
    mkdir $out
    cp -R . $out
    env -C $out bun install --linker hoisted
    runHook postInstall
  '';

  fixupPhase = ''
    runHook preFixup
    file=$out/node_modules/typescript/lib/lib.esnext.d.ts
    chmod u+w "$file"
    cat <<EOF >> $file
    /// <reference path="../../bun-types/index.d.ts" />
    EOF
    chmod u-w "$file"
    runHook postFixup
  '';

  passthru.tsdk.path = "${finalAttrs.finalPackage}/node_modules/typescript/lib";
})
