vim.api.nvim_set_hl(0, "VSCodeYank", {
  bg = "#e66159",
  fg = "#f5f5dc",
})

local yank_group = vim.api.nvim_create_augroup("vscode_like_yank", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = yank_group,
  callback = function()
    vim.highlight.on_yank({
      higroup = "VSCodeYank",
      timeout = 180,
    })
  end,
})

vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("terminal_buffer_defaults", { clear = true }),
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})
