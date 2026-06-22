{
  flake.modules.nixos.base = {
    config,
    pkgs,
    lib,
    ...
  }: let
    cfg = config.services.home-assistant;
  in {
    config = lib.mkIf cfg.enable {
      nixpkgs.config.allowUnfree = true;
      nixpkgs.config.allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [
          "XiaoMi/xiaomi_home"
        ];

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
