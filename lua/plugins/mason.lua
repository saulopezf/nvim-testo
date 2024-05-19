return {
    "williamboman/mason.nvim",
    opts = {
        ensure_installed = {
            "lua-language-server", -- lua lsp
            "typescript-language-server", -- js/ts lsp
            "stylua", -- lua formatter
            "html-lsp", -- html lsp
            "css-lsp", -- css lsp
            "prettier", -- js/ts formatter
            "eslint_d", -- js/ts cli linter
            "clangd", -- c/c++ lsp & formatter
            "codelldb", -- c/c++ DAP
        },
    },
}
