{
  self,
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
      (lib.mkAliasOptionModule ["user"] ["users" "users" self.meta.owner.username])
      (lib.mkAliasOptionModule ["hm"] ["home-manager" "users" self.meta.owner.username])
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

      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDMvu8NSsF7TP9JxxPhHeij113Kmw61KSPfpbLQvpsoY punchly@winmax2"
      ];
    };

    hm.programs.git = {
      settings.user = {
        name = self.meta.owner.name;
        email = self.meta.owner.email;
      };
    };
  };
}
