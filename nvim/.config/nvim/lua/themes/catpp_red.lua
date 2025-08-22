local M = { name = "Catppuccin Mocha Red", scheme = "catppuccin" }

function M.setup()
  require("catppuccin").setup({
    flavour = "mocha",
    color_overrides = {
      mocha = {
        base = "#1a0b0b",
        mantle = "#150808",
        crust = "#100505",
        red = "#ff5c57",
        peach = "#ff8844",
      },
    },
  })
end

return M
