{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    (mcaselector.override {
      jre = zulu.override {
        enableJavaFX = true;
      };
    })

    (gtk-nocsd.wrapper gnome-mines)
    # (gtk-nocsd.wrapper sleepy-launcher)
  ];

  programs.hmcl = {
    enable = true;
    package =
      with pkgs;
      hmcl.override {
        hmclJdk = graalvmPackages.graalvm-ce;
        minecraftJdks = [
          graalvmPackages.graalvm-ce
          # zulu17
          # zulu21
        ];
      };
  };

  programs.retroarch = {
    enable = true;
    cores = {
      # Nintendo
      # ==================
      mgba.enable = true; # GBA
      desmume.enable = true; # NDS
      citra.enable = true; # 3DS
      mesen.enable = true; # FC
      bsnes.enable = true; # SFC
      mupen64plus.enable = true; # N64
      dolphin.enable = true; # Wii
      # Sony
      # ==================
      swanstation.enable = true; # PS1
      pcsx2.enable = true; # PS2
      ppsspp.enable = true; # PSP
    };
  };
}
