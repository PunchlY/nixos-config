{lib, ...}: {
  flake.modules.nixos.theme = {
    config,
    pkgs,
    ...
  }: let
    cfg = config.theme;
  in {
    options.theme = {
      font = {
        package = lib.mkOption {
          type = lib.types.package;
          default = pkgs.maple-mono.Normal-NF-CN;
        };
        name = lib.mkOption {
          type = lib.types.str;
          default = "Maple Mono Normal NF CN";
        };
        size = lib.mkOption {
          default = 14;
          type = with lib.types; either ints.unsigned float;
        };
        path = lib.mkOption {internal = true;};
      };
    };

    config = {
      theme.font.path =
        pkgs.runCommand "font"
        {
          nativeBuildInputs = [pkgs.fontconfig];
          FONTCONFIG_FILE = pkgs.makeFontsConf {
            fontDirectories = [cfg.font.package];
          };
          FAMILY_NAME = cfg.font.name;
          preferLocalBuild = true;
        }
        ''
          ln -s "$(fc-match "$FAMILY_NAME" --format %{file})" "$out"
        '';

      fonts = {
        packages = [cfg.font.package];
        fontconfig.defaultFonts =
          lib.genAttrs
          [
            "monospace"
            "serif"
            "sansSerif"
          ]
          (_family: lib.mkBefore [cfg.font.name]);
      };
    };
  };

  flake.modules.nixos.base = {
    config,
    pkgs,
    ...
  }: {
    fonts = {
      enableDefaultPackages = false;
      packages = with pkgs; (
        (lib.optionals (!config ? theme) [
          nur.repos.definfo.sarasa-term-sc-nerd
        ])
        ++ [
          noto-fonts-cjk-sans
          noto-fonts
          noto-fonts-color-emoji
          noto-fonts-monochrome-emoji

          material-icons
          lmmath
        ]
      );
      fontconfig.defaultFonts =
        lib.genAttrs
        [
          "monospace"
          "serif"
          "sansSerif"
        ]
        (_family:
          lib.mkAfter (
            (lib.optionals (!config ? theme) [
              "Sarasa Term SC Nerd"
            ])
            ++ [
              "Noto Sans Mono CJK SC"
              "Noto Sans Mono"
              "Noto Color Emoji"
              "Noto Emoji"
            ]
          ))
        // {
          emoji = lib.mkAfter [
            "Noto Color Emoji"
            "Noto Emoji"
          ];
        };
    };
  };

  flake.modules.homeManager.nixos = {osConfig, ...}: {
    home.packages = osConfig.fonts.packages;
  };
}
