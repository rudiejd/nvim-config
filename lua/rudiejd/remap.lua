vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("i", "<C-S>", function()
    vim.lsp.buf.signature_help()
end, { buffer = true })



-- yank to windows clipboard
vim.opt.clipboard = "unnamedplus"
if vim.fn.has('wsl') == 1 then
    vim.api.nvim_create_autocmd('TextYankPost', {
        group = vim.api.nvim_create_augroup('Yank', { clear = true }),
        callback = function()
            vim.fn.system('clip.exe', vim.fn.getreg('"'))
        end,
    })
end


-- toggle line break and word wrap
-- (l)ine (b)reak
vim.keymap.set('n', '<leader>lb', function ()
    if vim.o.linebreak then
        vim.o.linebreak = false
        vim.o.wrap = false
    else
        vim.o.linebreak = true
        vim.o.wrap = true
    end
end)

-- idk i think this might be better than jj 
-- since it's the same in visual and insert :)
vim.keymap.set("i", "<C-c>", "<Esc>")


-- Center the window (zz) when scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

--
