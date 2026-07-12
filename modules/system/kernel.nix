{inputs, ...}: {
  flake-file.inputs = {
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
  };

  flake-file.nixConfig = {
    substituters = [
      # "https://cache.xinux.uz"
      "https://attic.xuyh0120.win/lantian"
    ];
    trusted-public-keys = [
      # "cache.xinux.uz:BXCrtqejFjWzWEB9YuGB7X2MV4ttBur1N8BkwQRdH+0="
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
    ];
  };

  flake.modules.nixos.base = {
    nixpkgs.overlays = [
      inputs.nix-cachyos-kernel.overlays.pinned
    ];
  };
}
