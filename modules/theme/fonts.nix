{
  flake.nixosModules.theme = {
    lib,
    pkgs,
    ...
  }: {
    options.theme = {
      font = {
        size = lib.mkOption {
          default = 14;
          type = with lib.types; either ints.unsigned float;
        };
      };
    };

    config = {
      fonts = {
        enableDefaultPackages = false;
        packages = with pkgs; [
          maple-mono.Normal-NF-CN
          noto-fonts-cjk-sans
          noto-fonts
          noto-fonts-color-emoji
          noto-fonts-monochrome-emoji

          material-icons
          lmmath
        ];
        fontconfig.defaultFonts =
          lib.genAttrs
          [
            "monospace"
            "serif"
            "sansSerif"
          ]
          (_family:
            lib.mkOrder 0 [
              "Maple Mono Normal NF CN"
              "Noto Sans Mono CJK SC"
              "Noto Sans Mono"
              "Noto Color Emoji"
              "Noto Emoji"
            ])
          // {
            emoji = lib.mkOrder 0 [
              "Noto Color Emoji"
              "Noto Emoji"
            ];
          };
      };
    };
  };

  flake.homeModules.theme = {nixosConfig, ...}: {
    home.packages = nixosConfig.fonts.packages;
  };
}
