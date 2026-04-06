{
  projectRootFile = "flake.nix";

  programs.deadnix = {
    enable = true;
    priority = 1;
  };

  programs.alejandra = {
    enable = true;
    priority = 2;
  };
}
