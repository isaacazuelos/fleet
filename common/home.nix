{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      age
      alejandra
      bat
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
    fish = {
      enable = true;
      shellInit = builtins.readFile ./init.fish;
    };
    fzf = {
      enable = true;
      enableFishIntegration = true;
    };
    git = {
      enable = true;
      ignores = [ ".DS_Store" ];
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
      plugins = with pkgs.vimPlugins; [
        plenary-nvim
        telescope-nvim
        nvim-tree-lua
        (pkgs.vimUtils.buildVimPlugin {
          name = "neogotham";
          src = pkgs.fetchFromGitLab {
            owner = "shmerl";
            repo = "neogotham";
            rev = "HEAD";
            sha256 = "sha256-5hCXNCgcZDZDTTPHc/zZdBM3P6ZIv2wlVkVXNWlQ/yM=";
          };
        })
      ];
      extraLuaConfig = builtins.readFile ./nvim/init.lua;
    };
    starship = {
      enable = true;
      enableFishIntegration = true;
      enableInteractive = true;
      settings = {
        add_newline = false;
      };
    };
  };
}
