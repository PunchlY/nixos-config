{inputs, ...}: {
  flake-file.inputs = {
    bun2nix = {
      url = "github:nix-community/bun2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  flake.modules.nixos.base = {
    nixpkgs.overlays = [inputs.bun2nix.overlays.default];
  };

  perSystem = {
    system,
    final,
    pkgs,
    ...
  }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [inputs.bun2nix.overlays.default];
    };

    overlayAttrs = {
      bun-types = final.callPackage ./bun-types/package.nix {};

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

      db2 = final.callPackage ./db2.nix {};

      fuzzel-polkit-agent = final.callPackage ./fuzzel-polkit-agent/package.nix {};

      gtk-nocsd = final.callPackage ./gtk-nocsd.nix {};

      ls-wayland = final.callPackage ./ls-wayland.nix {};

      haier = final.home-assistant.python3Packages.callPackage ./home-assistant/haier.nix {};

      midea-auto-cloud = final.home-assistant.python3Packages.callPackage ./home-assistant/midea-auto-cloud.nix {};

      pvz-rh = final.callPackage ./pvz-rh.nix {};

      pywincontrols = final.python3Packages.callPackage ./pywincontrols.nix {};

      waydroid-launcher = final.callPackage ./waydroid-launcher/package.nix {};

      wayllpaper = final.callPackage ./wayllpaper.nix {};

      wleird = final.callPackage ./wleird.nix {};
    };
  };
}
