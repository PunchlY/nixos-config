{
  nixpkgs.config = {
    allowUnfreePackages = [
      "XiaoMi/xiaomi_home"
    ];
  };

  flake.modules.nixos.base = {
    config,
    pkgs,
    lib,
    ...
  }: let
    cfg = config.services.home-assistant;
  in {
    config = lib.mkIf cfg.enable {
      services.home-assistant = {
        customComponents = with pkgs.home-assistant-custom-components; [
          xiaomi_home
        ];
        extraComponents = [
          "ffmpeg"
          "zeroconf"
        ];
      };
    };
  };
}
