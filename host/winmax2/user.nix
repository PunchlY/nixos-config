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
      "seat"
      "aria2"
    ];
    uid = 1000;
  };
  nix.settings.trusted-users = [ "punchly" ];

  users.users.player = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "aria2"
    ];
  };

  security.pam.services.greetd.rules.auth.autologin = {
    enable = true;
    order = 9000;
    control = "sufficient";
    modulePath = "${pkgs.pam}/lib/security/pam_succeed_if.so";
    args = [
      "user"
      "="
      "player"
    ];
  };
}
