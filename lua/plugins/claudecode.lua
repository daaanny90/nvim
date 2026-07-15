-- Claude Code integration via WebSocket/MCP (reuses the Claude Code subscription).
-- provider = "none": no Neovim terminal split is created. Run `claude` in your own
-- tmux pane and connect with `/ide`, keeping ctrl+h/j/k/l pane navigation intact.
return {
  "coder/claudecode.nvim",
  event = "VeryLazy", -- load at startup so auto_start fires and the lock file is written
  opts = {
    auto_start = true,
    track_selection = true,
    terminal = { provider = "none" },
    diff_opts = { layout = "horizontal", open_in_new_tab = false },
  },
  keys = {
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Claude: send selection" },
    { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Claude: add buffer" },
    { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Claude: accept diff" },
    { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Claude: deny diff" },
  },
}
