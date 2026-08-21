{
  flake.modules.homeManager.base = {
    config,
    lib,
    ...
  }: let
    cfg = config.programs.swayimg;
  in {
    config = lib.mkIf cfg.enable {
      xdg.mimeApps.defaultApplicationPackages = [
        cfg.package
      ];

      programs.swayimg.initLua = ''
        -- Viewer mode
        swayimg.viewer.on_key("q", function()
          swayimg.exit()
        end)

        swayimg.viewer.on_key("l", function()
          swayimg.viewer.switch_image("next")
        end)

        swayimg.viewer.on_key("h", function()
          swayimg.viewer.switch_image("prev")
        end)

        swayimg.on_window_resize(function()
          if swayimg.mode == "viewer" then
            swayimg.viewer.set_fix_scale("optimal")
          end
        end)
      '';
    };
  };

  flake.modules.homeManager.theme = {
    config,
    lib,
    ...
  }: let
    inherit (config.theme) font colors opacity;
    cfg = config.programs.swayimg;
    opacity_hex = lib.fixedWidthString 2 "0" (lib.toHexString (builtins.ceil (opacity * 255)));
  in {
    config = lib.mkIf cfg.enable {
      programs.swayimg.initLua = with colors; ''
        -- Text layer
        swayimg.text.font = "monospace"
        swayimg.text.size = ${toString font.size}
        swayimg.text.color = 0xff${on_surface.hex_stripped}
        swayimg.text.shadow = 0x00000000
        swayimg.text.background = 0x${opacity_hex}${surface.hex_stripped}

        -- Viewer mode
        swayimg.viewer.set_window_background(0x${opacity_hex}${surface.hex_stripped})

        -- Gallery mode
        swayimg.gallery.selected_color = 0xff${surface_bright.hex_stripped}
        swayimg.gallery.unselected_color = 0xff${surface_dim.hex_stripped}
        swayimg.gallery.border_color = 0xff${primary.hex_stripped}
        swayimg.gallery.window_color = 0x${opacity_hex}${surface.hex_stripped}
      '';
    };
  };
}
