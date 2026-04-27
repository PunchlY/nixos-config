{
  inputs,
  lib,
  ...
}: {
  flake-file.inputs = {
    browser-previews = {
      url = "github:nix-community/browser-previews";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  flake.nixosModules.base = {
    config,
    pkgs,
    ...
  }: {
    config = lib.mkIf config.programs.chromium.enable {
      environment.systemPackages = [
        inputs.browser-previews.packages.${pkgs.stdenv.hostPlatform.system}.google-chrome
      ];

      programs.chromium = {
        extraOpts = {
          DefaultBrowserSettingEnabled = false;
        };
      };
    };
  };

  flake.nixosModules.theme = {config, ...}: let
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
