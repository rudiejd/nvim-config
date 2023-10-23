vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("i", "<C-S>", function()
    vim.lsp.buf.signature_help()
end, { buffer = true })


vim.opt.clipboard = "unnamedplus"
if vim.fn.has('wsl') == 1 then
    vim.api.nvim_create_autocmd('TextYankPost', {
        group = vim.api.nvim_create_augroup('Yank', { clear = true }),
        callback = function()
            vim.fn.system('clip.exe', vim.fn.getreg('"'))
        end,
    })
end
