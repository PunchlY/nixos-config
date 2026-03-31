{
  inputs,
  ...
}:
{
  nix.registry = {
    nixpkgs.flake = inputs.nixpkgs;
    self.flake = inputs.self;
    templates.flake = inputs.templates;
  };
}
