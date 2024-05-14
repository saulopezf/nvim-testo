-- Debugging in nvim
-- Every language has his own debugger, so DAP (Debug Adapter Protocol) wrap
-- nvim text editor with the specific debugger.
-- :help dap.txt for more info
--
-- For debug with an UI we have nvim-dap-ui

-- Directory separator variable to know if we are in Windows
local is_windows_hell = package.config:sub(1, 1) == "\\"

return {
    {
        "mfussenegger/nvim-dap",
        lazy = true,
        config = function()
            require "configs.dap-opts"
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

            --------------------------DEFAULT ADAPTER CONFIG-------------------------------
            {
                "jay-babu/mason-nvim-dap.nvim",
                config = function()
                    -- This wraps the DAPs installed via Mason automatically
                    local mason_nvim_dap = require "mason-nvim-dap"
                    mason_nvim_dap.setup {
                        handlers = {
                            -- This first function will load default configurations for Mason DAPs installed
                            function(config)
                                mason_nvim_dap.default_setup(config)
                            end,
                            -- Then we can configurate adapters manually
                        },
                    }
                end,
            },
            --------------------------DEFAULT ADAPTER CONFIG-------------------------------

            ---------------------------JS/TS ADAPTER CONFIG--------------------------------
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
                build = is_windows_hell and "powershell ./install.ps1" or "sh ./install.sh",
            },
            ---------------------------JS/TS ADAPTER CONFIG--------------------------------
        },
    },
}
