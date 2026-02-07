{ nixosConfig, ... }:
{
  home.pointerCursor = {
    inherit (nixosConfig.theme.cursor) name package size;
    x11.enable = true;
    gtk.enable = true;
  };
}
