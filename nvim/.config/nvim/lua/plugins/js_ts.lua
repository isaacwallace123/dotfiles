return {
  {
    "pmizio/typescript-tools.nvim",
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {},
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        eslint = {},
        tailwindcss = {},
        emmet_ls = {
          filetypes = { "html", "css", "sass", "scss", "javascriptreact", "typescriptreact" },
        },
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts = opts or {}
      opts.ensure_installed = vim.tbl_extend("force", opts.ensure_installed or {}, {
        "javascript",
        "typescript",
        "tsx",
        "css",
        "html",
        "json",
      })
      return opts
    end,
  },
}
