{lib, ...}: {
  flake.modules.nixos.base = {config, ...}: {
    config = lib.mkIf config.services.openssh.enable {
      services.openssh.settings = {
        PasswordAuthentication = false;
        PubkeyAuthentication = true;
      };
    };
  };
}
