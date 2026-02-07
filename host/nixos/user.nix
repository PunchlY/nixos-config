{
  config,
  pkgs,
  ...
}:
{
  age.identityPaths = [
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
      "seat"
      "aria2"
    ];
  };
  nix.settings.trusted-users = [ "punchly" ];
}
