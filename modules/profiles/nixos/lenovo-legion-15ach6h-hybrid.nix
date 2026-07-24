{inputs, ...}: {
  nixpkgs.config = {
    allowUnfreePackages = [
      "nvidia-x11"
      "nvidia-settings"
    ];
  };

  configurations.nixos.nixos.module = {
    imports = [
      inputs.nixos-hardware.nixosModules.lenovo-legion-15ach6h-hybrid
    ];

    hardware.nvidia.prime.amdgpuBusId = "PCI:05:0:0";
    hardware.nvidia.branch = "latest";
  };
}
