return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = function()
      return {
        {
          "<leader>e",
          function()
            require("neo-tree.command").execute({
              position = "float",
              toggle = true,
              reveal = true,
            })
          end,
          desc = "Explorer (float)",
        },
      }
    end,
    opts = {
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = false,
      default_component_configs = {
        indent = { with_markers = false, indent_size = 1, padding = 0 },
      },
      filesystem = {
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        filtered_items = {
          hide_dotfiles = true,
          hide_gitignored = true,
          hide_by_name = { "node_modules", ".git" },
        },
      },
    },
  },
}
