{
  replaceVarsWith,
  runtimeShell,
  jq,
  fuzzel,
  cmd-polkit,
  libnotify,
}:
replaceVarsWith {
  name = "fuzzel-polkit-agent";
  src = ./daemon.sh;

  dir = "libexec";
  isExecutable = true;
  replacements = {
    inherit runtimeShell cmd-polkit;
    auth = replaceVarsWith {
      name = "fuzzel-polkit-agent-auth";
      src = ./auth.sh;
      isExecutable = true;
      replacements = {
        inherit
          runtimeShell
          jq
          fuzzel
          libnotify
          ;
      };
    };
  };
}
