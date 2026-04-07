-- Neovim Config

vim.opt.number = true;
vim.opt.shortmess:append("I");


vim.lsp.start({
    name = "lua_ls",
    cmd = { "lua-language-server" },
    filetaypes = { "lua" },
})

vim.lsp.start({
    name = "nixd",
    cmd = { "nixd" },
    filetaypes = { "nix" },
})
