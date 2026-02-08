{
  stdenv,
  linkFarm,
  fetchzip,
  fetchFromGitHub,
  fetchFromCodeberg,
  pkg-config,
  wayland-scanner,
  zig_0_15,
  libxkbcommon,
  pixman,
  fcft,
  wayland,
  wayland-protocols,
  lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kwm";
  version = "git";

  outputs = [
    "out"
  ];

  src = fetchFromGitHub {
    owner = "kewuaa";
    repo = "kwm";
    rev = "f11d4124462f173cd3155c70517c37cf0c1f5ad7";
    hash = "sha256-3UKOlxK1yZfFQ0OhVT0Mzq/9oR4NRJ5WW2hMAH+0t2g=";
  };

  deps = linkFarm "zig-packages" [
    {
      name = "pixman-0.3.0-LClMnz2VAAAs7QSCGwLimV5VUYx0JFnX5xWU6HwtMuDX";
      path = fetchzip {
        url = "https://codeberg.org/ifreund/zig-pixman/archive/v0.3.0.tar.gz";
        hash = "sha256-8tA4auo5FEI4IPnomV6bkpQHUe302tQtorFQZ1l14NU=";
      };
    }
    {
      name = "wayland-0.5.0-dev-lQa1kvTUAQCsD8AobfOXJA_-TVG-WTYXju68OZ8L85RM";
      path = fetchFromCodeberg {
        owner = "ifreund";
        repo = "zig-wayland";
        rev = "f2480d25764a50ed2fe29f49e4209c074a557f46";
        hash = "sha256-PosVlJ0FD80O46l0SYTWzfHFYfIE4Bdjqof/gttQ+KM=";
      };
    }
    {
      name = "xkbcommon-0.3.0-VDqIe3K9AQB2fG5ZeRcMC9i7kfrp5m2rWgLrmdNn9azr";
      path = fetchzip {
        url = "https://codeberg.org/ifreund/zig-xkbcommon/archive/v0.3.0.tar.gz";
        hash = "sha256-e5bPEfxl4SQf0cqccLt/py1KOW1+Q1+kWZUEXBbh9oQ=";
      };
    }
    {
      name = "mvzr-0.3.7-ZSOky5FtAQB2VrFQPNbXHQCFJxWTMAYEK7ljYEaMR6jt";
      path = fetchzip {
        url = "https://github.com/mnemnion/mvzr/archive/refs/tags/v0.3.7.tar.gz";
        hash = "sha256-RsnjkmsAZAuwO75S9Zy2dW117E6APOgHRKC2ReMAkik=";
      };
    }
    {
      name = "fcft-2.0.0-zcx6C5EaAADIEaQzDg5D4UvFFMjSEwDE38vdE9xObeN9";
      path = fetchzip {
        url = "https://git.sr.ht/~novakane/zig-fcft/archive/v2.0.0.tar.gz";
        hash = "sha256-qDEtiZNSkzN8jUSnZP/itqh8rMf+lakJy4xMB0I8sxQ=";
      };
    }
  ];

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
    zig_0_15.hook
  ];

  buildInputs = [
    libxkbcommon
    pixman
    fcft
    wayland
    wayland-protocols
  ];

  dontConfigure = true;

  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
  ];

  meta = {
    mainProgram = "kwm";
    platforms = lib.platforms.linux;
  };
})
