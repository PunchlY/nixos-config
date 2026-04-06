{
  stdenv,
  lib,
  fetchgit,
  pkg-config,
  meson,
  ninja,
  wayland,
  wayland-scanner,
  wayland-protocols,
  cairo,
  libgbm,
}:
stdenv.mkDerivation (_finalAttrs: {
  pname = "wleird";
  version = "git";

  src = fetchgit {
    url = "https://gitlab.freedesktop.org/emersion/wleird.git";
    rev = "73439834b73d2a5ea68ce6725f625e0e08d96279";
    hash = "sha256-2rWSBtrw61l7ofpnxFj+zRvoHUmuwBlslbhhGNl5Y08=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    wayland-scanner
  ];

  buildInputs = [
    wayland
    wayland-protocols
    cairo
    libgbm
  ];

  mesonBuildType = "release";

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error"
  ];

  meta = {
    description = "A collection a Wayland clients doing weird things, for compositor testing";
    homepage = "https://gitlab.freedesktop.org/emersion/wleird";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
})
