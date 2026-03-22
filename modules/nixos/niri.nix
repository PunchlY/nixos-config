{
  config,
  lib,
  pkgs,
  niri,
  ...
}:
let
  inherit (config.theme) cursor colors;
  cfg = config.programs.niri;
in
{
  config = lib.mkIf cfg.enable {
    programs.niri.useNautilus = lib.mkDefault false;
  };
}
