vim.api.nvim_create_user_command("MasonInstallRequired", function()
    require("nvchad.mason").install_all(require "configs.mason-required")
end, {})
