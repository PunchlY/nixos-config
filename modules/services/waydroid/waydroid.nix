{moduleWithSystem, ...}: {
  flake-file.inputs = {
    waydroid-script = {
      url = "github:casualsnek/waydroid_script";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  flake.modules.nixos.base = moduleWithSystem ({inputs'}: {
    config,
    pkgs,
    lib,
    ...
  }: {
    config = lib.mkIf (config.virtualisation.waydroid.enable || config.services.waydroid-nvidia.enable) {
      environment.systemPackages = [
        inputs'.waydroid-script.packages.default
      ];

      # Tell waydroid to use memfd and not ashmem
      systemd.tmpfiles.settings.waydroid-settings."/var/lib/waydroid/waydroid_base.prop".C = {
        user = "root";
        group = "root";
        mode = "0644";
        argument = builtins.toString (
          pkgs.writeText "waydroid_base.prop" ''
            sys.use_memfd=true
          ''
        );
      };
    };
  });
}
