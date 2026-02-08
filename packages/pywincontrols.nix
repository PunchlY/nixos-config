{
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "pywincontrols";
  version = "1.0.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pelrun";
    repo = "pyWinControls";
    rev = "v${version}";
    hash = "sha256-ySqogpUKVNjACCT+P6mrXxTD+4mBXACDb+48tdfls8U=";
  };

  preBuild = ''
    sed -i "s/'K406'/'K406','K121','K123'/" gpdconfig/wincontrols/hardware.py
  '';

  nativeBuildInputs = [ python3Packages.setuptools ];
  propagatedBuildInputs = with python3Packages; [
    hid
  ];

  meta.mainProgram = "gpdconfig";
}
