{
  writeShellApplication,
  writeShellScript,
  fuzzel,
  app2unit,
  lib,
}:
writeShellApplication {
  name = "fuzzel-application-launcher";
  runtimeInputs = [
    fuzzel
    app2unit
  ];
  text = "fuzzel ${lib.cli.toCommandLineShellGNU {} {
    show-actions = true;
    launch-prefix = writeShellScript "launch-prefix" ''
      if [ -n "$DESKTOP_ENTRY_ID" ]; then
        if [ -n "$DESKTOP_ENTRY_ACTION" ]; then
          set -- "$DESKTOP_ENTRY_ID:$DESKTOP_ENTRY_ACTION"
        else
          set -- "$DESKTOP_ENTRY_ID"
        fi
        set -- app2unit -t service -- "$@"
      else
        set -- app2unit-term-service -- "$@"
      fi
      exec "$@"
    '';
  }}";
}
