{
  flake.modules.homeManager.base = {
    config,
    pkgs,
    lib,
    ...
  }: {
    programs.vscodium.profiles.default = lib.mkIf config.programs.vscodium.enable {
      extensions = with pkgs.vscode-extensions; [
        denoland.vscode-deno
      ];
      userSettings = {
        "deno.lint" = true;
        "deno.path" = lib.getExe pkgs.deno;
      };
      userSettings."[typescript]" = {
        "editor.defaultFormatter" = "denoland.vscode-deno";
      };
      userSettings."[typescriptreact]" = {
        "editor.defaultFormatter" = "denoland.vscode-deno";
      };
      userSettings."[javascript]" = {
        "editor.defaultFormatter" = "denoland.vscode-deno";
      };
      userSettings."[json]" = {
        "editor.defaultFormatter" = "denoland.vscode-deno";
      };
      userSettings."[jsonc]" = {
        "editor.defaultFormatter" = "denoland.vscode-deno";
      };
      userSettings."[yaml]" = {
        "editor.defaultFormatter" = "denoland.vscode-deno";
      };
    };
  };
}
