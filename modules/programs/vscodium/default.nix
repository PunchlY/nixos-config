{inputs, ...}: {
  flake-file.inputs = {
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixpkgs.overlays = [inputs.nix-vscode-extensions.overlays.default];

  flake.modules.homeManager.base = {
    config,
    pkgs,
    lib,
    ...
  }: {
    config = lib.mkIf config.programs.vscodium.enable {
      programs.vscodium.mutableExtensionsDir = false;
      programs.vscodium.profiles.default = {
        enableUpdateCheck = false;
        enableExtensionUpdateCheck = false;
        extensions =
          (with pkgs.vscode-marketplace; [
            ms-ceintl.vscode-language-pack-zh-hans
            ririd.packages
            formulahendry.auto-complete-tag
            formulahendry.auto-close-tag
            formulahendry.auto-rename-tag
            christian-kohler.path-intellisense
            sirtori.indenticator
            kisstkondoros.vscode-gutter-preview
            intellsmi.comment-translate
            codeinchinese.englishchinesedictionary
          ])
          ++ (with pkgs.open-vsx; [
            jeanp413.open-remote-ssh
          ]);
        userSettings = {
          "extensions.autoUpdate" = "off";

          "terminal.integrated.stickyScroll.enabled" = false;
          "terminal.integrated.initialHint" = false;

          "explorer.confirmDelete" = false;

          "editor.wordWrap" = "on";
          "editor.fontFamily" = "monospace";
          "editor.fontLigatures" = true;
          "editor.tabSize" = 2;
          "editor.unicodeHighlight.allowedLocales" = {
            "zh-hans" = true;
            "zh-hant" = true;
          };

          "window.menuStyle" = "native";
          "window.titleBarStyle" = "native";
          "window.menuBarVisibility" = "toggle";
          "window.customTitleBarVisibility" = "never";
          "window.zoomLevel" = 1.5;

          "update.mode" = "none";

          "diffEditor.ignoreTrimWhitespace" = false;

          "files.insertFinalNewline" = true;

          "workbench.editor.enablePreview" = false;
          "workbench.editor.showTabs" = "none";

          "update.showReleaseNotes" = false;

          "commentTranslate.source" = "Bing";
          "commentTranslate.maxTranslationLength" = 1024;
          "commentTranslate.hover.concise" = true;
          "commentTranslate.hover.string" = true;
          "commentTranslate.hover.variable" = true;
          "commentTranslate.hover.content" = true;
          "commentTranslate.multiLineMerge" = true;
          "commentTranslate.targetLanguage" = "zh-CN";

          "json.schemaDownload.trustedDomains" = {
            "https://schemastore.azurewebsites.net/" = true;
            "https://raw.githubusercontent.com/microsoft/vscode/" = true;
            "https://raw.githubusercontent.com/devcontainers/spec/" = true;
            "https://www.schemastore.org/" = true;
            "https://json.schemastore.org/" = true;
            "https://json-schema.org/" = true;
            "https://developer.microsoft.com/json-schemas/" = true;
          };
        };
      };
    };
  };
}
