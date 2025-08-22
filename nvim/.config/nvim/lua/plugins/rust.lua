return {
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    ft = { "rust" },
    init = function()
      vim.g.rustaceanvim = {
        dap = { adapter = "codelldb" },
      }
    end,
  },
  {
    "Saecki/crates.nvim",
    ft = { "rust", "toml" },
    config = function()
      require("crates").setup({ completion = { cmp = true } })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts = opts or {}
      opts.ensure_installed = vim.tbl_extend("force", opts.ensure_installed or {}, { "rust", "toml" })
      return opts
    end,
  },
}
