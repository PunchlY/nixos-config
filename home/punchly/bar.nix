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

  i3bar-river-config = with colors.hex; {
    height = font.size * 2;
    font = "${font.name} ${toString font.size}";

    tags_padding = font.size;
    tags_margin = 0;
    separator_width = 0;
    background = surface;
    tag_fg = on_surface;
    tag_bg = surface;
    tag_focused_fg = on_primary;
    tag_focused_bg = primary;
    tag_urgent_fg = on_error;
    tag_urgent_bg = error;
    tag_inactive_bg = surface;
    tag_inactive_fg = on_surface;

    hide_inactive_tags = false;

    position = "top";

    command = lib.escapeShellArgs [
      (lib.getExe pkgs.i3status-rust)
      (formatter.generate "i3status-rust.toml" i3status-rust-config)
    ];
  };
  i3status-rust-config = with colors.hex; {
    icons.icons = "material-nf";
    theme.theme = formatter.generate "i3status-theme.toml" {
      idle_bg = surface;
      idle_fg = on_surface;
      alternating_tint_bg =
        with colors.rgb;
        let
          toInt =
            {
              r,
              g,
              b,
            }:
            r * 65536 + g * 256 + b;
        in
        "#${lib.fixedWidthString 6 "0" (lib.toHexString ((toInt surface_bright) - (toInt surface)))}00";
      info_bg = surface;
      info_fg = blue;
      good_bg = surface;
      good_fg = green;
      warning_bg = surface;
      warning_fg = orange;
      critical_bg = surface;
      critical_fg = error;
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
}
