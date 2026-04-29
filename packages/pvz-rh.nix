{
  stdenv,
  requireFile,
  unzip,
}:
stdenv.mkDerivation {
  pname = "PlantsVsZombiesRH";
  version = "3.6.1";
  src = requireFile {
    name = "PlantsVsZombiesRH.zip";
    url = "https://wiki.biligame.com/pvzrh";
    hash = "sha256-duhtgXHrIuMATlxpUroWDsfidaaOrWWEIM6B6kVauPM=";
  };

  nativeBuildInputs = [
    unzip
  ];

  buildCommand = ''
    mkdir -p $out
    unzip $src -d .
    mv ./"#U690d#U7269#U5927#U6218#U50f5#U5c38#U878d#U5408#U72483.6.1/"* "$out"
  '';
}
