{
  config,
  pkgs,
  lib,
  ...
}: {
  home.shellAliases = lib.mkIf config.programs.fastfetch.enable {
    ff = "fastfetch";
  };

  programs.fastfetch = {
    enable = lib.mkDefault true;
    package = pkgs.fastfetchMinimal;

    settings = {
      logo = {
        # https://github.com/elenapan/dotfiles/blob/deddf27a486535ea555ec87d2ae7ee895d02fb3e/bin/bunnyfetch
        source = lib.strings.concatMapStrings (x: "    " + x + "\n") [
          ''$1(\ /)''
          "( . .)"
          ''c($2"$1)($2"$1)''
        ];
        type = "data";
        position = "top";
        padding = {
          top = 0;
          left = 0;
          right = 0;
        };
        color = {
          "1" = "light_white";
          "2" = "red";
        };
      };
      display = {
        color = "blue";
        separator = " ";
      };
      modules = [
        {
          key = " OS";
          type = "os";
        }
        {
          key = "KER";
          type = "kernel";
        }
        {
          key = " SH";
          type = "shell";
        }
        {
          key = "TER";
          type = "terminal";
        }
        {
          key = " WM";
          type = "wm";
        }
        {
          paddingLeft = 4;
          type = "colors";
        }
      ];
    };
  };
}
