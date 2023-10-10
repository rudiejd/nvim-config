vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("i", "<C-S>", function ()
    vim.lsp.buf.signature_help()
end, {buffer = true})
