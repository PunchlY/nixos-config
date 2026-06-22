{
  flake.modules.homeManager.base = {
    config,
    pkgs,
    lib,
    ...
  }: let
    plugins = with pkgs.zathuraPkgs; [
      zathura_pdf_poppler
    ];
  in {
    config = lib.mkIf config.programs.zathura.enable {
      home.packages = plugins;

      xdg.mimeApps.defaultApplicationPackages = plugins;
    };
  };

  flake.modules.homeManager.theme = {
    config,
    lib,
    ...
  }: let
    inherit (config.theme) font colors;
  in {
    config = lib.mkIf config.programs.zathura.enable {
      programs.zathura = {
        options = with colors; {
          default-bg = surface.hex;
          default-fg = on_surface.hex;

          inputbar-bg = surface_container_low.hex;
          inputbar-fg = primary.hex;

          statusbar-bg = surface_container.hex;
          statusbar-fg = on_surface.hex;

          completion-bg = surface_container.hex;
          completion-fg = on_surface.hex;

          completion-highlight-bg = primary.hex;
          completion-highlight-fg = on_primary.hex;

          completion-group-bg = surface_variant.hex;
          completion-group-fg = on_surface_variant.hex;

          notification-error-bg = error.hex;
          notification-error-fg = on_error.hex;

          notification-warning-bg = yellow.hex;
          notification-warning-fg = on_yellow.hex;

          font = "monospace ${toString font.size}";
        };
      };
    };
  };
}
