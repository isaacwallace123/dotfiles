local M = { name = "Tokyo Red", scheme = "tokyonight-storm" }

function M.setup()
  require("tokyonight").setup({
    style = "storm",
    on_colors = function(c)
      c.bg = "#1a0b0b"
      c.bg_dark = "#100505"
      c.bg_float = "#1a0b0b"
      c.red = "#ff5c57"
      c.orange = "#ff8844"
    end,
  })
end

return M
