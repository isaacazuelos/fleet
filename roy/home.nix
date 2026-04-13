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
    };

    packages = with pkgs; [
      vscode.fhs
      zed-editor-fhs
      github-desktop

      discord
      obsidian
      orca-slicer
      plex-desktop
    ];
  };

  programs = {
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
