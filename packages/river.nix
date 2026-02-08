{
  stdenv,
  linkFarm,
  fetchzip,
  fetchFromCodeberg,
  pkg-config,
  wayland-scanner,
  xwayland,
  zig_0_15,
  scdoc,
  libGL,
  libevdev,
  libinput,
  libxkbcommon,
  pixman,
  udev,
  wayland,
  wayland-protocols,
  wlroots_0_19,
  xorg,
  lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "river";
  version = "0.4.0-dev";

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromCodeberg {
    owner = "river";
    repo = "river";
    rev = "e9ed482221b785f68ad179a684c3fe993699f0c1";
    hash = "sha256-RcUaZGhnmMBKFi6Mzj/saDm4hhHV5HTQLK2rVRLeDj8=";
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
      name = "wlroots-0.19.3-jmOlcuL_AwBHhLCwpFsXbTizE3q9BugFmGX-XIxqcPMc";
      path = fetchzip {
        url = "https://codeberg.org/ifreund/zig-wlroots/archive/v0.19.3.tar.gz";
        hash = "sha256-rw2bafYcXTxMUtWF9ae++h0RjSfuvpCnIHGLrbLfQTQ=";
      };
    }
    {
      name = "xkbcommon-0.3.0-VDqIe3K9AQB2fG5ZeRcMC9i7kfrp5m2rWgLrmdNn9azr";
      path = fetchzip {
        url = "https://codeberg.org/ifreund/zig-xkbcommon/archive/v0.3.0.tar.gz";
        hash = "sha256-e5bPEfxl4SQf0cqccLt/py1KOW1+Q1+kWZUEXBbh9oQ=";
      };
    }
  ];

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
    xwayland
    zig_0_15.hook
    scdoc
  ];

  buildInputs = [
    libGL
    libevdev
    libinput
    libxkbcommon
    pixman
    udev
    wayland
    wayland-protocols
    wlroots_0_19
    xorg.libX11
  ];

  dontConfigure = true;

  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
    "-Dman-pages"
    "-Dxwayland"
  ];

  postInstall = ''
    install contrib/river.desktop -Dt $out/share/wayland-sessions
  '';

  passthru = {
    providedSessions = [ "river" ];
  };

  meta = {
    homepage = "https://isaacfreund.com/software/river/";
    description = "A non-monolithic Wayland compositor";
    longDescription = ''
      Note: This is the development version (0.4.x) with significant changes
      from the 0.3.x series. For the stable 0.3.x behavior, use river-classic.
    '';
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      adamcstephens
      moni
      rodrgz
      pinpox
    ];
    mainProgram = "river";
    platforms = lib.platforms.linux;
  };
})
