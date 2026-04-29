{lib, ...}: {
  flake.homeModules.base = {config, ...}: {
    config = lib.mkIf config.programs.niri.enable {
      programs.i3bar-river.enable = true;
      programs.i3status-rust = {
        enable = true;
        bars.niri.blocks = [
          {
            block = "music";
            format = " $icon $combo.str(max_w:32) $prev $play $next |";
            format_alt = " $icon $player $volume_icon $volume |";
            seek_step_secs = 10;
            click = [
              {
                button = "up";
                action = "volume_up";
              }
              {
                button = "down";
                action = "volume_down";
              }
            ];
          }
          {
            block = "service_status";
            service = "mihomo";
            active_format = " 󰄛 ";
            inactive_format = "";
            merge_with_next = true;
          }
          {
            block = "net";
            format = " $icon |";
            inactive_format = "";
            missing_format = "";
            device = "^wlan0$";
            merge_with_next = true;
          }
          {
            block = "net";
            format = " $icon |";
            inactive_format = "";
            missing_format = "";
            device = "^eno1$";
            merge_with_next = true;
          }
          {
            block = "memory";
            format = " $icon $mem_used_percents.eng(w:2) ";
            # format_alt = " $icon_swap $swap_used_percents.eng(w:2) ";
            merge_with_next = true;
          }
          {
            block = "cpu";
            format = " $icon $utilization.eng(w:2) ";
            # format_alt = " $icon $barchart ";
            merge_with_next = true;
          }
          {
            block = "battery";
            format = " $icon $percentage.eng(w:2) ";
            theme_overrides = {
              good_bg.link = "idle_bg";
              good_fg.link = "idle_fg";
              info_bg.link = "idle_bg";
              info_fg.link = "idle_fg";
            };
          }
          {
            block = "sound";
            format = " $icon {$volume.eng(w:2) |}";
            format_alt = " $icon $output_name ";
            merge_with_next = true;
          }
          {
            block = "sound";
            device_kind = "source";
            format = " $icon {$volume.eng(w:2) |}";
            format_alt = " $icon $output_name ";
          }
          {
            block = "time";
            format = " $timestamp.datetime(f:%R) ";
          }
          {
            block = "privacy";
            driver = [
              {name = "v4l";}
              {name = "pipewire";}
            ];
          }
        ];
      };

      programs.niri.settings.spawn-at-startup = [
        {
          argv = ["i3bar-river"];
        }
      ];
    };
  };

  flake.homeModules.theme = {
    osConfig,
    config,
    pkgs,
    ...
  }: let
    inherit (osConfig.theme) colors;
  in {
    config = lib.mkIf config.programs.niri.enable {
      programs.i3status-rust.bars.niri = {
        icons = "material-nf";
        theme = "${(pkgs.formats.toml {}).generate "i3status-theme.toml" (with colors; {
          idle_bg = surface.hex;
          idle_fg = on_surface.hex;
          alternating_tint_bg = let
            toInt = v: v.r * 65536 + v.g * 256 + v.b;
          in "#${
            lib.fixedWidthString 6 "0" (lib.toHexString ((toInt surface_bright.rgb) - (toInt surface.rgb)))
          }00";
          info_bg = surface.hex;
          info_fg = blue.hex;
          good_bg = surface.hex;
          good_fg = green.hex;
          warning_bg = surface.hex;
          warning_fg = orange.hex;
          critical_bg = surface.hex;
          critical_fg = error.hex;
          separator = "";
        })}";
      };
    };
  };
}
