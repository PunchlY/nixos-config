{
  system.stateVersion = "26.05";

  nixpkgs.config.permittedInsecurePackages = [
    "python3.12-ecdsa-0.19.1"
  ];
}
