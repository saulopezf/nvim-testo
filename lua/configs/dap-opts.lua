local dap = require "dap"
-- dap.set_log_level "TRACE" -- uncomment for logs

vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, bg = "#31353f" })

vim.fn.sign_define("DapBreakpoint", { text = "B" })
vim.fn.sign_define("DapBreakpointCondition", { text = "C" })
vim.fn.sign_define("DapBreakpointRejected", { text = "" })
vim.fn.sign_define("DapLogPoint", { text = "" })
vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" })

---------------------------------- [[ JS/TS CONFIG ]] ----------------------------------

-- Keywords for js/ts languages
local js_languages = {
    "typescript",
    "javascript",
    "typescriptreact",
    "javascriptreact",
    "vue",
}

-- Debbuger options for js/ts files
for _, language in ipairs(js_languages) do
    dap.configurations[language] = {
        -- Debug single nodejs files
        {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
        },
        -- Debug nodejs processes (make sure to add --inspect when you run the process)
        {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require("dap.utils").pick_process,
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
        },
        -- Debug web applications (client side)
        {
            type = "pwa-chrome",
            request = "launch",
            name = "Launch & Debug Chrome",
            url = function()
                local co = coroutine.running()
                return coroutine.create(function()
                    vim.ui.input({
                        prompt = "Enter URL: ",
                        default = "http://localhost:3000",
                    }, function(url)
                        if url == nil or url == "" then
                            return
                        else
                            coroutine.resume(co, url)
                        end
                    end)
                end)
            end,
            webRoot = vim.fn.getcwd(),
            protocol = "inspector",
            sourceMaps = true,
            userDataDir = false,
        },
        -- Separator
        {
            name = "----- ↓ launch.json configs ↓ -----",
            type = "",
            request = "launch",
        },
    }

    -- Autoload .vscode/launch.json debugger options for js/ts files
    if vim.fn.filereadable ".vscode/launch.json" then
        local dap_vscode = require "dap.ext.vscode"
        dap_vscode.load_launchjs(nil, {
            ["pwa-node"] = js_languages,
            ["chrome"] = js_languages,
            ["pwa-chrome"] = js_languages,
        })
    end
end
