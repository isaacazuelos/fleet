{ pkgs, ... }: {
  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      extraLuaConfig = ''
        vim.opt.number = true;
	vim.opt.shortmess:append("I");
      '';
    };
  };
}
