{
  stdenvNoCC,
  coreutils,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "steam-no-launch";
  version = "1.0.0";
  src = ./.;
  buildInputs = [coreutils];
  outputs = [
    "out"
    "steamcompattool"
  ];
  strictDeps = true;
  installPhase = ''
    runHook preInstall

    echo "${finalAttrs.pname} should not be installed into environments. Please use programs.steam.extraCompatPackages instead." > $out

    install -Dt $steamcompattool compatibilitytool.vdf toolmanifest.vdf
    ln -s ${coreutils}/bin/echo $steamcompattool

    runHook postInstall
  '';
})
