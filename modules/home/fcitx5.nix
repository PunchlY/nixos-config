{
  nixosConfig,
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (nixosConfig.theme) font colors;
in {
  config = lib.mkIf (config.i18n.inputMethod.enable && config.i18n.inputMethod.type == "fcitx5") {
    i18n.inputMethod.fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        qt6Packages.fcitx5-chinese-addons
      ];

      settings.globalOptions = {
        Hotkey = {
          EnumerateWithTriggerKeys = "True";
          AltTriggerKeys = "";
          EnumerateForwardKeys = "";
          EnumerateBackwardKeys = "";
          EnumerateGroupForwardKeys = "";
          EnumerateGroupBackwardKeys = "";
          ActivateKeys = "";
          DeactivateKeys = "";
        };
        "Hotkey/TriggerKeys"."0" = "Super+space";
        Behavior = {
          ActiveByDefault = "False";
          ShareInputState = "No";
        };
        "Behavior/DisabledAddons"."0" = "cloudpinyin";
      };

      settings.inputMethod = {
        "Groups/0" = {
          Name = "Default";
          "Default Layout" = "us";
          DefaultIM = "keyboard-us";
        };
        "Groups/0/Items/0".Name = "keyboard-us";
        "Groups/0/Items/1".Name = "pinyin";
        GroupOrder."0" = "Default";
      };

      settings.addons.pinyin.globalSection = {
        PageSize = 5;
        CloudPinyinEnabled = "False";
        "Fuzzy/EN_ENG" = "True";
        "Fuzzy/IN_ING" = "True";
        "Fuzzy/C_CH" = "True";
        "Fuzzy/S_SH" = "True";
        "Fuzzy/Z_ZH" = "True";
      };
      settings.addons.clipboard.globalSection = {
        TriggerKey = "";
      };
      settings.addons.punctuation.globalSection = {
        Enabled = "False";
        HalfWidthPuncAfterLetterOrNumber = "True";
        "Hotkey/0" = "Control+period";
      };
      settings.addons.classicui.globalSection = {
        EnableFractionalScale = "True";

        Theme = "matugen";
        UseDarkTheme = false;
        UseAccentColor = false;

        Font = "${font.name} ${toString font.size}";
        MenuFont = "${font.name} ${toString font.size}";
        TrayFont = "${font.name} ${toString font.size}";
      };

      themes.matugen = with colors; {
        theme = {
          Metadata = {
            Name = "Matugen";
            Version = 0.1;
            Author = "auto";
            Description = "Matugen fcitx5 theme";
          };

          InputPanel = {
            EnableBlur = false;
            NormalColor = on_surface.hex;
            HighlightCandidateColor = on_primary.hex;
            HighlightColor = on_primary.hex;
            HighlightBackgroundColor = surface.hex;
            Spacing = 3;
          };
          "InputPanel/TextMargin" = {
            Left = 10;
            Right = 10;
            Top = 6;
            Bottom = 6;
          };

          "InputPanel/Background".Color = surface.hex;
          "InputPanel/Background/Margin" = {
            Left = 2;
            Right = 2;
            Top = 2;
            Bottom = 2;
          };

          "InputPanel/Highlight".Color = primary.hex;
          "InputPanel/Highlight/Margin" = {
            Left = 10;
            Right = 10;
            Top = 7;
            Bottom = 7;
          };
        };
      };
    };
  };
}
