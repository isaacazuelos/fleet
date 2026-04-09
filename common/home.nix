{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      age
      alejandra
      bat
      fzf
      git
      nix-your-shell
      ripgrep
      statix
      tmux

      # language servers
      lua-language-server # for neovim
      nixd
      nil # zed likes having both?
    ];
  };

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
        ignores = [ ".DS_Store" ];
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
