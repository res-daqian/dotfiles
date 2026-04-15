local map = vim.keymap.set

local replacements = {
  ["true"] = "false",
  ["false"] = "true",
  ["TRUE"] = "FALSE",
  ["FALSE"] = "TRUE",
  ["True"] = "False",
  ["False"] = "True",
  ["yes"] = "no",
  ["no"] = "yes",
  ["YES"] = "NO",
  ["NO"] = "YES",
  ["on"] = "off",
  ["off"] = "on",
  ["ON"] = "OFF",
  ["OFF"] = "ON",
}

local function is_word_char(char)
  return char ~= "" and char:match("[%w_]") ~= nil
end

local function current_word_region()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()

  if line == "" then
    return nil
  end

  local pos = math.min(col + 1, #line)
  if pos < 1 or not is_word_char(line:sub(pos, pos)) then
    return nil
  end

  local start_idx = pos
  while start_idx > 1 and is_word_char(line:sub(start_idx - 1, start_idx - 1)) do
    start_idx = start_idx - 1
  end

  local end_idx = pos
  while end_idx < #line and is_word_char(line:sub(end_idx + 1, end_idx + 1)) do
    end_idx = end_idx + 1
  end

  return row - 1, start_idx, end_idx
end

local function toggle_boolean_under_cursor()
  local row, start_idx, end_idx = current_word_region()
  if row == nil then
    vim.notify("No boolean-like word under cursor", vim.log.levels.INFO)
    return
  end

  local line = vim.api.nvim_get_current_line()
  local word = line:sub(start_idx, end_idx)
  local replacement = replacements[word]

  if replacement == nil then
    vim.notify("No boolean-like word under cursor", vim.log.levels.INFO)
    return
  end

  vim.api.nvim_buf_set_text(0, row, start_idx - 1, row, end_idx, { replacement })
end

local function focus_or_open_terminal()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].buftype == "terminal" then
      vim.api.nvim_set_current_win(win)
      vim.cmd("startinsert")
      return
    end
  end

  vim.cmd("botright 12split")
  vim.cmd("terminal")
  vim.cmd("startinsert")
end

map("i", "jj", "<Esc>", { desc = "Exit insert mode with jj" })

map("n", "<C-n>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight", silent = true })
map("n", "H", "^", { desc = "Jump to first non-blank character" })
map("n", "L", "g_", { desc = "Jump to last non-blank character" })
map("n", "J", "5j", { desc = "Move down 5 lines" })
map("n", "K", "5k", { desc = "Move up 5 lines" })

map("n", "<leader>c", toggle_boolean_under_cursor, { desc = "Toggle boolean under cursor" })
map("n", "<leader>t", focus_or_open_terminal, { desc = "Focus or open a terminal split" })
map("n", "<Tab>l", "<cmd>tabnext<CR>", { desc = "Next tab" })
map("n", "<Tab>h", "<cmd>tabprevious<CR>", { desc = "Previous tab" })
