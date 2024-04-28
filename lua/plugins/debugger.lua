-- Debugging in nvim
-- Every language has his own debugger, so DAP (Debug Adapter Protocol) wrap
-- nvim text editor with the specific debugger.
-- :help dap.txt for more info
--
-- For debug with an UI we have nvim-dap-ui

-- Directory separator variable to know if we are in Windows
local is_windows_hell = package.config:sub(1, 1) == "\\"

-- Keywords for TS/JS languages
local js_languages = {
    "typescript",
    "javascript",
    "typescriptreact",
    "javascriptreact",
    "vue",
}

return {
    {
        "mfussenegger/nvim-dap",
        lazy = true,
        config = function()
            if vim.fn.filereadable ".vscode/launch.json" then
                local dap_vscode = require "dap.ext.vscode"
                dap_vscode.load_launchjs(nil, {
                    ["node"] = js_languages,
                    ["pwa-node"] = js_languages,
                    ["chrome"] = js_languages,
                    ["pwa-chrome"] = js_languages,
                })
            end
        end,
        dependencies = {
            ----------------------------------DAP UI---------------------------------------
            {
                "rcarriga/nvim-dap-ui",
                dependencies = { "nvim-neotest/nvim-nio" },
                config = function()
                    local dap = require "dap"
                    local dapui = require "dapui"

                    dapui.setup()
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
                end,
            },
            ----------------------------------DAP UI---------------------------------------

            --------------------------------DAP JS/TS--------------------------------------
            -- DAP for Javascript/Typescript
            {
                "microsoft/vscode-js-debug",
                build = is_windows_hell
                        and "npm install --legacy-peer-deps --no-save && npx gulp vsDebugServerBundle && (if exist out rmdir out /s /q) && mkdir out && xcopy dist out /s /e /h /y"
                    or "npm install --legacy-peer-deps --no-save && npx gulp vsDebugServerBundle && rm -rf out && mv dist out",
                version = "1.*",
            },

            -- Wrap nvim-dap with vscode-js-debug
            {
                "mxsdev/nvim-dap-vscode-js",
                config = function()
                    require("dap-vscode-js").setup {
                        debugger_path = vim.fn.resolve(vim.fn.stdpath "data" .. "/lazy/vscode-js-debug"),
                        adapters = {
                            "chrome",
                            "pwa-node",
                            "pwa-chrome",
                            "pwa-msedge",
                            "pwa-extensionHost",
                            "node-terminal",
                        },
                    }
                end,
            },

            -- JSON5 to read .vscode/launch.json file
            {
                "Joakker/lua-json5",
                build = is_windows_hell and "powershell ./install.ps1" or "./install.sh",
            },
            --------------------------------DAP JS/TS--------------------------------------

            ----------------------------------DAP GO---------------------------------------
            {
                "leoluz/nvim-dap-go",
                config = function()
                    require("dap-go").setup()
                end,
            },
            ----------------------------------DAP GO---------------------------------------
        },
    },
}
