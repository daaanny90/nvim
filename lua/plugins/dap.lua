-- debug adapter protocol - to run debuggers in neovim
return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "theHamsta/nvim-dap-virtual-text",
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    dapui.setup()
    require("nvim-dap-virtual-text").setup({ commented = true })

    -- breakpoint signs: colored nerd-font glyphs instead of the default
    -- low-contrast 'B'; re-applied on ColorScheme (themes clear custom hl)
    local function dap_sign_colors()
      vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#ff3b30" })
      vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = "#ff9500" })
      vim.api.nvim_set_hl(0, "DapBreakpointRejected", { fg = "#8e8e93" })
      vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#61afef" })
      vim.api.nvim_set_hl(0, "DapStopped", { fg = "#ffcc00" })
    end
    dap_sign_colors()
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("dap-sign-colors", { clear = true }),
      callback = dap_sign_colors,
    })

    -- glyphs as \u{} escapes: nerd-font PUA chars don't survive some editors
    vim.fn.sign_define("DapBreakpoint", { text = "\u{f111}", texthl = "DapBreakpoint" })
    vim.fn.sign_define("DapBreakpointCondition", { text = "\u{f192}", texthl = "DapBreakpointCondition" })
    vim.fn.sign_define("DapBreakpointRejected", { text = "\u{f05e}", texthl = "DapBreakpointRejected" })
    vim.fn.sign_define("DapLogPoint", { text = "\u{f05a}", texthl = "DapLogPoint" })
    vim.fn.sign_define("DapStopped", { text = "\u{f04b}", texthl = "DapStopped", linehl = "Visual" })

    -- js-debug (vscode-js-debug, installed via mason): one adapter serves both
    -- node processes (pwa-node) and browser debugging (pwa-chrome)
    for _, adapter in ipairs({ "pwa-node", "pwa-chrome" }) do
      dap.adapters[adapter] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = vim.fn.stdpath("data") .. "/mason/bin/js-debug-adapter",
          args = { "${port}" },
        },
      }
    end

    -- js-debug looks for Chrome/Chromium and won't find it on this system:
    -- only Brave is installed (Chromium-based, works fine over CDP)
    local browser = "/Applications/Brave Browser.app/Contents/MacOS/Brave Browser"

    -- generic JS/TS/Vue configurations; project files can prepend their own
    -- (see lua/projects/herole.lua for the herole Chrome launch on :8081)
    for _, ft in ipairs({ "javascript", "typescript", "vue" }) do
      dap.configurations[ft] = {
        {
          type = "pwa-chrome",
          request = "launch",
          name = "Chrome: Vite dev server (localhost:5173)",
          url = "http://localhost:5173",
          webRoot = "${workspaceFolder}",
          sourceMaps = true,
          runtimeExecutable = browser,
        },
        {
          type = "pwa-node",
          request = "launch",
          name = "Node: run current file",
          program = "${file}",
          cwd = "${workspaceFolder}",
          sourceMaps = true,
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "Node: attach to process (--inspect)",
          processId = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
          sourceMaps = true,
        },
      }
    end

    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end

    vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
    vim.keymap.set("n", "<leader>dB", function()
      dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, { desc = "Conditional Breakpoint" })
    vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue" })
    vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Step Over" })
    vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "Step Out" })
    vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step Into" })
    vim.keymap.set("n", "<leader>dt", dap.terminate, { desc = "Terminate" })
    vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "Run Last" })
    vim.keymap.set("n", "<leader>du", function()
      dapui.toggle()
    end, { desc = "Toggle DAP UI" })
    vim.keymap.set({ "n", "v" }, "<leader>de", function()
      dapui.eval()
    end, { desc = "Eval under cursor/selection" })
  end,
}
