{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-legion-15ach6h-hybrid
  ];

  hardware.nvidia.prime.amdgpuBusId = "PCI:05:0:0";
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;
}
