{
  config,
  pkgs,
  lib,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    v4l-utils
  ];

  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=2
    options v4l2loopback video_nr=2,3
    options v4l2loopback card_label="OBS Cam,Scrcpy"
    options v4l2loopback exclusive_caps=1
  '';

  security.polkit.enable = lib.mkDefault true;
}
