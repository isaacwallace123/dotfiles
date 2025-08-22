local M = { name = "Rose Pine (Reded)", scheme = "rose-pine" }

function M.setup()
  require("rose-pine").setup({
    variant = "main",
    dark_variant = "main",
    highlight_groups = {
      Normal = { bg = "#1a0b0b" },
      CursorLine = { bg = "#2a1010" },
      DiagnosticError = { fg = "#ff5c57" },
      DiagnosticWarn  = { fg = "#ff8844" },
    },
  })
end

return M
