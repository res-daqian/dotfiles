local function jump(opts)
  return function()
    require("flash").jump(opts or {})
  end
end

return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    modes = {
      char = {
        jump_labels = true,
      },
      search = {
        enabled = true,
      },
    },
    search = {
      multi_window = false,
    },
  },
  keys = {
    {
      "<leader><leader>s",
      jump(),
      mode = { "n", "x", "o" },
      desc = "Flash jump",
    },
    {
      "<leader><leader>w",
      jump({
        pattern = [[\<]],
        search = {
          forward = true,
          mode = "search",
          multi_window = false,
          wrap = false,
        },
      }),
      mode = { "n", "x", "o" },
      desc = "Flash word forward",
    },
    {
      "<leader><leader>b",
      jump({
        pattern = [[\<]],
        search = {
          forward = false,
          mode = "search",
          multi_window = false,
          wrap = false,
        },
      }),
      mode = { "n", "x", "o" },
      desc = "Flash word backward",
    },
    {
      "<leader><leader>j",
      jump({
        label = {
          after = { 0, 0 },
        },
        pattern = "^",
        search = {
          forward = true,
          max_length = 0,
          mode = "search",
          multi_window = false,
          wrap = false,
        },
      }),
      mode = { "n", "x", "o" },
      desc = "Flash line forward",
    },
    {
      "<leader><leader>k",
      jump({
        label = {
          after = { 0, 0 },
        },
        pattern = "^",
        search = {
          forward = false,
          max_length = 0,
          mode = "search",
          multi_window = false,
          wrap = false,
        },
      }),
      mode = { "n", "x", "o" },
      desc = "Flash line backward",
    },
  },
}
