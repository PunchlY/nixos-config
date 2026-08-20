{
  buildPythonApplication,
  fetchFromGitHub,
  setuptools,
  hid,
  lib,
}:
buildPythonApplication (finalAttrs: {
  pname = "pywincontrols";
  version = "1.0.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pelrun";
    repo = "pyWinControls";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ySqogpUKVNjACCT+P6mrXxTD+4mBXACDb+48tdfls8U=";
  };

  preBuild = ''
    substituteInPlace gpdconfig/wincontrols/hardware.py --replace-fail "'K406'" "'K406','K121','K123'"
  '';

  nativeBuildInputs = [setuptools];
  propagatedBuildInputs = [
    hid
  ];

  meta = {
    description = "Python version of GPD's WinControls for the GPD Win Mini and Win 4";
    homepage = "https://github.com/pelrun/pywincontrols";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "gpdconfig";
  };
})
