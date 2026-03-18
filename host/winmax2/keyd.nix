{
  config,
  pkgs,
  lib,
  ...
}:
{
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          main = {
            capslock = "layer(hyper)";
          };
          "hyper:S-C-A-M" = {
            tab = "capslock";
          };
        };
      };
    };
  };
}
