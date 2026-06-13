{
  lib,
  moduleWithSystem,
  ...
}: {
  flake-file.inputs = {
    bemenu = {
      url = "github:Cloudef/bemenu";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  flake.modules.homeManager.base = moduleWithSystem ({inputs', ...}: {
    config,
    pkgs,
    ...
  }: {
    config = lib.mkIf config.programs.bemenu.enable {
      programs.bemenu.package = pkgs.writeShellApplication {
        name = "bemenu";
        runtimeInputs = [
          inputs'.bemenu.packages.default
        ];
        text = ''
          config="''${BEMENU_CONFIG:-"''${XDG_CONFIG_HOME:-"$HOME/.config"}/bemenu"}"
          args=()
          [ -f "$config" ] && while IFS= read -r line; do
            [[ -z ''${line//[[:space:]]/} ]] && continue
            printf -v decoded '%b' "$line"
            args+=("--$decoded")
          done <"$config"

          exec bemenu "''${args[@]}" "$@"
        '';
      };
    };
  });

  flake.modules.homeManager.theme = {
    osConfig,
    config,
    ...
  }: let
    inherit (osConfig.theme) font colors;
  in {
    config = lib.mkIf config.programs.bemenu.enable {
      xdg.configFile.bemenu.text = with colors; ''
        ignorecase
        single-instance
        no-cursor
        no-touch
        no-spacing
        fn=monospace ${toString font.size}
        line-height=${toString (font.size * 2)}
        hp=${toString font.size}
        tb=${primary.hex}
        tf=${on_primary.hex}
        fb=${surface.hex}
        ff=${on_surface.hex}
        cb=${surface.hex}
        cf=${on_surface.hex}
        nb=${surface.hex}
        nf=${on_surface.hex}
        hb=${primary.hex}
        hf=${on_primary.hex}
        ab=${surface_bright.hex}
        af=${on_surface.hex}
        scb=${surface.hex}
        scf=${surface_bright.hex}
      '';
    };
  };
}
