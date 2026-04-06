{
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = with inputs.nixos-hardware.nixosModules; [
    common-pc-laptop
    common-pc-ssd
    common-hidpi
    common-cpu-amd
    common-cpu-amd-pstate
    common-gpu-amd
  ];

  environment.systemPackages = with pkgs; [
    pywincontrols
  ];

  hardware.sensor.iio.enable = true;

  services.fprintd.enable = true;
  nixpkgs.overlays = [
    (final: prev: {
      libfprint = prev.libfprint.overrideAttrs (oldAttrs: {
        version = "git";
        src = final.fetchFromGitHub {
          owner = "archeYR";
          repo = "libfprint-CS9711";
          rev = "02b285c9703c38d308fbe47a3c566ef1e7f883ca";
          sha256 = "sha256-QGrBNqbRNqLZIURI66xkenlQamNW+DQU4WS+CLN4zM8=";
        };
        nativeBuildInputs =
          oldAttrs.nativeBuildInputs
          ++ [
            final.opencv
            final.cmake
            final.doctest
          ];
        buildInputs =
          oldAttrs.buildInputs
          ++ [
            final.nss
          ];
      });
    })
  ];

  security.pam.services.greetd.fprintAuth = false;

  services.udev.extraRules = ''
    SUBSYSTEM=="power_supply", KERNEL=="ADP1", ATTR{online}=="1", RUN+="${pkgs.ryzenadj}/bin/ryzenadj ${
      lib.cli.toCommandLineShellGNU {} {
        stapm-limit = 28000;
        fast-limit = 35000;
        slow-limit = 32000;
      }
    }"
    SUBSYSTEM=="power_supply", KERNEL=="ADP1", ATTR{online}=="0", RUN+="${pkgs.ryzenadj}/bin/ryzenadj ${
      lib.cli.toCommandLineShellGNU {} {
        stapm-limit = 22000;
        fast-limit = 24000;
        slow-limit = 22000;
      }
    }"
  '';
}
