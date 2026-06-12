{inputs, ...}: {
  flake-file.inputs = {
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  flake.nixosModules.base = {pkgs, ...}: {
    imports = [inputs.sops-nix.nixosModules.sops];

    environment.systemPackages = with pkgs; [
      sops
    ];

    sops.defaultSopsFile = "${inputs.self}/secrets/secrets.yaml";
  };
}
