{
  mkShell,
  bashInteractive,
  python3,
}:
mkShell {
  nativeBuildInputs = [
    bashInteractive
    (python3.withPackages (p: [p.dbus-next]))
  ];
}
