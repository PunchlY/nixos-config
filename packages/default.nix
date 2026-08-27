{inputs, ...}: {
  flake-file.inputs = {
    bun2nix = {
      url = "github:nix-community/bun2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    bun = {
      url = "github:Daste745/nix-bun";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixpkgs.overlays = [inputs.bun2nix.overlays.default];

  perSystem = {
    config,
    final,
    pkgs,
    inputs',
    lib,
    ...
  }: {
    packages = config.overlayAttrs;

    overlayAttrs = {
      balatro = final.callPackage ./balatro/package.nix {};

      bun-latest =
        builtins.attrNames inputs'.bun.packages
        |> lib.sort (a: b: builtins.compareVersions a b < 0)
        |> lib.last
        |> lib.flip builtins.getAttr inputs'.bun.packages;
      # bun-latest = lib.pipe inputs'.bun.packages [
      #   lib.attrNames
      #   (lib.sort (a: b: lib.compareVersions a b < 0))
      #   lib.last
      #   lib.getAttr
      # ]
      # inputs'.bun.packages;

      bun-types = final.callPackage ./bun-types/package.nix {};

      celeste64 = pkgs.celeste64.overrideAttrs (oldAttrs: {
        nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [final.makeWrapper];
        postFixup =
          (oldAttrs.postFixup or "")
          + ''
            wrapProgram $out/bin/Celeste64 \
              --set SDL_VIDEO_HIGHDPI_DISABLED "1"
          '';
      });

      cmd = final.callPackage ./cmd.nix {};

      cmd-polkit = pkgs.cmd-polkit.overrideAttrs {
        version = "0.4.0-0.270";
        src = pkgs.fetchFromGitHub {
          owner = "OmarCastro";
          repo = "cmd-polkit";
          rev = "d280aeb9d34f6dde39552b99a785d1f67e72edf3";
          hash = "sha256-ZAQwfUxgrpXCbMakndchjW0riAc+w2ox33FITwZ5BhY=";
        };
      };

      color256 = final.callPackage ./color256.nix {};

      custom-scripts = final.callPackage ./custom-scripts/package.nix {};

      cronstrue = final.callPackage ./cronstrue.nix {};

      db2 = final.callPackage ./db2.nix {};

      fuzzel-polkit-agent = final.callPackage ./fuzzel-polkit-agent/package.nix {};

      gtk-nocsd = final.callPackage ./gtk-nocsd.nix {};

      ls-wayland = final.callPackage ./ls-wayland.nix {};

      haier = final.home-assistant.python3Packages.callPackage ./home-assistant/haier.nix {};

      midea-auto-cloud = final.home-assistant.python3Packages.callPackage ./home-assistant/midea-auto-cloud.nix {};

      pvz-rh = final.callPackage ./pvz-rh.nix {};

      pywincontrols = final.python3Packages.callPackage ./pywincontrols.nix {};

      the-powder-toy-chinese = final.callPackage ./the-powder-toy-chinese.nix {};

      waydroid-launcher = final.callPackage ./waydroid-launcher/package.nix {};

      wayllpaper = final.callPackage ./wayllpaper.nix {};

      wiliwili = pkgs.wiliwili.overrideAttrs {
        version = "1.6.0";
        src = final.fetchFromGitHub {
          owner = "xfangfang";
          repo = "wiliwili";
          tag = "v1.6.0";
          fetchSubmodules = true;
          hash = "sha256-J6oUMUzfogsIBj1GpwWmKhjphTV628rG+3w28Dc81Fw=";
        };
      };

      wleird = final.callPackage ./wleird.nix {};
    };

    apps = let
      binPath = "${lib.getBin final.custom-scripts}/bin";
    in
      builtins.readDir binPath
      |> lib.mapAttrs (name: _: {
        type = "app";
        program = "${binPath}/${name}";
      });
    legacyPackages.vscode-typescript-next = pkgs.open-vsx.nsttt.native-preview.overrideAttrs (oldAttrs: {
      nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [pkgs.yq-go];
      postPatch =
        (oldAttrs.postPatch or "")
        + ''
          yq -i '.engines.vscode = "^1.110.0"' package.json
        '';
    });
  };
}
