return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts = opts or {}
      opts.formatters_by_ft = vim.tbl_extend("force", opts.formatters_by_ft or {}, {
        python = { "ruff_format", "black" },
        javascript = { "prettierd", "prettier" },
        typescript = { "prettierd", "prettier" },
        javascriptreact = { "prettierd", "prettier" },
        typescriptreact = { "prettierd", "prettier" },
        json = { "prettierd", "prettier" },
        css = { "prettierd", "prettier" },
        html = { "prettierd", "prettier" },
        go = { "gofumpt", "goimports" },
        rust = { "rustfmt" },
      })
      return opts
    end,
  },

  { "sindrets/diffview.nvim", cmd = { "DiffviewOpen", "DiffviewFileHistory" } },
  { "simrat39/symbols-outline.nvim", cmd = "SymbolsOutline", opts = {} },
  { "stevearc/overseer.nvim", cmd = { "OverseerRun", "OverseerToggle" }, opts = {} },
  { "rest-nvim/rest.nvim", ft = { "http" }, opts = { jump_to_request = true } },

  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts = opts or {}
      opts.ensure_installed = vim.tbl_extend("force", opts.ensure_installed or {}, {
        "jsonls",
        "yamlls",
        "bashls",
      })
      return opts
    end,
  },
}
