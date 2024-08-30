
-- map ⌘X/⌘C/⌘V to cut/copy/paste
vim.keymap.set({'i'}, '<D-c>', '"+y')
vim.keymap.set({'i'}, '<D-x>', '"+x')
vim.keymap.set({'i'}, '<D-v>', '"+gP')

-- Relevant doco:
--  * https://github.com/macvim-dev/macvim/blob/master/runtime/macmap.vim#L48-L55
--  * https://neovim.io/doc/user/lua-guide.html#_creating-mappings
--  * https://neovim.io/doc/user/provider.html#quoteplus
--  * https://neovim.io/doc/user/api.html#nvim_paste()
--

print("macOS keybindings loaded, probably 🤷")

