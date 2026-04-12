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

        # HACK: nix-your-shell is only ad-hoc signed and gets killed by macOS.
        # It's not on Homebrew either, so we can't easily get a signed build.
        # Instead, we do roughly what `nix-your-shell fish | source` does, just
        # a little worse.
        function nix
            if test (count $argv) -gt 0
                switch $argv[1]
                case develop shell run
                    command nix $argv --command /opt/homebrew/bin/fish
                case '*'
                    command nix $argv
                end
            else
                command nix $argv
            end
        end
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
