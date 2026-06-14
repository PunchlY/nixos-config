{
  replaceVarsWith,
  bash,
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
    inherit bash cmd-polkit;
    auth = replaceVarsWith {
      name = "fuzzel-polkit-agent-auth";
      src = ./auth.sh;
      isExecutable = true;
      replacements = {
        inherit
          bash
          jq
          fuzzel
          libnotify
          ;
      };
    };
  };
}
