{
  self,
  lib,
  ...
}: {
  flake.modules.nixos.theme = {
    options,
    config,
    ...
  }: {
    config = lib.optionalAttrs (options ? home-manager) {
      home-manager = {
        sharedModules =
          [self.modules.homeManager.theme]
          ++ map (path: lib.getAttrFromPath path config |> lib.mkDefault |> lib.setAttrByPath path) [
            ["theme" "wallpaper"]
            ["theme" "opacity"]

            ["theme" "cursor" "name"]
            ["theme" "cursor" "package"]
            ["theme" "cursor" "size"]

            ["theme" "font" "name"]
            ["theme" "font" "package"]
            ["theme" "font" "size"]
          ];
      };
    };
  };
}
