{
  replaceVarsWith,
  bash,
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
    inherit bash gnugrep cage;

    startup = replaceVarsWith {
      name = "waydroid-app";
      src = ./app.sh;

      isExecutable = true;
      replacements = {
        inherit
          bash
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
}
