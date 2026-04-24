{pkgs, ...}: {
  imports = [../common/home.nix];

  home = {
    stateVersion = "25.11";
    username = "iaz";
    homeDirectory = "/Users/iaz";

    sessionVariables = {
      NH_FLAKE = "/Users/iaz/src/fleet";
    };

    file = {
      ".hushlogin".text = "";
      ".config/ghostty/themes/gotham".source = ../common/ghostty-theme-gotham;
      ".config/zed/themes/gotham.json".source = ../common/zed-theme-gotham.json;
    };
  };

  programs = {
    claude-code = {
      enable = true;
      package = pkgs.unstable.claude-code;
    };
    fish = {
      enable = true;
      shellInit = builtins.readFile ./init.fish;
    };
    ghostty = {
      enable = true;
      package = pkgs.ghostty-bin;
      enableFishIntegration = true;
      settings = {
        font-family = "Berkeley Mono";
        font-size = 14;
        command = "/opt/homebrew/bin/fish --login --interactive";
        window-padding-x = 4;
        window-padding-y = 2;
        window-height = 24;
        window-width = 80;
        window-save-state = "never";
        window-step-resize = true;
        background-opacity = 0.90;
        background-blur = "macos-glass-regular";
        macos-icon = "glass";
        theme = "gotham";
      };
    };
    git = {
      signing.key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIQq7CgkSKrrcjT9wsYRA0NlVawmv4/s5X5SROwN/ont";
    };
  };
}
