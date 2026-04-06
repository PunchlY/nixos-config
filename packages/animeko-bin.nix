{
  lib,
  appimageTools,
  fetchurl,
  stdenvNoCC,
}: let
  pname = "animeko";

  sources = {
    x86_64-linux = rec {
      version = "5.2.0";
      src = fetchurl {
        url = "https://github.com/open-ani/animeko/releases/download/v${version}/ani-${version}-linux-x86_64.appimage";
        hash = "sha256-HD2bVY3lK7hGtE2JNCWrNWWZ9+SlnsdRO1nBc9h2Rio=";
      };
    };
  };

  inherit (stdenvNoCC.hostPlatform) system;
  inherit (sources.${system} or (throw "Unsupported system: ${system}")) version src;

  appimageContents = appimageTools.extract {
    inherit pname version src;
    postExtract = ''
      substituteInPlace $out/animeko.desktop \
        --replace-fail 'Exec=Ani' 'Exec=${pname}' \
        --replace-fail 'Icon=icon' 'Icon=${pname}'
    '';
  };
in
  appimageTools.wrapAppImage {
    inherit pname version;

    src = appimageContents;

    extraPkgs = pkgs: with pkgs; [libvlc];

    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/animeko.desktop $out/share/applications/${pname}.desktop
      install -m 444 -D ${appimageContents}/icon.png $out/share/icons/hicolor/512x512/apps/${pname}.png
    '';
  }
