vim.api.nvim_create_user_command("ThemePick", function()
  require("config.theme_picker").pick()
end, {})

vim.api.nvim_create_user_command("ThemeReload", function()
  require("config.theme_picker").reload()
  require("config.theme_picker").pick()
end, {})
