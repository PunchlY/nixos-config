{
  nixpkgs.config = {
    allowUnfreePackages = [
      "balatro"
      "Balatro.exe"
    ];
  };

  flake.modules.homeManager.base = {
    config,
    pkgs,
    lib,
    ...
  }: {
    config = lib.mkIf config.programs.steam.config.enable {
      programs.steam.config = {
        apps.Balatro = {
          enable = lib.mkDefault false;
          id = 2379780;
          preHook = ''
            Mods="$XDG_DATA_HOME/Balatro/Mods"
            export XDG_DATA_HOME="$STEAM_COMPAT_DATA_PATH/pfx/drive_c/users/steamuser/AppData/Roaming"
            mkdir -p "$XDG_DATA_HOME/Balatro"
            ln -sTf "$Mods" "$XDG_DATA_HOME/Balatro/Mods"
            game_command=("${pkgs.balatro}/bin/balatro")
          '';
        };
      };

      xdg.dataFile = lib.mkIf config.programs.steam.config.apps.Balatro.enable {
        "Balatro/Mods/smods".source = pkgs.fetchFromGitHub {
          owner = "Steamodded";
          repo = "smods";
          tag = "1.0.0-beta-1814a";
          hash = "sha256-5chUzZSfUDUqtlMzSdSa1fZRHOPvRIdwHnKK83f4ecs=";
        };

        "Balatro/Mods/JokerDisplay".source = pkgs.fetchFromGitHub {
          owner = "nh6574";
          repo = "JokerDisplay";
          tag = "v1.10.7";
          hash = "sha256-wXr/1ozqYcXizzOdqa9nt5n8oYM5zVyghZShyJZEMiQ=";
        };
        "Balatro/Mods/Malverk".source = pkgs.fetchFromGitHub {
          owner = "Eremel";
          repo = "Malverk";
          tag = "v1.1.4a";
          hash = "sha256-KN7OYTknhJ5J047Fl1Gfzg66pghR0xezXfY31R9+E1U=";
        };
        "Balatro/Mods/Cartomancer".source = pkgs.fetchzip {
          url = "https://github.com/stupxd/Cartomancer/releases/download/v4.17c/Cartomancer-v4.17c.zip";
          hash = "sha256-av4R+nrjItyz69woZPYnzOOB/n2Yb9vEkjRgmTT79ws=";
        };
        "Balatro/Mods/Blueprint".source = pkgs.fetchFromGitHub {
          owner = "stupxd";
          repo = "Blueprint";
          tag = "v.3.3";
          hash = "sha256-5GMBXNC4iqREJ5vcDIumNaW5irXTd+6/X+VVORZIVWs=";
        };
        "Balatro/Mods/Galdur".source = pkgs.fetchFromGitHub {
          owner = "Eremel";
          repo = "Galdur";
          tag = "v1.2.1d";
          hash = "sha256-8/H8EZoZp/TBkj6CLYbfsYLQX7RWJW0XiAaceIUgXrM=";
        };
        "Balatro/Mods/reUnlockAll".source = pkgs.fetchzip {
          url = "https://github.com/wingedcatgirl/re-Unlock-All/releases/download/v1.1.2/reUnlockAll-1.1.2.zip";
          hash = "sha256-wIRHJE+ZZKw2XrIEOCMSRFGWLDCZa+rcJAQFtZ5pyMk=";
        };
        "Balatro/Mods/SystemClock".source = pkgs.fetchzip {
          url = "https://github.com/Breezebuilder/SystemClock/releases/download/v1.7.1/SystemClock-v1.7.1.zip";
          hash = "sha256-Xph1qwt25dW2A0b2eD2XevWojTS/jTDSaLuurdLS4dE=";
        };
        "Balatro/Mods/ColorblindSeals".source = pkgs.fetchFromGitHub {
          owner = "martinkauppinen";
          repo = "colorblind-seals";
          tag = "1.0.2";
          hash = "sha256-tJt0BKs7O3WiPGNEhLJnD0aB1cEYXo0Pfam/+w3qlEE=";
        };
        "Balatro/Mods/SaveRewinder".source = pkgs.fetchzip {
          url = "https://github.com/liafonx/Balatro-SaveRewinder/releases/download/v1.6.2/SaveRewinder.zip";
          hash = "sha256-Y+ZcwguAo9/PVWy39S1sJ2oRXb+Ot9rLpLREisBuBrk=";
        };
        "Balatro/Mods/ReadableTarots".source = pkgs.fetchzip {
          url = "https://github.com/bosass/Readable-Tarots-Balatro-mod-/releases/download/1.2/ReadableTarots.zip";
          hash = "sha256-ZRw6sXR2oseLmoQ649YKLHB7ho8BER/TCeIVKzdsojY=";
        };
        "Balatro/Mods/Preview".source = pkgs.fetchzip {
          url = "https://github.com/DivvyCr/Balatro-Preview/releases/download/v4.1/DVPreview_v4.1.2.zip";
          hash = "sha256-IJaPtYxWMGSaKxZmhlnbVkK/H3eZcbDnoWZKB8bCE3g=";
        };
        "Balatro/Mods/DismissAlert".source = pkgs.fetchzip {
          url = "https://github.com/Breezebuilder/DismissAlert/releases/download/v1.0.0/DismissAlert.zip";
          hash = "sha256-PRkeKG3DiiolWqnV/BsmUZxMmCMN5/l95vyvaI78/Ks=";
        };
        "Balatro/Mods/SilkTouch".source = pkgs.fetchzip {
          url = "https://github.com/HuyTheKiller/SilkTouch/releases/download/1.2.3/SilkTouch.zip";
          hash = "sha256-YtYKSF8ioECLovluQ5aTIH9wfcstlG0NvdPqohdrLzE=";
        };
        "Balatro/Mods/NextAntePreview".source = pkgs.fetchFromGitHub {
          owner = "DigitalDetective47";
          repo = "next-ante-preview";
          tag = "v3.0.3";
          hash = "sha256-ZOFnvtaH+nHRkAZN8Xvhm2Yu2CkKJEydSkLwoPVc8mM=";
        };
      };
    };
  };
}
