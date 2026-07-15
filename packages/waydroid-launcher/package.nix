{
  replaceVarsWith,
  runtimeShell,
  jq,
  jc,
  expect,
  gnugrep,
  xrandr,
  wlr-randr,
  lswt,
  cage,
}:
replaceVarsWith {
  name = "waydroid-launcher";
  src = ./launcher.sh;

  dir = "bin";
  isExecutable = true;
  replacements = {
    inherit runtimeShell gnugrep cage;

    startup = replaceVarsWith {
      name = "waydroid-app";
      src = ./app.sh;

      isExecutable = true;
      replacements = {
        inherit
          runtimeShell
          jq
          jc
          expect
          gnugrep
          xrandr
          wlr-randr
          lswt
          ;
      };
    };
  };

  meta.mainProgram = "waydroid-launcher";
}
