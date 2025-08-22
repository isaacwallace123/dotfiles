return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-go",
      "haydenmeade/neotest-jest",
      "nvim-neotest/nvim-nio",
    },
    opts = function(_, opts)
      opts = opts or {}
      opts.adapters = opts.adapters or {}
      table.insert(opts.adapters, require("neotest-python")({ runner = "pytest" }))
      table.insert(opts.adapters, require("neotest-go")({}))
      table.insert(opts.adapters, require("neotest-jest")({
        jestCommand = "npm test --",
        jestConfigFile = "jest.config.js",
        env = { CI = true },
        cwd = function() return vim.fn.getcwd() end,
      }))
      return opts
    end,
  },
}
