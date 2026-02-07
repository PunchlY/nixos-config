{
  pkgs,
  agenix,
  ...
}:
{
  imports = [
    agenix.nixosModules.default
  ];
  environment.systemPackages = with pkgs; [
    agenix
  ];
}
