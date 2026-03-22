{
  stdenv,
  requireFile,
  unzip,
}:
stdenv.mkDerivation {
  name = "PlantsVsZombiesRH";
  src = requireFile {
    name = "PlantsVsZombiesRH.zip";
    url = "https://wiki.biligame.com/pvzrh";
    hash = "sha256-5Orpgas80710KZzYayS8qkSAipCCmSuqxOSaZduyFOI=";
  };

  nativeBuildInputs = [
    unzip
  ];

  buildCommand = ''
    mkdir -p $out
    unzip $src -d $out
    mv "$out/#U690d#U7269#U5927#U6218#U50f5#U5c38#U878d#U5408#U72483.2/"* "$out" 
  '';
}
