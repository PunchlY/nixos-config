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
}:
stdenv.mkDerivation (_finalAttrs: {
  pname = "wayllpaper";
  version = "0.1.0";

  src = fetchgit {
    url = "https://git.sr.ht/~kennylevinsen/wayllpaper";
    rev = "cc60f668b584e61591fb99dc101353f16c0e1fcc";
    hash = "sha256-g7yAaJsQpCVKBzRbVhKt7gPjb3y7k3aWCHuvjodGciE=";
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
  ];

  mesonBuildType = "release";

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=maybe-uninitialized"
  ];

  meta = {
    description = "Likely the fastest, least user-friendly, and worst named Wayland wallpaper utility possible.";
    homepage = "https://git.sr.ht/~kennylevinsen/wayllpaper";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "wayllpaper";
  };
})
