{
  config,
  lib,
  pkgs,
  nixos-hardware,
  ...
}:

{
  imports = [
    nixos-hardware.nixosModules.lenovo-legion-15ach6h-hybrid
  ];

  hardware.nvidia.prime.amdgpuBusId = "PCI:05:0:0";

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    # extraPackages = with pkgs; [
    #   vaapiVdpau
    #   libvdpau-va-gl
    #   nvidia-vaapi-driver
    # ];
  };

  specialisation.battery.configuration =
    { ... }:
    {
      imports = [ nixos-hardware.nixosModules.common-gpu-nvidia-disable ];

      system.nixos.tags = [ "battery" ];
      services.xserver.videoDrivers = lib.mkForce [ ];
      hardware.nvidia = {
        modesetting.enable = lib.mkForce false;
        nvidiaPersistenced = lib.mkForce false;
        prime.offload.enable = lib.mkForce false;
        prime.offload.enableOffloadCmd = lib.mkForce false;
      };
    };
}
