{
  lib,
  config,
  pkgs,
  ...
}:

{
  hardware.graphics.enable = true;

  programs.niri.enable = true;

  programs.localsend = {
    enable = true;
    package = pkgs.gtk-nocsd.wrapper pkgs.localsend;
  };

  programs.wshowkeys = {
    enable = true;
    package = pkgs.wshowkeys-symbols;
  };

  jovian.steam.enable = true;

  services.seatd.enable = true;

  programs.tuigreet.enable = true;
}
