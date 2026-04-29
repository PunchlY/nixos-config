{lib, ...}: {
  flake.homeModules.base = {config, ...}: {
    config = lib.mkIf config.programs.i3bar-river.enable {
      programs.i3status-rust.enable = true;

      programs.i3bar-river.settings = {
        command = ''i3status-rs "config-''${XDG_CURRENT_DESKTOP:-default}"'';
      };
    };
  };

  flake.homeModules.theme = {
    osConfig,
    config,
    ...
  }: let
    inherit (osConfig.theme) colors font;
  in {
    config = lib.mkIf config.programs.i3bar-river.enable {
      programs.i3bar-river.settings = with colors; {
        height = font.size * 2;
        font = "monospace ${toString font.size}";

        tags_padding = font.size;
        tags_margin = 0;
        separator_width = 0;
        background = surface.hex;
        tag_fg = on_surface.hex;
        tag_bg = surface.hex;
        tag_focused_fg = on_primary.hex;
        tag_focused_bg = primary.hex;
        tag_urgent_fg = on_error.hex;
        tag_urgent_bg = error.hex;
        tag_inactive_bg = surface.hex;
        tag_inactive_fg = on_surface.hex;
      };
    };
  };
}
