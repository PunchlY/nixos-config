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
    rev = "47aff2ba9f68e4f9ff6209aef88b5abff8b18c79";
    hash = "sha256-krxVVfFrzQ5u29Ywas7BAbNGs1GgWPhqi0DiSRUBH8Q=";
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
