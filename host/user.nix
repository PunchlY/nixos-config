{
  config,
  pkgs,
  ...
}:
{

  environment.systemPackages = with pkgs; [
    agenix
  ];

  age.identityPaths = [
    "/home/punchly/.ssh/id_ed25519"
    "/home/punchly/.ssh/id_rsa"
  ];

  users.users.punchly = {
    isNormalUser = true;
    description = "PunchlY";
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
      "video"
      "input"
      "keyd"
      "seat"
      "aria2"
    ];
    packages = with pkgs; [ ];
  };
  nix.settings.trusted-users = [ "punchly" ];

}
