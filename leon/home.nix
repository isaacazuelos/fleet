{ pkgs, ... }:
{
  imports = [ ../common/home.nix ];

  home = {
    stateVersion = "25.11";
    username = "iaz";
    homeDirectory = "/home/iaz";
  };

  programs = {
    claude-code = {
      enable = true;
      package = pkgs.unstable.claude-code;
    };
    git = { 
      signing.key = "~/.ssh/id_ed25519.pub";
    };
  };
}
