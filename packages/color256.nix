{
  stdenv,
  fetchFromGitHub,
  python3,
}:
stdenv.mkDerivation (_finalAttrs: {
  pname = "color256";
  version = "git";

  src = fetchFromGitHub {
    owner = "jake-stewart";
    repo = "color256";
    rev = "49ffa647eb71d4510a8c2876c74cd5ae48566c9b";
    sha256 = "sha256-2EIG/jzW35ArjlN8ThQO5pVlp3IcnAPQayA3NwwMwZs=";
  };

  buildInputs = [
    python3
  ];

  installPhase = ''
    install -Dm755 color256.py $out/bin/color256
    install -Dm755 pipe.py $out/bin/pipe
  '';

  meta = {
    description = "Generate a full 256 palette from base16 your colors";
    homepage = "https://github.com/jake-stewart/color256";
    mainProgram = "color256";
  };
})
