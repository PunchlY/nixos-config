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
}
