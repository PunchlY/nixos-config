{
  config,
  pkgs,
  ...
}:
{
  age.identityPaths = [
    "${config.users.users.punchly.home}/.ssh/id_rsa"
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
