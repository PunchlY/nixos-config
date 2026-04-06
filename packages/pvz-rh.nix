{
  stdenv,
  requireFile,
  unzip,
}:
stdenv.mkDerivation {
  name = "PlantsVsZombiesRH";
  version = "v3.5.0";
  src = requireFile {
    name = "PlantsVsZombiesRH.zip";
    url = "https://wiki.biligame.com/pvzrh";
    hash = "sha256-Wbbat6fFetlf4Lm2jbPRdvC1VCRJxIEbjCayH/Yinx0=";
  };

  nativeBuildInputs = [
    unzip
  ];

  buildCommand = ''
    mkdir -p $out
    unzip $src -d $out
    mv "$out/#U690d#U7269#U5927#U6218#U50f5#U5c38#U878d#U5408#U72483.5/"* "$out"
  '';
}
