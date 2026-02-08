{
  writeShellApplication,
  j4-dmenu-desktop,
  fzf,
  xdg-terminal-exec
  lib,
}:
writeShellApplication {
  name = "term-dmenu-desktop";
  runtimeInputs = [
    j4-dmenu-desktop
    fzf
    xdg-terminal-exec
  ];
  text = "j4-dmenu-desktop ${
    lib.cli.toCommandLineShellGNU { } {
      dmenu = ''
        xdg-terminal-exec --app-id=term-dmenu-desktop -- sh -c "fzf </proc/$$/fd/0 >/proc/$$/fd/1" </dev/null
      '';
      term = "foot";
      wrapper = "niri msg action spawn --";
    }
  }";
}
