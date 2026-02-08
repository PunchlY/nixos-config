{
  llvmPackages,
  mpv,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "mpv-bilibili-sponsorblock";
  version = "0.1.1";
  src = fetchFromGitHub {
    owner = "test482";
    repo = "mpv-bilibili-sponsorblock";
    rev = "v${version}";
    sha256 = "sha256-W3H/mHmXIdmfH8k2wFXfalF4W7WDQIDAW0wo11n3V04=";
  };
  cargoHash = "sha256-SRFJum9+yDKxphOnzGCQ9vS5y7dZKY0CE7Scn8MmF8I=";
  nativeBuildInputs = [
    llvmPackages.libclang
    mpv
  ];
  buildPhase = ''
    runHook preBuild

    export LIBCLANG_PATH="${lib.getLib llvmPackages.libclang}/lib"
    export C_INCLUDE_PATH="${mpv}/include"
    cargo build --release --locked

    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall

    install -D ./target/release/libmpv_bilibili_sponsorblock.so -t $out/share/mpv/scripts/

    runHook postInstall
  '';
  passthru.scriptName = "libmpv_bilibili_sponsorblock.so";
}
