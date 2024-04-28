require "nvchad.mappings"

local map = vim.keymap.set
local delmap = vim.keymap.del

map("n", ";", ":", { desc = "CMD enter command mode" })
-- map("n", "<leader>d", { desc = "Debugger options" })

-- Debugger (DAP)
local dap = require "dap"
map("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP Set breakpoint" })
map("n", "<leader>dc", dap.continue, { desc = "DAP Run" })
map("n", "<leader>dO", dap.step_out, { desc = "DAP Step out" })
map("n", "<leader>do", dap.step_over, { desc = "DAP Step over" })
local dapui = require "dapui"
map("n", "<leader>dt", dapui.toggle, { desc = "DAP UI Toggle" })
