{
  fetchurl,
  writeShellApplication,
  bun,
  fuzzel,
  moreutils,
  wl-clipboard-rs,
  runCommand,
  lib,
}:
let
  unicode-emoji-json = fetchurl {
    url = "https://raw.githubusercontent.com/muan/unicode-emoji-json/refs/tags/v0.8.0/data-by-emoji.json";
    hash = "sha256-SC/QDzwkaH5Cjc2onGGb333aJeUc33oGTHWGJnHEujE=";
  };
  emojilib = fetchurl {
    url = "https://raw.githubusercontent.com/muan/emojilib/v4.0.2/dist/emoji-en-US.json";
    hash = "sha256-PjrIs6OhLkFIV++80GwcdPtFeEjlZezeM3LP+Ca/wDI=";
  };

  emoji =
    runCommand "emoji"
      {
        nativeBuildInputs = [ bun ];
      }
      ">$out bun -e ${lib.escapeShellArg ''
        import data from "${unicode-emoji-json}";
        import emojilib from "${emojilib}";
        for (const [emoji, { name, group }] of Object.entries(data))
          console.log("%s\t%s\t", emoji, name, ...emojilib[emoji], group)
      ''}";
in
writeShellApplication {
  name = "fuzzel-emoji";
  runtimeInputs = [
    fuzzel
    moreutils
    wl-clipboard-rs
  ];
  text = ''<${emoji} fuzzel --dmenu --only-match --with-nth="{1..2}" --accept-nth=1 --match-nth=3 --match-mode=fuzzy | ifne wl-copy'';
}
