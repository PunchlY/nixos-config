{
  stdenv,
  fetchFromCodeberg,
  pkg-config,
  libadwaita,
  symlinkJoin,
  makeWrapper,
  lib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gtk-nocsd";
  version = "git";

  src = fetchFromCodeberg {
    owner = "MorsMortium";
    repo = "GTK-NoCSD";
    rev = "cd02481fc0";
    hash = "sha256-dJ2pLttriA47msgGSGEk952frkB2iq5vPF04JB6OiNg=";
  };

  nativeBuildInputs = [
    pkg-config
    libadwaita
  ];

  makeFlags = [
    "DESTDIR=$(out)"
    "PREFIX="
  ];

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
})
