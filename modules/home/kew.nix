{
  nixosConfig,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.kew;

  boolToStr = v: if v then "1" else "0";

  toKewINI = lib.generators.toINI {
    mkKeyValue = lib.generators.mkKeyValueDefault {
      mkValueString =
        v: if builtins.isBool v then boolToStr v else lib.generators.mkValueStringDefault { } v;
    } "=";
  };

  replayGainMap = {
    track = 0;
    album = 1;
    disabled = 2;
  };

  keyBindingsText = lib.concatMapStringsSep "\n" (
    b:
    let
      parts = [
        b.key
        b.action
      ]
      ++ lib.optional (b.arg != "") b.arg;
    in
    "bind = ${lib.concatStringsSep ", " parts}"
  ) cfg.keyBindings;

  iniConfig = {
    miscellaneous = {
      path = toString cfg.musicPath;
      allowNotifications = cfg.settings.allowNotifications;
      hideLogo = cfg.settings.hideLogo;
      hideHelp = cfg.settings.hideHelp;
      hideSideCover = cfg.settings.hideSideCover;
      titleDelay = cfg.settings.titleDelay;
      quitOnStop = cfg.settings.quitOnStop;
      hideGlimmeringText = cfg.settings.hideGlimmeringText;
      replayGainCheckFirst = replayGainMap.${cfg.settings.replayGainCheckFirst};
      saveRepeatShuffleSettings = cfg.settings.saveRepeatShuffleSettings;
      repeatState = cfg.settings.repeatState;
      shuffleEnabled = cfg.settings.shuffleEnabled;
      trackTitleAsWindowTitle = cfg.settings.trackTitleAsWindowTitle;
    };

    colors = {
      theme = cfg.theme;
      colorMode = cfg.settings.colorMode;
    };

    "track cover" = {
      coverEnabled = cfg.settings.coverEnabled;
      coverAnsi = cfg.settings.coverAnsi;
    };

    mouse = {
      mouseEnabled = cfg.settings.mouseEnabled;
    };

    visualizer = {
      visualizerEnabled = cfg.settings.visualizerEnabled;
      visualizerHeight = cfg.settings.visualizerHeight;
      visualizerBrailleMode = cfg.settings.visualizerBrailleMode;
      visualizerColorType = cfg.settings.visualizerColorType;
      visualizerBarWidth = cfg.settings.visualizerBarWidth;
    };

    "progress bar" = {
      progressBarElapsedEvenChar = cfg.settings.progressBarElapsedEvenChar;
      progressBarElapsedOddChar = cfg.settings.progressBarElapsedOddChar;
      progressBarApproachingEvenChar = cfg.settings.progressBarApproachingEvenChar;
      progressBarApproachingOddChar = cfg.settings.progressBarApproachingOddChar;
      progressBarCurrentEvenChar = cfg.settings.progressBarCurrentEvenChar;
      progressBarCurrentOddChar = cfg.settings.progressBarCurrentOddChar;
    };
  };

  defaultKeyBindings = [
    {
      key = "Space";
      action = "playPause";
      arg = "";
    }
    {
      key = "Shift+Tab";
      action = "prevView";
      arg = "";
    }
    {
      key = "Tab";
      action = "nextView";
      arg = "";
    }
    {
      key = "+";
      action = "volUp";
      arg = "+5%";
    }
    {
      key = "=";
      action = "volUp";
      arg = "+5%";
    }
    {
      key = "-";
      action = "volDown";
      arg = "-5%";
    }
    {
      key = "h";
      action = "prevSong";
      arg = "";
    }
    {
      key = "l";
      action = "nextSong";
      arg = "";
    }
    {
      key = "k";
      action = "scrollUp";
      arg = "";
    }
    {
      key = "j";
      action = "scrollDown";
      arg = "";
    }
    {
      key = "p";
      action = "playPause";
      arg = "";
    }
    {
      key = "n";
      action = "toggleNotifications";
      arg = "";
    }
    {
      key = "v";
      action = "toggleVisualizer";
      arg = "";
    }
    {
      key = "b";
      action = "toggleAscii";
      arg = "";
    }
    {
      key = "r";
      action = "toggleRepeat";
      arg = "";
    }
    {
      key = "i";
      action = "cycleColorMode";
      arg = "";
    }
    {
      key = "t";
      action = "cycleThemes";
      arg = "";
    }
    {
      key = "c";
      action = "cycleVisualization";
      arg = "";
    }
    {
      key = "s";
      action = "shuffle";
      arg = "";
    }
    {
      key = "a";
      action = "seekBack";
      arg = "";
    }
    {
      key = "d";
      action = "seekForward";
      arg = "";
    }
    {
      key = "o";
      action = "sortLibrary";
      arg = "";
    }
    {
      key = "m";
      action = "showLyricsPage";
      arg = "";
    }
    {
      key = "Shift+s";
      action = "stop";
      arg = "";
    }
    {
      key = "x";
      action = "exportPlaylist";
      arg = "";
    }
    {
      key = ".";
      action = "addToFavorites_playlist";
      arg = "";
    }
    {
      key = "u";
      action = "updateLibrary";
      arg = "";
    }
    {
      key = "f";
      action = "moveSongUp";
      arg = "";
    }
    {
      key = "g";
      action = "moveSongDown";
      arg = "";
    }
    {
      key = "Enter";
      action = "enqueue";
      arg = "";
    }
    {
      key = "Shift+g";
      action = "enqueue";
      arg = "";
    }
    {
      key = "Backspace";
      action = "clearPlaylist";
      arg = "";
    }
    {
      key = "Alt+Enter";
      action = "enqueueAndPlay";
      arg = "";
    }
    {
      key = "Left";
      action = "prevSong";
      arg = "";
    }
    {
      key = "Right";
      action = "nextSong";
      arg = "";
    }
    {
      key = "Up";
      action = "scrollUp";
      arg = "";
    }
    {
      key = "Down";
      action = "scrollDown";
      arg = "";
    }
    {
      key = "F2";
      action = "showPlaylist";
      arg = "";
    }
    {
      key = "F3";
      action = "showLibrary";
      arg = "";
    }
    {
      key = "F4";
      action = "showTrack";
      arg = "";
    }
    {
      key = "F5";
      action = "showSearch";
      arg = "";
    }
    {
      key = "F6";
      action = "showHelp";
      arg = "";
    }
    {
      key = "PgDn";
      action = "nextPage";
      arg = "";
    }
    {
      key = "PgUp";
      action = "prevPage";
      arg = "";
    }
    {
      key = "Del";
      action = "remove";
      arg = "";
    }
    {
      key = "mouseMiddle";
      action = "enqueueAndPlay";
      arg = "";
    }
    {
      key = "mouseRight";
      action = "playPause";
      arg = "";
    }
    {
      key = "mouseWheelDown";
      action = "scrollDown";
      arg = "";
    }
    {
      key = "mouseWheelUp";
      action = "scrollUp";
      arg = "";
    }
    {
      key = "q";
      action = "quit";
      arg = "";
    }
    {
      key = "Esc";
      action = "quit";
      arg = "";
    }
  ];
in
{
  options.programs.kew = {
    enable = lib.mkEnableOption "kew";

    package = lib.mkPackageOption pkgs "kew" { nullable = true; };

    musicPath = lib.mkOption {
      type = lib.types.path;
      default = config.home.homeDirectory + "/Music";
    };

    theme = lib.mkOption {
      type = lib.types.str;
      default = "";
    };

    settings = {
      allowNotifications = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      hideLogo = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      hideHelp = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      hideSideCover = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      titleDelay = lib.mkOption {
        type = lib.types.int;
        default = 9;
      };
      quitOnStop = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      hideGlimmeringText = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };

      replayGainCheckFirst = lib.mkOption {
        type = lib.types.enum [
          "track"
          "album"
          "disabled"
        ];
        default = "track";
      };

      saveRepeatShuffleSettings = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      repeatState = lib.mkOption {
        type = lib.types.int;
        default = 0;
      };
      shuffleEnabled = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      trackTitleAsWindowTitle = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };

      colorMode = lib.mkOption {
        type = lib.types.enum [
          0
          1
          2
        ];
        default = 0;
      };

      coverEnabled = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      coverAnsi = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      mouseEnabled = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };

      visualizerEnabled = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      visualizerHeight = lib.mkOption {
        type = lib.types.int;
        default = 6;
      };
      visualizerBrailleMode = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };

      visualizerColorType = lib.mkOption {
        type = lib.types.enum [
          0
          1
          2
          3
        ];
        default = 2;
      };

      visualizerBarWidth = lib.mkOption {
        type = lib.types.enum [
          0
          1
          2
        ];
        default = 2;
      };

      progressBarElapsedEvenChar = lib.mkOption {
        type = lib.types.str;
        default = "━";
      };
      progressBarElapsedOddChar = lib.mkOption {
        type = lib.types.str;
        default = "━";
      };
      progressBarApproachingEvenChar = lib.mkOption {
        type = lib.types.str;
        default = "━";
      };
      progressBarApproachingOddChar = lib.mkOption {
        type = lib.types.str;
        default = "━";
      };
      progressBarCurrentEvenChar = lib.mkOption {
        type = lib.types.str;
        default = "━";
      };
      progressBarCurrentOddChar = lib.mkOption {
        type = lib.types.str;
        default = "━";
      };
    };

    keyBindings = lib.mkOption {
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            key = lib.mkOption { type = lib.types.str; };
            action = lib.mkOption { type = lib.types.str; };
            arg = lib.mkOption {
              type = lib.types.str;
              default = "";
            };
          };
        }
      );
      default = defaultKeyBindings;
    };

    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = lib.mkIf (cfg.package != null) [ cfg.package ];

    xdg.configFile."kew/themes".source = "${cfg.package}/share/kew/themes";

    xdg.configFile."kew/kewrc".text = ''
      ${toKewINI iniConfig}

      [key bindings]

      ${keyBindingsText}
      ${cfg.extraConfig}
    '';
  };
}
