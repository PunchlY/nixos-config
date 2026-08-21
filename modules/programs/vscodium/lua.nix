{
  flake.modules.homeManager.base = {
    config,
    pkgs,
    lib,
    ...
  }: {
    programs.vscodium.profiles.default = lib.mkIf config.programs.vscodium.enable {
      extensions = with pkgs.vscode-marketplace; [
        sumneko.lua
        johnnymorganz.stylua
      ];
      userSettings = {
        "stylua.styluaPath" = lib.getExe pkgs.stylua;
        "stylua.configPath" = (pkgs.formats.toml {}).generate "stylua.toml" {
          indent_type = "Spaces";
          indent_width = 2;
        };
      };
      userSettings."[lua]" = {
        "editor.defaultFormatter" = "JohnnyMorganz.stylua";
      };
      userSettings."[luau]" = {
        "editor.defaultFormatter" = "JohnnyMorganz.stylua";
      };
    };
  };
}
