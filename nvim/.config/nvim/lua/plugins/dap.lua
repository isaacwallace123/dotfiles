return {
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "mfussenegger/nvim-dap" },
    opts = {
      automatic_installation = true,
      ensure_installed = {
        "python",       -- debugpy
        "delve",        -- Go
        "js", "chrome", -- JS/TS
        "codelldb",     -- Rust
      },
    },
  },
  { "leoluz/nvim-dap-go", ft = "go", config = function() require("dap-go").setup() end },
}
