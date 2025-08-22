return {
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts = opts or {}
      opts.ensure_installed = vim.tbl_extend("force", opts.ensure_installed or {}, {
        "pyright",
        "ruff",
      })
      return opts
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts = opts or {}
      opts.ensure_installed = vim.tbl_extend("force", opts.ensure_installed or {}, { "python" })
      return opts
    end,
  },
}
