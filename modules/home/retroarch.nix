{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.programs.retroarch;
in {
  config = lib.mkIf cfg.enable {
    programs.retroarch = {
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

    services.steam = lib.mkIf config.services.steam.enable {
      shortcuts.retroarch = {
        appname = "RetroArch";
        exe = lib.getExe cfg.package;
        icon = pkgs.fetchurl {
          url = "https://cdn2.steamgriddb.com/icon/ea1818cbe59c23b20f1a10a8aa083a82/32/256x256.png";
          hash = "sha256-g+6x96hJIPKYfAUfZLUEwlxPse3cImpIcbft3qDZHwQ=";
        };
      };
      grids.retroarch = {
        grid = pkgs.fetchurl {
          url = "https://cdn2.steamgriddb.com/grid/383b30a48dfe620a6705e0b0436e28a2.png";
          hash = "sha256-OmHcAIG4SHvhy8otjcwbHOOM+4e1QhIRzukjUk/SxkY=";
        };
        horizontal = pkgs.fetchurl {
          url = "https://cdn2.steamgriddb.com/grid/ea3d9534a076f2a6f7068da38e7552ac.png";
          hash = "sha256-ju09WcAreVygEnH/I1q7qjYCpcqGOWXkIcZpPlAQqFE=";
        };
        hero = pkgs.fetchurl {
          url = "https://cdn2.steamgriddb.com/hero/3733c89d4ce03f831551c85f47ed3782.png";
          hash = "sha256-xkrevnSD6/B1vk9c9XtbnXiJzYKPGfzPflteRp4H4iw=";
        };
        logo = pkgs.fetchurl {
          url = "https://cdn2.steamgriddb.com/logo/c366c2c97d47b02b24c3ecade4c40a01.png";
          hash = "sha256-qLN45BHAv4mH9yXQvdrYrIqypRtov1J5Ms95Qxt1JAw=";
        };
      };
    };
  };
}
