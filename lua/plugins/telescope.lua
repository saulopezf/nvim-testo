-- Telescope plugin is loaded by default in NvChad
-- Install dependencies that extends Telescope here
return {
    {
        "nvim-telescope/telescope-live-grep-args.nvim",
        version = "^1.0.0",
        config = function()
            require("telescope").load_extension "live_grep_args"
        end,
    },
}
