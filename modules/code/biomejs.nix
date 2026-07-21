{
  flake.modules.homeManager.base = {
    config,
    pkgs,
    lib,
    ...
  }: {
    programs.vscodium.profiles.default = lib.mkIf config.programs.vscodium.enable {
      extensions = with pkgs.vscode-extensions; [
        biomejs.biome
      ];
      userSettings = {
        "json.schemaDownload.trustedDomains" = {
          "https://biomejs.dev" = true;
        };

        "biome.lsp.bin" = lib.getExe pkgs.biome;
        "biome.configurationPath" = (pkgs.formats.json {}).generate "biome.json" {
          formatter = {
            indentStyle = "space";
          };
        };
      };
      userSettings."[typescript]" = {
        "editor.defaultFormatter" = "biomejs.biome";
      };
      userSettings."[typescriptreact]" = {
        "editor.defaultFormatter" = "biomejs.biome";
      };
      userSettings."[javascript]" = {
        "editor.defaultFormatter" = "biomejs.biome";
      };
      userSettings."[json]" = {
        "editor.defaultFormatter" = "biomejs.biome";
      };
      userSettings."[jsonc]" = {
        "editor.defaultFormatter" = "biomejs.biome";
      };
    };
  };
}
