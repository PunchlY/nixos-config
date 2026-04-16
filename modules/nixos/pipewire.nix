{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.services.pipewire.enable {
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      alsa.enable = true;
      pulse.enable = true;
    };
  };
}
