{inputs, ...}: {
  imports = [inputs.nix-index-database.nixosModules.default];

  config = {
    programs.nix-index.enable = false;
    programs.nix-index-database.comma.enable = true;
  };
}
