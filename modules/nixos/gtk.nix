{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.theme) colors font cursor;

  gtkCss = with colors; ''
    ${lib.concatStringsSep "\n" (
      lib.mapAttrsToList (name: value: "@define-color ${name} ${value.hex};") colors
    )}
    @define-color accent_color ${primary_fixed_dim.hex};
    @define-color accent_fg_color ${on_primary_fixed.hex};
    @define-color accent_bg_color ${primary_fixed_dim.hex};
    @define-color window_bg_color ${surface_dim.hex};
    @define-color window_fg_color ${on_surface.hex};
    @define-color headerbar_bg_color ${surface_dim.hex};
    @define-color headerbar_fg_color ${on_surface.hex};
    @define-color popover_bg_color ${surface_dim.hex};
    @define-color popover_fg_color ${on_surface.hex};
    @define-color view_bg_color ${surface.hex};
    @define-color view_fg_color ${on_surface.hex};
    @define-color card_bg_color ${surface.hex};
    @define-color card_fg_color ${on_surface.hex};
    @define-color sidebar_bg_color @window_bg_color;
    @define-color sidebar_fg_color @window_fg_color;
    @define-color sidebar_border_color @window_bg_color;
    @define-color sidebar_backdrop_color @window_bg_color;
  '';
in {
  config = {
    programs.dconf.enable = true;
  };

  config.home-manager.sharedModules = lib.singleton {
    gtk = {
      enable = true;

      colorScheme = "dark";

      font = {
        name = "monospace";
        size = font.size;
      };
      theme = {
        package = pkgs.adw-gtk3;
        name = "adw-gtk3";
      };
      iconTheme = {
        package = pkgs.papirus-icon-theme;
        name = "Papirus-Dark";
      };
      cursorTheme = {
        inherit (cursor) package name size;
      };

      gtk3 = {
        enable = true;
        extraCss = gtkCss;
      };
      gtk4 = {
        enable = true;
        extraCss = gtkCss;
      };
    };
  };
}
