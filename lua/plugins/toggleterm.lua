return {
  "akinsho/toggleterm.nvim",
  version = "*",
  opts = {
    size = function(term)
      if term.direction == "horizontal" then
        return 15
      elseif term.direction == "vertical" then
        return vim.o.columns * 0.4
      end
    end,
    open_mapping = [[<C-\>]],
    hide_numbers = true,
    shade_terminals = true,
    shading_factor = 2,
    start_in_insert = true,
    insert_mappings = true,
    terminal_mappings = true,
    persist_size = true,
    persist_mode = true,
    direction = "float",
    close_on_exit = false, -- Keep terminal open when process exits
    shell = vim.o.shell,
    auto_scroll = true,
    float_opts = {
      border = "curved",
      width = math.floor(vim.o.columns * 0.9),
      height = math.floor(vim.o.lines * 0.9),
      winblend = 0,
    },
  },
  config = function(_, opts)
    require("toggleterm").setup(opts)

    -- Custom terminal instances for different purposes
    local Terminal = require("toggleterm.terminal").Terminal

    -- Function to create a new floating terminal
    local function create_float_term(name, cmd)
      return Terminal:new({
        cmd = cmd,
        display_name = name,
        direction = "float",
        float_opts = {
          border = "curved",
          width = math.floor(vim.o.columns * 0.9),
          height = math.floor(vim.o.lines * 0.9),
        },
        close_on_exit = false,
        on_open = function(term)
          vim.cmd("startinsert!")
          -- Keymaps when terminal is open
          vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], { buffer = term.bufnr, silent = true })
          vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], { buffer = term.bufnr, silent = true })
          vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], { buffer = term.bufnr, silent = true })
          vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], { buffer = term.bufnr, silent = true })
          vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], { buffer = term.bufnr, silent = true })
        end,
      })
    end

    -- Store terminals globally
    _G.my_terminals = _G.my_terminals or {}

    -- Function to toggle or create a numbered terminal
    local function toggle_terminal(num)
      if not _G.my_terminals[num] then
        _G.my_terminals[num] = create_float_term("Terminal " .. num, nil)
      end
      _G.my_terminals[num]:toggle()
    end

    -- Keymaps for multiple terminal instances
    vim.keymap.set({ "n", "t" }, "<C-\\>", function()
      toggle_terminal(1)
    end, { desc = "Toggle terminal 1" })

    vim.keymap.set({ "n", "t" }, "<leader>t1", function()
      toggle_terminal(1)
    end, { desc = "[T]erminal 1" })

    vim.keymap.set({ "n", "t" }, "<leader>t2", function()
      toggle_terminal(2)
    end, { desc = "[T]erminal 2" })

    vim.keymap.set({ "n", "t" }, "<leader>t3", function()
      toggle_terminal(3)
    end, { desc = "[T]erminal 3" })

    vim.keymap.set({ "n", "t" }, "<leader>t4", function()
      toggle_terminal(4)
    end, { desc = "[T]erminal 4" })

    -- Horizontal and vertical split terminals
    vim.keymap.set("n", "<leader>th", "<cmd>ToggleTerm size=15 direction=horizontal<cr>", { desc = "[T]erminal [H]orizontal" })
    vim.keymap.set("n", "<leader>tv", "<cmd>ToggleTerm size=80 direction=vertical<cr>", { desc = "[T]erminal [V]ertical" })

    -- Send selected text to terminal
    vim.keymap.set("v", "<leader>ts", function()
      require("toggleterm").send_lines_to_terminal("visual_selection", true, { args = vim.v.count })
    end, { desc = "[T]erminal [S]end selection" })
  end,
}






