{
  self,
  nixpkgs,
  flake-utils,
  templates,
  ...
}:
{
  nix.registry = {
    nixpkgs.flake = nixpkgs;
    self.flake = self;
    templates.flake = templates;
  };
}
