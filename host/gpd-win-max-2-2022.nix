{
  pkgs,
  nixos-hardware,
  ...
}:

{
  imports = with nixos-hardware.nixosModules; [
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

  hardware.gpd.ppt.enable = true;

  hardware.gpd-fan.enable = true;

  hardware.sensor.iio.enable = true;

  services.fprintd.enable = true;
  nixpkgs.overlays = [
    (final: prev: {
      libfprint = prev.libfprint.overrideAttrs (oldAttrs: {
        version = "git";
        src = final.fetchFromGitHub {
          owner = "archeYR";
          repo = "libfprint-CS9711";
          rev = "c2d163f";
          sha256 = "sha256-JygOJ3SybXKR3CjLxLbAZDaYCl9LuQYDQfFC8Si5oaw=";
        };
        nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [
          final.opencv
          final.cmake
          final.doctest
        ];
        buildInputs = oldAttrs.buildInputs ++ [
          final.nss
        ];
      });
    })
  ];

  security.pam.services.greetd.fprintAuth = false;
}
