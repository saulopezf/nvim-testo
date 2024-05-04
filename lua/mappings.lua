require "nvchad.mappings"

local map = vim.keymap.set
local delmap = vim.keymap.del

map("n", ";", ":", { desc = "CMD enter command mode" })
-- map("n", "<leader>d", { desc = "Debugger options" })

-- Telescope
map(
    "n",
    "<leader>fq",
    ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",
    { desc = "telescope live grep args" }
)
map("n", "<leader>fr", require("telescope.builtin").resume, {
    noremap = true,
    silent = true,
    desc = "telescope resume last search",
})

-- Git (Gitsigns already installed from NvChad)
map("n", "<leader>gl", ":Gitsigns toggle_current_line_blame<CR>", { desc = "Git toggle line blame" })

-- Debugger (DAP)
local dap = require "dap"
map("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP Set breakpoint" })
map("n", "<leader>dc", dap.continue, { desc = "DAP Run" })
map("n", "<leader>dO", dap.step_out, { desc = "DAP Step out" })
map("n", "<leader>do", dap.step_over, { desc = "DAP Step over" })
local dapui = require "dapui"
map("n", "<leader>dt", dapui.toggle, { desc = "DAP UI Toggle" })
map("n", "<leader>dk", dapui.eval, { desc = "DAP eval hover" })
