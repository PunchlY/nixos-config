{
  config,
  pkgs,
  ...
}:
{
  jovian.steam = {
    enable = true;
    autoStart = true;
  };

  age.identityPaths = [
    "${config.user.home}/.ssh/id_rsa"
  ];

  user = {
    description = "PunchlY";
    extraGroups = [
      "networkmanager"
      "audio"
      "video"
      "input"
    ];
  };
}
