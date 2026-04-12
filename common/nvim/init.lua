-- Neovim Config

vim.opt.number = true
vim.cmd.colorscheme("neogotham")
vim.opt.shortmess:append("I");

-- Fuzzy file finder (Ctrl-P)
require('telescope').setup{}
vim.keymap.set('n', '<C-p>', require('telescope.builtin').find_files)

-- Sidebar file tree (Ctrl-B to toggle, like VSCode/Zed)
require('nvim-tree').setup({
    renderer = {
        icons = {
            show = { file = false, folder = false, folder_arrow = false, git = false },
        },
    },
})
vim.keymap.set('n', '<C-b>', ':NvimTreeToggle<CR>', { silent = true })

vim.lsp.start({
    name = "lua_ls",
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
})

vim.lsp.start({
    name = "nixd",
    cmd = { "nixd" },
    filetypes = { "nix" },
})
