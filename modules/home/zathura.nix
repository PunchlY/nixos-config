{
  nixosConfig,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (nixosConfig.theme) font colors;

  plugins = with pkgs.zathuraPkgs; [
    zathura_pdf_mupdf
  ];
in
{
  config = lib.mkIf config.programs.zathura.enable {
    home.packages = plugins;

    xdg.mimeApps.defaultApplicationPackages = plugins;

    programs.zathura = {
      options = with colors.hex; {
        default-bg = surface;
        default-fg = on_surface;

        inputbar-bg = surface_container_low;
        inputbar-fg = primary;

        statusbar-bg = surface_container;
        statusbar-fg = on_surface;

        completion-bg = surface_container;
        completion-fg = on_surface;

        completion-highlight-bg = primary;
        completion-highlight-fg = on_primary;

        completion-group-bg = surface_variant;
        completion-group-fg = on_surface_variant;

        notification-error-bg = error;
        notification-error-fg = on_error;

        notification-warning-bg = orange;
        notification-warning-fg = on_orange;

        font = "${font.name} ${toString font.size}";
      };
    };
  };
}
