return {
  {
    "ray-x/go.nvim",
    ft = { "go", "gomod", "gowork", "gosum" },
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup({
        lsp_cfg = true,
        lsp_gofumpt = true,
        trouble = true,
        test_runner = "go",
      })
    end,
    build = ':lua require("go.install").update_all_sync()',
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts = opts or {}
      opts.ensure_installed = vim.tbl_extend("force", opts.ensure_installed or {}, { "go", "gomod" })
      return opts
    end,
  },
}
