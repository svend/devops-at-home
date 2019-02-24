{ config, username, ... }:
let
  selfHM = config.home-manager.users."${username}";
in {
  home.file = {
    "${selfHM.home.homeDirectory}/dev/xodio/xod.code-workspace".text = builtins.toJSON {
      folders = [
        {
          name = "xod";
          path = "xod";
        }
        {
          name = "docs";
          path = "xod-docs";
        }
        {
          name = "backend";
          path = "services.xod.io";
        }
      ];
      settings = {};
      extensions = {
        recommendations = [
            "bibhasdn.unique-lines"
            "christian-kohler.path-intellisense"
            "codezombiech.gitignore"
            "CoenraadS.bracket-pair-colorizer"
            "DeepInThought.vscode-shell-snippets"
            "eamodio.gitlens"
            "EditorConfig.EditorConfig"
            "esbenp.prettier-vscode"
            "foxundermoon.shell-format"
            "GitHub.vscode-pull-request-github"
            "ms-kubernetes-tools.vscode-kubernetes-tools"
            "ms-vscode.PowerShell"
            "oderwat.indent-rainbow"
            "PeterJausovec.vscode-docker"
            "redhat.vscode-yaml"
            "wayou.vscode-todo-highlight"
            "xabikos.JavaScriptSnippets"
            "xabikos.ReactSnippets"
            "yzhang.markdown-all-in-one"
        ];
      };
    };
  };

  programs.vscode = {
    enable = true;
    userSettings = {
      "debug.inlineValues" = true;
      "docker.enableLinting" = true;
      "editor.fontFamily" = "'Hack Nerd Font','Droid Sans Mono', 'Courier New', monospace, 'Droid Sans Fallback'";
      "editor.fontLigatures" = true;
      "editor.minimap.enabled" = false;
      "editor.minimap.renderCharacters" = false;
      "editor.multiCursorModifier" = "alt";
      "editor.rulers" = [80 120];
      "editor.wordWrap" = "on";
      "explorer.confirmDelete" = false;
      "extensions.autoUpdate" = false;
      "files.autoSave" = "off";
      "flow.useNPMPackagedFlow" = true;
      "flow.useLSP" = true;
      "git.autofetch" = true;
      "githubPullRequests.hosts" = [
        {
          host = "https://github.com";
          username = "oauth";
          token = "system";
        }
      ];
      "gitlens.advanced.messages" = {
        suppressFileNotUnderSourceControlWarning = true;
        suppressShowKeyBindingsNotice = true;
        suppressUpdateNotice = true;
      };
      "gitlens.codeLens.authors.enabled" = false;
      "gitlens.codeLens.recentChange.enabled" = false;
      "gitlens.hovers.annotations.enabled" = false;
      "gitlens.keymap" = "chorded";
      "javascript.updateImportsOnFileMove.enabled" = "never";
      "javascript.validate.enable" = false;
      "prettier.trailingComma" = "es5";
      "tslint.packageManager" = "yarn";
      "typescript.check.tscVersion" = false;
      "typescript.disableAutomaticTypeAcquisition" = false;
      "update.channel" = "none";
      "vsicons.dontShowNewVersionMessage" = true;
      "window.titleBarStyle" = "custom";
      "window.zoomLevel" = 0;
      "workbench.colorTheme" = "Monokai";
      "workbench.startupEditor" = "newUntitledFile";
    };
  };
}
