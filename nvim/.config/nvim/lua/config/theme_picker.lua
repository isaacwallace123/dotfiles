local M = {}

local state_file = vim.fn.stdpath("state") .. "/theme.json"

local function save(name)
  local ok, data = pcall(vim.json.encode, { name = name })
  if ok then vim.fn.writefile({ data }, state_file) end
end

local function load_name()
  if vim.fn.filereadable(state_file) == 1 then
    local lines = vim.fn.readfile(state_file)
    if #lines > 0 then
      local ok, data = pcall(vim.json.decode, lines[1])
      if ok and data and data.name then return data.name end
    end
  end
end

local function scan_themes()
  local themes = {}
  local dir = vim.fn.stdpath("config") .. "/lua/themes"
  for name, type_ in vim.fs.dir(dir) do
    if type_ == "file" and name:sub(-4) == ".lua" then
      local mod = "themes." .. name:sub(1, -5)
      local ok, t = pcall(require, mod)
      if ok and type(t) == "table" and t.name and t.scheme then
        table.insert(themes, t)
      end
    end
  end
  table.sort(themes, function(a, b) return a.name < b.name end)
  return themes
end

local function apply(entry)
  if not entry then return end
  if entry.setup then entry.setup() end
  vim.cmd.colorscheme(entry.scheme)
  vim.g._last_theme_name = entry.name
  save(entry.name)
end

function M.reload()
  for k in pairs(package.loaded) do
    if k:match("^themes%.") then package.loaded[k] = nil end
  end
  M.themes = scan_themes()
end

function M.pick()
  if not M.themes or #M.themes == 0 then M.reload() end
  local items = {}
  for i, t in ipairs(M.themes) do items[i] = t.name end
  vim.ui.select(items, { prompt = "Pick a theme" }, function(_, idx)
    if idx then apply(M.themes[idx]) end
  end)
end

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    M.reload()
    local last = load_name()
    if last then
      for _, t in ipairs(M.themes) do
        if t.name == last then apply(t); return end
      end
    end
    apply(M.themes[1])
  end,
})

return M
