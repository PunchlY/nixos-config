{
  config,
  lib,
  ...
}: {
  flake.meta.owner = {
    name = "PunchlY";
    username = "punchly";
    email = "punchly9lin@gmail.com";
  };

  flake.modules.nixos.base = {
    imports = [
      (lib.mkAliasOptionModule ["user"] ["users" "users" config.flake.meta.owner.username])
      (lib.mkAliasOptionModule ["hm"] ["home-manager" "users" config.flake.meta.owner.username])
    ];

    user = {
      uid = 1000;
      isNormalUser = true;
      useDefaultShell = true;
      initialHashedPassword = "$y$j9T$K/hxRPyR.lSbYJwU1kbEI.$Uk.bhCt/rESx.qWrrUhUKKJMitZpWjqJpA0.URGoKXB";

      extraGroups = [
        "wheel"
        "networkmanager"
        "audio"
        "video"
        "input"
      ];
    };

    hm = {
      programs.git = {
        settings.user = {
          name = config.flake.meta.owner.name;
          email = config.flake.meta.owner.email;
        };
      };
    };

    nix.settings.trusted-users = [config.flake.meta.owner.username];
  };
}
