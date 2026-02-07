{
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "portty";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "WERDXZ";
    repo = "portty";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7nzPTeC2e2cOrWb8Z7di5qk8pLTgptnHRT1Qg31juYA=";
  };

  cargoHash = "sha256-HLuA0512SH7vE1+hbEFJlt0Xq5G2MuX/POlwoiFOYRA=";

  postPatch = ''
    substituteInPlace misc/portty.service \
      --replace-fail /usr/lib/portty/porttyd $out/libexec/porttyd
  '';
  installPhase = ''
    runHook preInstall

    releaseDir=target/${rustPlatform.cargoInstallHook.targetSubdirectory}/$cargoBuildType

    install -Dm755 $releaseDir/portty $out/bin/portty
    install -Dm755 $releaseDir/porttyd $out/libexec/porttyd
    install -Dm644 misc/tty.portal $out/share/xdg-desktop-portal/portals/tty.portal
    install -Dm644 misc/portty.service $out/lib/systemd/user/portty.service

    runHook postInstall
  '';
})
