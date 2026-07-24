{inputs, ...}: {
  flake-file.inputs = {
    waydroid-nvidia-nix = {
      url = "github:yigexuanmu/waydroid-nvidia-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixpkgs.overlays = [inputs.waydroid-nvidia-nix.overlays.default];

  flake.modules.nixos.base = {
    config,
    pkgs,
    lib,
    ...
  }: {
    imports = [
      inputs.waydroid-nvidia-nix.nixosModules.waydroid-nvidia
    ];

    config = lib.mkIf config.services.waydroid-nvidia.enable {
      boot.kernelParams = [
        "nvidia-drm.modeset=1"
      ];
      hardware.nvidia.open = true;
    };
  };
}
