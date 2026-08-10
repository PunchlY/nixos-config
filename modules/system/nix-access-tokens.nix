{
  flake.modules.nixos.base = {config, ...}: {
    sops.secrets."nix-access-tokens.conf" = {
      group = "wheel";
      mode = "0440";
    };
    nix.extraOptions = ''
      !include ${config.sops.secrets."nix-access-tokens.conf".path}
    '';
  };
}
