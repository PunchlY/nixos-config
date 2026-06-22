{lib, ...}: let
  shared = {
    config,
    pkgs,
    lib,
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
        path = lib.mkOption {
          internal = true;
          readOnly = true;
        };
      };
    };
    config = {
      theme.font.path =
        pkgs.runCommandLocal "font"
        {
          nativeBuildInputs = [pkgs.fontconfig];
          FONTCONFIG_FILE = pkgs.makeFontsConf {
            fontDirectories = [cfg.font.package];
          };
          FAMILY_NAME = cfg.font.name;
        }
        ''
          ln -s "$(fc-match "$FAMILY_NAME" --format %{file})" "$out"
        '';

      fonts.fontconfig.defaultFonts =
        lib.genAttrs
        [
          "monospace"
          "serif"
          "sansSerif"
        ]
        (_family: lib.mkBefore [cfg.font.name]);
    };
  };
in {
  flake.modules.nixos.theme = {config, ...}: let
    cfg = config.theme;
  in {
    imports = [shared];

    fonts.packages = [cfg.font.package];
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

  flake.modules.homeManager.theme = {
    imports = [shared];
  };

  flake.modules.homeManager.nixos = {osConfig, ...}: {
    home.packages = osConfig.fonts.packages;
  };
}
