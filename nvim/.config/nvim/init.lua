-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

pcall(require, "config.commands")
pcall(require, "config.keymaps")
pcall(require, "config.theme_picker")
