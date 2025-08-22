return {
  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
    config = function()
      local jdtls = require("jdtls")
      local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
      local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

      local cmd = { "jdtls" }
      local config = {
        cmd = cmd,
        root_dir = require("jdtls.setup").find_root({ "mvnw", "gradlew", ".git" }),
        settings = {
          java = {
            signatureHelp = { enabled = true },
            contentProvider = { preferred = "fernflower" },
            configuration = { updateBuildConfiguration = "interactive" },
          },
        },
        init_options = { bundles = {} },
        workspaceFolders = { workspace_dir },
      }
      jdtls.start_or_attach(config)
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts = opts or {}
      opts.ensure_installed = vim.tbl_extend("force", opts.ensure_installed or {}, { "java" })
      return opts
    end,
  },
}
