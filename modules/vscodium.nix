{inputs, ...}: {
  flake-file.inputs = {
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  flake.modules.nixos.base = {
    nixpkgs.overlays = [inputs.nix-vscode-extensions.overlays.default];
  };

  flake.modules.homeManager.base = {
    config,
    pkgs,
    lib,
    ...
  }: {
    config = lib.mkIf config.programs.vscodium.enable {
      home.packages = with pkgs; [
        biome
      ];
      programs.vscodium = {
        package = pkgs.vscodium;
        profiles.default = {
          enableUpdateCheck = false;
          enableExtensionUpdateCheck = false;
          extensions = with (lib.foldl' lib.recursiveUpdate {} [
            pkgs.open-vsx
            pkgs.vscode-marketplace
            pkgs.vscode-extensions
          ]); [
            ms-ceintl.vscode-language-pack-zh-hans
            ririd.packages
            formulahendry.auto-complete-tag
            formulahendry.auto-close-tag
            formulahendry.auto-rename-tag
            ibecker.treefmt-vscode
            christian-kohler.path-intellisense
            sirtori.indenticator
            kisstkondoros.vscode-gutter-preview
            jeanp413.open-remote-ssh
            intellsmi.comment-translate
            codeinchinese.englishchinesedictionary

            biomejs.biome

            jnoortheen.nix-ide

            nefrob.vscode-just-syntax
          ];
          userSettings = {
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
              "https://biomejs.dev" = true;
            };

            "treefmt.command" = lib.getExe pkgs.treefmt;

            "js/ts.tsdk.path" = pkgs.bun-types.tsdk.path;
            "js/ts.implicitProjectConfig.target" = "ESNext";

            "biome.configurationPath" = (pkgs.formats.json {}).generate "biome.json" {
              formatter = {
                indentStyle = "space";
              };
            };

            "nix.formatterPath" = [(lib.getExe pkgs.alejandra)];

            "vscode-just.lspPath" = lib.getExe pkgs.just-lsp;
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
          userSettings."[nix]" = {
            "editor.defaultFormatter" = "jnoortheen.nix-ide";
          };
          userSettings."[just]" = {
            "editor.defaultFormatter" = "nefrob.vscode-just-syntax";
          };
        };
      };
    };
  };
}
