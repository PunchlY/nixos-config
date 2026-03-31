{
  config,
  lib,
  me,
  ...
}:
let
  name = lib.toLower me.userName;
in
{
  imports = [
    (lib.mkAliasOptionModule [ "user" ] [ "users" "users" name ])
    (lib.mkAliasOptionModule [ "hm" ] [ "home-manager" "users" name ])
  ];

  config = {
    user = {
      inherit (me) initialHashedPassword;
      uid = 1000;
      isNormalUser = true;
      useDefaultShell = true;
      extraGroups = [
        "wheel"
        "networkmanager"
        "audio"
        "video"
        "input"
        "aria2"
      ];
    };

    nix.settings.trusted-users = [ name ];

    hm.programs.git = lib.mkIf config.hm.programs.git.enable {
      settings.user = {
        name = me.userName;
        email = me.email;
      };
    };
  };
}
