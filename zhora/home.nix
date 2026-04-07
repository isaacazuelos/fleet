{
  # pkgs,
  ...
}: {
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
    git = {
      signing.key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIQq7CgkSKrrcjT9wsYRA0NlVawmv4/s5X5SROwN/ont";
      settings = {
        "gpg \"ssh\"".program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
      };
    };
  };
}
