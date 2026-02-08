{
  writeShellApplication,
  cliphist,
  fuzzel,
  moreutils,
  wl-clipboard-rs,
}:
writeShellApplication {
  name = "fuzzel-clipboard";
  runtimeInputs = [
    cliphist
    fuzzel
    moreutils
    wl-clipboard-rs
  ];
  text = "cliphist list | fuzzel --dmenu --only-match --with-nth 2 | cliphist decode | ifne wl-copy";
}
