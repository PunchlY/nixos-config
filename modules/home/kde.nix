{nixosConfig, ...}: let
  inherit (nixosConfig.theme) colors font cursor;
in {
  xdg.configFile."kdeglobals".text = ''
    [ColorEffects:Disabled]
    Color=${colors.surface_dim.hex}
    ColorAmount=0
    ColorEffect=0
    ContrastAmount=0.65
    ContrastEffect=1
    IntensityAmount=0.1
    IntensityEffect=2

    [ColorEffects:Inactive]
    ChangeSelectionColor=true
    Color=${colors.surface_variant.hex}
    ColorAmount=0.025
    ColorEffect=2
    ContrastAmount=0.1
    ContrastEffect=2
    Enable=false
    IntensityAmount=0
    IntensityEffect=0

    [Colors:Button]
    BackgroundAlternate=${colors.surface_container_low.hex}
    BackgroundNormal=${colors.surface_container_high.hex}
    DecorationFocus=${colors.primary.hex}
    DecorationHover=${colors.primary.hex}
    ForegroundActive=${colors.primary.hex}
    ForegroundInactive=${colors.on_surface_variant.hex}
    ForegroundLink=${colors.secondary.hex}
    ForegroundNegative=${colors.error.hex}
    ForegroundNeutral=${colors.tertiary.hex}
    ForegroundNormal=${colors.on_surface.hex}
    ForegroundPositive=${colors.tertiary_fixed.hex}
    ForegroundVisited=${colors.on_secondary_container.hex}

    [Colors:Complementary]
    BackgroundAlternate=${colors.surface_container_low.hex}
    BackgroundNormal=${colors.surface.hex}
    DecorationFocus=${colors.primary.hex}
    DecorationHover=${colors.primary.hex}
    ForegroundActive=${colors.primary.hex}
    ForegroundInactive=${colors.on_surface_variant.hex}
    ForegroundLink=${colors.secondary.hex}
    ForegroundNegative=${colors.error.hex}
    ForegroundNeutral=${colors.tertiary.hex}
    ForegroundNormal=${colors.on_primary_container.hex}
    ForegroundPositive=${colors.tertiary_fixed.hex}
    ForegroundVisited=${colors.on_secondary_container.hex}

    [Colors:Header]
    BackgroundAlternate=${colors.surface.hex}
    BackgroundNormal=${colors.surface_container.hex}
    DecorationFocus=${colors.primary.hex}
    DecorationHover=${colors.primary.hex}
    ForegroundActive=${colors.primary.hex}
    ForegroundInactive=${colors.on_surface_variant.hex}
    ForegroundLink=${colors.secondary.hex}
    ForegroundNegative=${colors.error.hex}
    ForegroundNeutral=${colors.tertiary.hex}
    ForegroundNormal=${colors.on_surface.hex}
    ForegroundPositive=${colors.tertiary_fixed.hex}
    ForegroundVisited=${colors.on_secondary_container.hex}

    [Colors:Header][Inactive]
    BackgroundAlternate=${colors.surface_container.hex}
    BackgroundNormal=${colors.surface.hex}
    DecorationFocus=${colors.primary.hex}
    DecorationHover=${colors.primary.hex}
    ForegroundActive=${colors.primary.hex}
    ForegroundInactive=${colors.on_surface_variant.hex}
    ForegroundLink=${colors.secondary.hex}
    ForegroundNegative=${colors.error.hex}
    ForegroundNeutral=${colors.tertiary.hex}
    ForegroundNormal=${colors.on_surface.hex}
    ForegroundPositive=${colors.tertiary_fixed.hex}
    ForegroundVisited=${colors.on_secondary_container.hex}

    [Colors:Selection]
    BackgroundAlternate=${colors.surface_container_low.hex}
    BackgroundNormal=${colors.primary.hex}
    DecorationFocus=${colors.primary.hex}
    DecorationHover=${colors.primary.hex}
    ForegroundActive=${colors.on_primary.hex}
    ForegroundInactive=${colors.on_surface_variant.hex}
    ForegroundLink=${colors.secondary_fixed.hex}
    ForegroundNegative=${colors.error_container.hex}
    ForegroundNeutral=${colors.tertiary_fixed_dim.hex}
    ForegroundNormal=${colors.secondary_fixed.hex}
    ForegroundPositive=${colors.tertiary_container.hex}
    ForegroundVisited=${colors.on_secondary_container.hex}

    [Colors:Tooltip]
    BackgroundAlternate=${colors.surface.hex}
    BackgroundNormal=${colors.surface_container.hex}
    DecorationFocus=${colors.primary.hex}
    DecorationHover=${colors.primary.hex}
    ForegroundActive=${colors.primary.hex}
    ForegroundInactive=${colors.on_surface_variant.hex}
    ForegroundLink=${colors.secondary.hex}
    ForegroundNegative=${colors.error.hex}
    ForegroundNeutral=${colors.tertiary.hex}
    ForegroundNormal=${colors.on_background.hex}
    ForegroundPositive=${colors.tertiary_fixed.hex}
    ForegroundVisited=${colors.on_secondary_container.hex}

    [Colors:View]
    BackgroundAlternate=${colors.surface_container.hex}
    BackgroundNormal=${colors.background.hex}
    DecorationFocus=${colors.primary_container.hex}
    DecorationHover=${colors.on_primary.hex}
    ForegroundActive=${colors.primary.hex}
    ForegroundInactive=${colors.on_surface_variant.hex}
    ForegroundLink=${colors.secondary.hex}
    ForegroundNegative=${colors.error.hex}
    ForegroundNeutral=${colors.tertiary.hex}
    ForegroundNormal=${colors.on_background.hex}
    ForegroundPositive=${colors.tertiary_fixed.hex}
    ForegroundVisited=${colors.on_secondary_container.hex}

    [Colors:Window]
    BackgroundAlternate=${colors.primary_container.hex}
    BackgroundNormal=${colors.surface_container.hex}
    DecorationFocus=${colors.primary.hex}
    DecorationHover=${colors.primary.hex}
    ForegroundActive=${colors.primary.hex}
    ForegroundInactive=${colors.on_surface_variant.hex}
    ForegroundLink=${colors.secondary.hex}
    ForegroundNegative=${colors.error.hex}
    ForegroundNeutral=${colors.tertiary.hex}
    ForegroundNormal=${colors.on_background.hex}
    ForegroundPositive=${colors.tertiary_fixed.hex}
    ForegroundVisited=${colors.on_secondary_container.hex}

    [General]
    ColorScheme=md3
    Name=md3
    shadeSortColumn=true
    font=${font.name},${toString font.size},-1,5,400,0,0,0,0,0,0,0,0,0,0,1

    [Appearance]
    color_scheme=md3

    [KDE]
    contrast=4

    [WM]
    activeBackground=${colors.primary_container.hex}
    activeBlend=${colors.on_primary_container.hex}
    activeForeground=${colors.on_primary_container.hex}
    inactiveBackground=${colors.surface.hex}
    inactiveBlend=${colors.on_surface_variant.hex}
    inactiveForeground=${colors.on_surface_variant.hex}
  '';

  xdg.configFile."kcminputrc".text = ''
    [Mouse]
    cursorTheme=${cursor.name}
    cursorSize=${toString cursor.size}
  '';

  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
  };
}
