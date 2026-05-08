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
  src = ./fuzzel-polkit-agent.sh;

  dir = "libexec";
  isExecutable = true;
  replacements = {
    inherit
      bash
      jq
      fuzzel
      cmd-polkit
      libnotify
      ;
  };
}
