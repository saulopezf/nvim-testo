local dap = require "dap"
-- dap.set_log_level "TRACE" -- uncomment for logs

-- Keywords for TS/JS languages
local js_languages = {
    "typescript",
    "javascript",
    "typescriptreact",
    "javascriptreact",
    "vue",
}

-- Autoload .vscode/launch.json debugger options for js/ts files
if vim.fn.filereadable ".vscode/launch.json" then
    local dap_vscode = require "dap.ext.vscode"
    dap_vscode.load_launchjs(nil, {
        ["node2"] = js_languages,
        ["pwa-node"] = js_languages,
        ["chrome"] = js_languages,
        ["pwa-chrome"] = js_languages,
    })
end

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
    }
end
