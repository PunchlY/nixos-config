{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.niri;
in
{
  config = lib.mkIf cfg.enable {
    programs.niri.useNautilus = lib.mkDefault false;
  };
}
