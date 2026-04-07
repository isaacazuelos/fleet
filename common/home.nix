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
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      extraLuaConfig = builtins.readFile ./nvim/init.lua;
    };
  };
}
