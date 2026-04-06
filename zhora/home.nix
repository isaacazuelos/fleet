{ pkgs, ... }: {
  imports = [ ../common/home.nix ];

  home = {
    stateVersion = "25.11";
    username = "iaz";
    homeDirectory = "/Users/iaz";


    sessionVariables = {
      NH_FLAKE = "/Users/iaz/src/fleet";
    };
  };
}
