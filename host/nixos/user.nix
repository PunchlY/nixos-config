{
  config,
  pkgs,
  ...
}:
{
  imports = [ (lib.mkAliasOptionModule [ "hm" ] [ "home-manager" "users" "punchly" ]) ];

  jovian.steam = {
    enable = true;
    user = "punchly";
    autoStart = true;
  };

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
    ];
  };
  nix.settings.trusted-users = [ "punchly" ];
}
