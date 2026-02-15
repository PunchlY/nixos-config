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

  services.steam.shortcuts."0.5players" =
    let
      assets = pkgs.fetchzip {
        url = "https://github.com/al13n321/0.5players/releases/download/v1.0.3/0.5players.zip";
        hash = "sha256-DRzTZaOv8EPPFLjOSM4ksA6z1WIRnbaHRbhtPVEl44k=";
      };
    in
    {
      exe = "${assets}/0.5players.exe";
      StartDir = "${assets}";
    };

  services.steam.shortcuts."PVZRH" = {
    appname = "Plants Vs Zombies: RH";
    exe = "${config.xdg.userDirs.extraConfig.GAME}/PVZRH/PlantsVsZombiesRH.exe";
  };

  services.steam.shortcuts."BD2" = {
    appname = "Brown Dust 2";
    exe = "${config.xdg.userDirs.extraConfig.GAME}/BD2StarterSetup_gpg_240430.exe";
  };
}
