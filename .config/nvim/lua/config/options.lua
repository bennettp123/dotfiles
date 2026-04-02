-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

-- mac ⌘C/⌘V support is enabled by disabling mouse support, and using the
-- system clipboard :P
vim.opt.mouse = ""
vim.opt.clipboard = ""

-- copilot needs node 20+
vim.g.copilot_node_command = "~/.nodenv/versions/24/bin/node"

-- disable animation in folke/snacks.nvim
vim.g.snacks_animate = false
