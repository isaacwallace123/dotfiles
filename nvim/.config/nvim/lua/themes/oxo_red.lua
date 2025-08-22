local M = { name = "Oxocarbon Red", scheme = "oxocarbon" }

function M.setup()
  vim.schedule(function()
    local hi = vim.api.nvim_set_hl
    hi(0, "Normal",       { bg = "#0f0a0a", fg = "#e6dada" })
    hi(0, "CursorLine",   { bg = "#221111" })
    hi(0, "Visual",       { bg = "#442222" })
    hi(0, "DiagnosticError", { fg = "#ff5c57" })
    hi(0, "DiagnosticWarn",  { fg = "#ff8844" })
  end)
end

return M
