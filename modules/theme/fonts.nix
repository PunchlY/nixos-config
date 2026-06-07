{lib, ...}: {
  flake.nixosModules.theme = {pkgs, ...}: {
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
        packages = with pkgs; [
          maple-mono.Normal-NF-CN
        ];
        fontconfig.defaultFonts =
          lib.genAttrs
          [
            "monospace"
            "serif"
            "sansSerif"
          ]
          (_family:
            lib.mkBefore [
              "Maple Mono Normal NF CN"
            ]);
      };
    };
  };

  flake.nixosModules.base = {pkgs, ...}: {
    fonts = {
      enableDefaultPackages = false;
      packages = with pkgs; [
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
          lib.mkAfter [
            "Noto Sans Mono CJK SC"
            "Noto Sans Mono"
            "Noto Color Emoji"
            "Noto Emoji"
          ])
        // {
          emoji = lib.mkAfter [
            "Noto Color Emoji"
            "Noto Emoji"
          ];
        };
    };
  };

  flake.homeModules.nixos = {osConfig, ...}: {
    home.packages = osConfig.fonts.packages;
  };
}
