{
  config,
  lib,
  pkgs,
  md3,
  ...
}:
let
  cfg = config.theme;
in
{
  options.theme = {
    wallpaper = lib.mkOption {
      type = lib.types.path;
      default = pkgs.wallpaper.default;
    };

    colors = lib.mkOption {
      internal = true;
    };

    font = rec {
      package = lib.mkPackageOption pkgs.maple-mono "Normal-NF-CN-unhinted" { };
      name = lib.mkOption {
        type = lib.types.str;
        default = "Maple Mono Normal NF CN";
      };
      size = lib.mkOption {
        default = 14;
        type = with lib.types; either ints.unsigned float;
      };
    };

    emoji = {
      package = lib.mkPackageOption pkgs "noto-fonts-color-emoji" { };
      name = lib.mkOption {
        type = lib.types.str;
        default = "Noto Color Emoji";
      };
    };

    opacity = lib.mkOption {
      type = lib.types.float;
      default = 0.75;
    };

    cursor = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "Bibata-Modern-Classic";
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.bibata-cursors;
      };
      size = lib.mkOption {
        type = lib.types.int;
        default = 32;
      };
    };
  };

  config = {
    theme.colors = rec {
      rgb = lib.importJSON (
        pkgs.runCommand "generated-theme" {
          nativeBuildInputs = [
            md3.packages.${pkgs.stdenv.hostPlatform.system}.default
          ];
          image = pkgs.runCommand "wallpaper-resize.png" {
            nativeBuildInputs = [ pkgs.imagemagick ];
          } "magick ${cfg.wallpaper} -resize 128x128 $out";
        } "md3 --image=$image --output=$out --dark --json={rgb}"
      );
      hex = builtins.mapAttrs (name: value: "#${value}") hex_stripped;
      hex_stripped = builtins.mapAttrs (
        name:
        {
          r,
          g,
          b,
        }:
        lib.fixedWidthString 6 "0" (lib.toHexString (r * 65536 + g * 256 + b))
      ) rgb;
    };

    environment.variables.XCURSOR_SIZE = toString cfg.cursor.size;

    fonts = {
      enableDefaultPackages = false;
      packages = [
        cfg.font.package
        cfg.emoji.package
      ]
      ++ (with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
        noto-fonts-monochrome-emoji

        material-icons
        lmmath
      ]);
      fontconfig.defaultFonts =
        lib.genAttrs
          [
            "monospace"
            "serif"
            "sansSerif"
          ]
          (family: [
            cfg.font.name
            cfg.emoji.name
            "Noto Sans Mono"
            "Noto Sans Mono CJK SC"
            "Noto Color Emoji"
            "Noto Emoji"
          ])
        // {
          emoji = [
            cfg.emoji.name
            "Noto Color Emoji"
            "Noto Emoji"
          ];
        };
    };

    systemd.services.set-tty-colors = {
      description = "Apply Kanagawa TTY colors and font";
      wantedBy = [ "multi-user.target" ];
      after = [ "systemd-vconsole-setup.service" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = with cfg.colors.hex_stripped; ''
        for tty in /dev/tty{1..6}; do
          echo -en "\e]P0${black}" > "$tty"
          echo -en "\e]P1${red_dim}" > "$tty"
          echo -en "\e]P2${green_dim}" > "$tty"
          echo -en "\e]P3${yellow_dim}" > "$tty"
          echo -en "\e]P4${blue_dim}" > "$tty"
          echo -en "\e]P5${magenta_dim}" > "$tty"
          echo -en "\e]P6${cyan_dim}" > "$tty"
          echo -en "\e]P7${white}" > "$tty"
          echo -en "\e]P8${gray}" > "$tty"
          echo -en "\e]P9${red}" > "$tty"
          echo -en "\e]PA${green}" > "$tty"
          echo -en "\e]PB${yellow}" > "$tty"
          echo -en "\e]PC${blue}" > "$tty"
          echo -en "\e]PD${magenta}" > "$tty"
          echo -en "\e]PE${cyan}" > "$tty"
          echo -en "\e]PF${white_bright}" > "$tty"
        done
      '';
    };
  };
}
