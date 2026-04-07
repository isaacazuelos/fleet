{ pkgs, ... }:
{

  home.packages = with pkgs; [
    bat
    fzf
    ripgrep
    tmux

    # language servers
    lua-language-server  # for neovim
    nixd
    nil                      # zed likes having both?
  ];

  programs = {
    git = {
      enable = true;
      settings = {
        user = {
          name = "Isaac Azuelos";
          email = "isaac@azuelos.ca";
        };
        init.defaultBranch = "main";
        commit.gpgsign = true;
        gpg.format = "ssh";
      };
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      extraLuaConfig = builtins.readFile ./nvim/init.lua;
    };
  };
}
