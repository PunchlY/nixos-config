{
  nixosConfig,
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (nixosConfig.theme) colors font opacity;

  formatter = pkgs.formats.toml { };

  i3bar-river-config = with colors; {
    height = font.size * 2;
    font = "${font.name} ${toString font.size}";

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

    hide_inactive_tags = false;

    position = "top";

    command = lib.escapeShellArgs [
      (lib.getExe pkgs.i3status-rust)
      (formatter.generate "i3status-rust.toml" i3status-rust-config)
    ];
  };
  i3status-rust-config = with colors; {
    icons.icons = "material-nf";
    theme.theme = formatter.generate "i3status-theme.toml" {
      idle_bg = surface.hex;
      idle_fg = on_surface.hex;
      alternating_tint_bg =
        let
          toInt =
            {
              r,
              g,
              b,
            }:
            r * 65536 + g * 256 + b;
        in
        "#${
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
    };
    block = [
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
          { name = "v4l"; }
          { name = "pipewire"; }
        ];
      }
    ];
  };
in
{
  options.services.bar = {
    enable = lib.mkEnableOption "bar";
  };

  config = lib.mkIf config.services.bar.enable {
    systemd.user.services.bar = {
      Unit = {
        After = [ config.wayland.systemd.target ];
        ConditionEnvironment = "WAYLAND_DISPLAY";
      };

      Service = {
        ExecStart = "${lib.getExe pkgs.i3bar-river} -c ${formatter.generate "i3bar-river.toml" i3bar-river-config}";
        ExecReload = "${pkgs.coreutils}/bin/kill -SIGUSR2 $MAINPID";
        KillMode = "mixed";
        Restart = "on-failure";
      };

      Install.WantedBy = [ config.wayland.systemd.target ];
    };
  };
}
