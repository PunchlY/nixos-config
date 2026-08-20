{
  stdenv,
  requireFile,
  unzip,
}:
stdenv.mkDerivation {
  pname = "PlantsVsZombiesRH";
  version = "3.8.1";
  src = requireFile {
    name = "PlantsVsZombiesRH.zip";
    url = "https://wiki.biligame.com/pvzrh";
    hash = "sha256-PYIj1vhQmmvyuOOzMxpgyl3XGXCyctK1daCT55p5C3M=";
  };

  nativeBuildInputs = [
    unzip
  ];

  buildCommand = ''
    mkdir -p $out
    unzip $src -d .
    mv ./"#U690d#U7269#U5927#U6218#U50f5#U5c38#U878d#U5408#U72483.9/"* "$out"
  '';
}
