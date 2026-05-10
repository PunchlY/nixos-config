{...}: {
  flake.homeModules.base = {pkgs, ...}: {
    home.packages = [pkgs.gomi];
    home.shellAliases.rm = "gomi";
  };
}
