{
  stdenv,
  python3,
}:
stdenv.mkDerivation (_finalAttrs: {
  pname = "xdg-desktop-portal-niri";
  version = "1.0.0-dev";
  src = ./.;

  buildInputs = [(python3.withPackages (p: [p.dbus-next]))];

  installPhase = ''
    install -Dm775 $src/xdg-desktop-portal-niri.py $out/libexec/xdg-desktop-portal-niri
    install -Dm444 $src/org.freedesktop.impl.portal.desktop.niri.service -t $out/share/dbus-1/services
    install -Dm444 $src/niri.portal -t $out/share/xdg-desktop-portal/portals
    install -Dm444 $src/xdg-desktop-portal-niri.service -t $out/share/systemd/user
    substituteInPlace $out/share/dbus-1/services/org.freedesktop.impl.portal.desktop.niri.service \
      --replace-fail "/usr" "$out"
    substituteInPlace $out/share/systemd/user/xdg-desktop-portal-niri.service \
      --replace-fail "/usr" "$out"
  '';
})
