{pkgs, ...}: {
  imports = [../common/home.nix];

  home = {
    stateVersion = "25.11";
    username = "iaz";
    homeDirectory = "/Users/iaz";

    sessionVariables = {
      NH_FLAKE = "/Users/iaz/src/fleet";
    };
  };

  programs = {
    claude-code = {
      enable = true;
    };
    fish = {
      enable = true;
      shellInit = ''
        set -gx PATH $HOME/.nix-profile/bin /nix/var/nix/profiles/default/bin /run/current-system/sw/bin $PATH
      '';
    };
    ghostty = {
      enable = true;
      package = pkgs.ghostty-bin;
      enableFishIntegration = true;
      settings = {
        font-family = "Berkeley Mono";
        font-size = 14;
        command = "/opt/homebrew/bin/fish --login --interactive";
	window-padding-x = 16;
	window-padding-y = 16;
	background-opacity = 0.75;
	background-blur = "macos-glass-regular";
      };
    };
    git = {
      signing.key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIQq7CgkSKrrcjT9wsYRA0NlVawmv4/s5X5SROwN/ont";
      settings = {
        "gpg \"ssh\"".program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
      };
    };
  };
}
