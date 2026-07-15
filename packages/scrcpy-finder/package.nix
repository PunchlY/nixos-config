{
  net-tools,
  fuzzel,
  fzf,
  jc,
  jq,
  replaceVarsWith,
  runtimeShell,
  scrcpy,
  makeDesktopItem,
  copyDesktopItems,
}:
replaceVarsWith {
  name = "scrcpy-finder";
  src = ./scrcpy-finder.sh;

  dir = "bin";
  isExecutable = true;
  replacements = {
    inherit
      net-tools
      fuzzel
      fzf
      jc
      jq
      runtimeShell
      scrcpy
      ;
  };

  desktopItems = [
    (makeDesktopItem {
      name = "scrcpy-finder";
      exec = "scrcpy-finder";
      desktopName = "Scrcpy Finder";
    })
  ];

  nativeBuildInputs = [
    copyDesktopItems
  ];
}
