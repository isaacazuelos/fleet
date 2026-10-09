{ pkgs, ... }:
{
  imports = [ ../common/home.nix ];

  home = {
    stateVersion = "25.11";
    username = "iaz";
    homeDirectory = "/home/iaz";

    file = {
      ".config/ghostty/themes/gotham".source = ../common/ghostty-theme-gotham;
      ".config/zed/themes/gotham.json".source = ../common/zed-theme-gotham.json;
      ".claude/statusline.sh".source = ../common/claude-statusline.sh;
    };

    packages = with pkgs; [
      vscode.fhs
      zed-editor-fhs
      github-desktop

      discord
      obsidian
      orca-slicer
      plex-desktop

      # system / GPU monitoring
      gotop
      radeontop
      rocmPackages.rocminfo
    ];
  };

  programs = {
    claude-code = {
      enable = true;
      package = pkgs.unstable.claude-code;
      settings = {
        model = "opus";
        effortLevel = "high";
        theme = "light-ansi";
        permissions.defaultMode = "plan";
        statusLine = {
          type = "command";
          command = "bash ~/.claude/statusline.sh";
        };
        enabledPlugins = {
          "rust-analyzer-lsp@claude-plugins-official" = true;
        };
      };
    };
    ghostty = {
      enable = true;
      package = pkgs.ghostty;
      enableFishIntegration = true;
      settings = {
        font-family = "Berkeley Mono";
        font-size = 12;
        window-padding-x = 4;
        window-padding-y = 2;
        window-height = 24;
        window-width = 80;
        window-save-state = "never";
        theme = "gotham";
      };
    };
    git = {
      signing.key = "~/.ssh/id_ed25519.pub";
    };
  };
}
