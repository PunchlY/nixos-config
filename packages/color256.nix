{
  stdenv,
  fetchFromGitHub,
  python3,
}:
stdenv.mkDerivation (_finalAttrs: {
  pname = "color256";
  version = "1.0.0-0.44";

  src = fetchFromGitHub {
    owner = "jake-stewart";
    repo = "color256";
    rev = "155d840e5d64f6d3d1361e8aa92ae9e2389e1e12";
    hash = "sha256-QSx53IWyyypUuBarmPgFZw5PADdWk7oqK1cGOur2m5Y=";
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
