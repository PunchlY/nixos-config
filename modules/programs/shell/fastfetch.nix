{
  flake.modules.homeManager.base = {
    config,
    pkgs,
    lib,
    ...
  }: {
    config = lib.mkIf config.programs.fastfetch.enable {
      home.shellAliases = {
        ff = "fastfetch";
      };

      programs.fastfetch = {
        package = pkgs.fastfetch-unwrapped;

        settings = {
          logo = {
            # https://github.com/elenapan/dotfiles/blob/deddf27a486535ea555ec87d2ae7ee895d02fb3e/bin/bunnyfetch
            source = lib.strings.concatMapStringsSep "\n" (x: "    " + x) [
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
    };
  };
}
