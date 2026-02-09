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

  security.pam.services = {
    greetd.text = ''
      auth      requisite     pam_nologin.so
      auth      sufficient    pam_succeed_if.so user = player quiet_success
      auth      required      pam_unix.so

      account   sufficient    pam_unix.so

      password  required      pam_deny.so

      session   optional      pam_keyinit.so revoke
      session   include       login
    '';
  };
}
