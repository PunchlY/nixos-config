{
  pkgs,
  lib,
  inputs,
  ...
}:

{
  environment.systemPackages =
    with pkgs;
    [
      (gtk-nocsd.wrapper waydroid-helper)
      (writeShellApplication {
        name = "waydroid-launcher";
        runtimeInputs = [
          cage
          wlr-randr
          (writeShellScriptBin "waydroid-full-ui" ''
            wlr-randr --output X11-1 --custom-mode ''${WAYDROID_WIDTH}x''${WAYDROID_HEIGHT}
            sleep 1
            waydroid show-full-ui &> /dev/null
          '')
        ];
        text = ''
          if waydroid status | grep -q "^Session:.*RUNNING$"; then
            exit
          fi
          cage -- env WAYDROID_WIDTH=1920 WAYDROID_HEIGHT=1200 waydroid-full-ui &
          sleep 2
          while [[ -z "$(sudo waydroid shell getprop sys.boot_completed)" ]]
          do
            sleep 1
          done
          echo add | sudo tee /sys/devices/virtual/input/input*/event*/uevent
          wait
          waydroid session stop
          sudo waydroid container stop
        '';
      })
    ]
    ++ [
      inputs.waydroid-script.packages.${stdenv.hostPlatform.system}.default
    ];

  virtualisation.waydroid.enable = true;
  # Tell waydroid to use memfd and not ashmem
  systemd.tmpfiles.settings."99-waydroid-settings"."/var/lib/waydroid/waydroid_base.prop".C = {
    user = "root";
    group = "root";
    mode = "0644";
    argument = builtins.toString (
      pkgs.writeText "waydroid_base.prop" ''
        sys.use_memfd=true
      ''
    );
  };
}
