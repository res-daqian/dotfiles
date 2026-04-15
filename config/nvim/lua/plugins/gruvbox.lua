return {
  "ellisonleao/gruvbox.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    terminal_colors = true,
    transparent_mode = false,
  },
  config = function(_, opts)
    vim.o.background = "dark"
    require("gruvbox").setup(opts)
    vim.cmd.colorscheme("gruvbox")
  end,
}
