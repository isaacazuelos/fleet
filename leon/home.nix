{ pkgs, ... }:
{
  imports = [ ../common/home.nix ];

  home = {
    stateVersion = "25.11";
    username = "iaz";
    homeDirectory = "/home/iaz";
  };

  programs = {
    git = { 
      signing.key = "~/.ssh/id_ed25519.pub";
    };
  };
}
