local dap = require "dap"
-- dap.set_log_level "TRACE" -- uncomment for logs

vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, bg = "#31353f" })

vim.fn.sign_define("DapBreakpoint", { text = "🔴" })
vim.fn.sign_define("DapBreakpointCondition", { text = "🔵" })
vim.fn.sign_define("DapBreakpointRejected", { text = "⚫" })
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
end

---------------------------------- [[ C/C++ CONFIG ]] ----------------------------------

dap.configurations.cpp = {
    {
        name = "Launch file",
        type = "codelldb",
        request = "launch",
        program = function()
            -- Create a debugger executable with clang++ for codelldb
            local path_to_src = vim.fn.input("Path to source: ", vim.fn.getcwd() .. "/", "file")
            local path_to_debug_exe = vim.fn.getcwd() .. "/debug.exe"
            local cmd = "clang++ --debug " .. path_to_src .. " -o " .. path_to_debug_exe
            local output = os.execute(cmd)
            if output ~= 0 then
                error("\nError compiling debugger executable. CMD:\n" .. cmd)
            end

            -- Return the executable that codelldb needs for debug
            return path_to_debug_exe
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
    },
}
