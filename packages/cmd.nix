{
  stdenv,
  fetchFromGitHub,
  lib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "cmd";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "ChenPi11";
    repo = "cmd";
    tag = finalAttrs.version;
    hash = "sha256-apAHt/jpZf5MxRlxiO40x0mOtBvYe4ZKiMV+Ym8E1CE=";
  };

  makeFlags = [
    "PREFIX=$(out)"
  ];

  preInstall = ''
    mkdir -p $out/bin
  '';

  meta = {
    description = "A faithful reimplementation of the Windows `cmd.exe` command interpreter for Unix.";
    homepage = "https://github.com/ChenPi11/cmd";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
  };
})
