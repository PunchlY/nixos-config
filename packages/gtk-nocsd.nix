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
  version = "1.0.0-0.210";

  src = fetchFromCodeberg {
    owner = "MorsMortium";
    repo = "GTK-NoCSD";
    rev = "daf0652e6b4c4f0b10ca3e371ad8e0fc47c8b0fd";
    hash = "sha256-cy6Ilq8uhG98NQqXmyRPc72HIwYyhxXMcGGY6X1OUAg=";
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
