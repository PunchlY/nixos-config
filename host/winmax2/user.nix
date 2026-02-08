{
  config,
  pkgs,
  ...
}:
{
  age.identityPaths = [
    "${config.users.users.punchly.home}/.ssh/id_ed25519"
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
  };
  nix.settings.trusted-users = [ "punchly" ];
}
