-- Formatting
return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local conform = require "conform"

        conform.setup {
            formatters_by_ft = {
                lua = { "stylua" },
                javascript = { "prettier" },
                typescript = { "prettier" },
                css = { "prettier" },
                html = { "prettier" },
            },

            format_on_save = {
                lsp_fallback = true,
                async = false,
                timeout_ms = 500,
            },
        }
    end,
}
