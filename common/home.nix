{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      age
      alejandra
      bat
      git
      htop
      nix-your-shell
      ripgrep
      statix
      tmux
      tokei

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
        core.sshCommand = "ssh";
        gpg.format = "ssh";
      };
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      withRuby = false;    # needed for older stateVersion
      withPython3 = false; # needed for older stateVersion
      plugins = with pkgs.vimPlugins; [
        plenary-nvim
        telescope-nvim
        nvim-tree-lua
        (pkgs.vimUtils.buildVimPlugin {
          name = "neogotham";
          src = pkgs.fetchFromGitLab {
            owner = "shmerl";
            repo = "neogotham";
            rev = "ed392289071d8be72161fdae4ae13c53094bbd43";
            sha256 = "sha256-jnvj3K4rIsaVv01E4VB6ySZKKa/fXg2evkfH+OuEkSY=";
          };
        })
      ];
      initLua = builtins.readFile ./nvim/init.lua;
    };
    starship = {
      enable = true;
      enableFishIntegration = true;
      enableInteractive = true;
      settings = {
        add_newline = false;
       	package = {
                  format = "[$symbol]($style)";
       	};
       	rust = {
       	  format = "[$symbol]($style)";
       	};
       	nix_shell = {
       	  format = "[$symbol]($style) ";
       	};
      };
    };
  };
}
