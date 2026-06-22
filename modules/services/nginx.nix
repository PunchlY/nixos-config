{
  flake.modules.nixos.base = {
    config,
    lib,
    ...
  }: {
    services.nginx = lib.mkIf config.services.nginx.enable {
      virtualHosts.localhost = {
        default = true;
        rejectSSL = true;
        locations."/".return = 444;
      };
    };
  };
}
