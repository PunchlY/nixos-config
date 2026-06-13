{moduleWithSystem, ...}: {
  flake-file.inputs = {
    browser-previews = {
      url = "github:nix-community/browser-previews";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  flake.modules.nixos.base = moduleWithSystem ({inputs'}: {
    config,
    lib,
    ...
  }: {
    config = lib.mkIf config.programs.chromium.enable {
      environment.systemPackages = [
        inputs'.browser-previews.packages.google-chrome
      ];

      programs.chromium = let
        extensions = {
          "ddkjiahejlhfcafbddmgiahcphecmpfh" = {
            # uBlock Origin Lite
            toolbar_pin = "force_pinned";
          };
          "ecanpcehffngcegjmadlcijfolapggal" = {
            # IPvFoo
            toolbar_pin = "force_pinned";
          };
          "fjkmabmdepjfammlpliljpnbhleegehm" = {
            # WebRTC Control
            toolbar_pin = "force_pinned";
          };
          "dhdgffkkebhmkfjojejmpbldmpobfkfo" = {
            # Tampermonkey
          };
          "hnenidncmoeebipinjdfniagjnfjbapi" = {
            # Aria2 Integration
            toolbar_pin = "force_pinned";
          };
        };
      in {
        extensions = lib.attrNames extensions;
        extraOpts.ExtensionSettings = extensions;
        extraOpts = {
          RestoreOnStartup = 1;
          DefaultBrowserSettingEnabled = false;
        };
      };
    };
  });

  flake.modules.nixos.theme = {
    config,
    lib,
    ...
  }: let
    inherit (config.theme) colors;
  in {
    config = lib.mkIf config.programs.chromium.enable {
      programs.chromium = {
        extraOpts = {
          BrowserThemeColor = colors.surface.hex;
          OsColorMode = "dark";
        };
      };
    };
  };
}
