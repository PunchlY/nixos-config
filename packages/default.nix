{
  perSystem = {
    final,
    pkgs,
    ...
  }: {
    overlayAttrs = {
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

      fuzzel-polkit-agent = final.callPackage ./fuzzel-polkit-agent/package.nix {};

      gtk-nocsd = final.callPackage ./gtk-nocsd.nix {};

      ls-wayland = final.callPackage ./ls-wayland.nix {};

      haier = final.home-assistant.python3Packages.callPackage ./home-assistant/haier.nix {};

      midea-auto-cloud = final.home-assistant.python3Packages.callPackage ./home-assistant/midea-auto-cloud.nix {};

      pvz-rh = final.callPackage ./pvz-rh.nix {};

      pywincontrols = final.python3Packages.callPackage ./pywincontrols.nix {};

      unblockneteasemusic = final.callPackage ./unblockneteasemusic.nix {};

      waydroid-launcher = final.callPackage ./waydroid-launcher/package.nix {};

      wayllpaper = final.callPackage ./wayllpaper.nix {};

      wleird = final.callPackage ./wleird.nix {};
    };
  };
}
