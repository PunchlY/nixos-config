{
  stdenv,
  fetchFromCodeberg,
  pkg-config,
  libadwaita,
  glib,
  symlinkJoin,
  makeWrapper,
  execline,
  lib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gtk-nocsd";
  version = "4.3";

  src = fetchFromCodeberg {
    owner = "MorsMortium";
    repo = "GTK-NoCSD";
    tag = finalAttrs.version;
    hash = "sha256-Luzib8zWL/Spsdz5cCxlCQLienhG4X0Qwald/Fw3FUY=";
  };

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    libadwaita
    glib
  ];

  makeFlags = [
    "DESTDIR=$(out)"
    "PREFIX="
    "NOOPT=1"
    "NODOC=1"
  ];

  postInstall = ''
    makeWrapper ${lib.getExe' execline "exec"} "$out/bin/gtk-nocsd" \
      --prefix LD_PRELOAD : "$out/lib/libgtk-nocsd.so"
  '';

  passthru.wrapper = package:
    symlinkJoin {
      name = "${package.name}-nocsd";
      paths = [package];
      buildInputs = [makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/${lib.escapeShellArg package.meta.mainProgram} \
          --prefix LD_PRELOAD : "${finalAttrs.finalPackage}/lib/libgtk-nocsd.so"
      '';
    };

  meta = {
    description = "An LD_PRELOAD library to disable CSD in GTK3/4, LibHandy, and LibAdwaita apps.";
    homepage = "https://codeberg.org/MorsMortium/GTK-NoCSD";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
