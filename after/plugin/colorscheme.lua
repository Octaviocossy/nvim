local colorscheme = "gruvbox"

local theme_status, theme = pcall(require, colorscheme)

if not theme_status then
  vim.notify("Colorscheme not found!")
  vim.cmd([[
    colorscheme default
		set background=dark
  ]])
  return
end

theme.setup({
  undercurl = true,
  underline = true,
  bold = true,
  italic = {
    strings = false,
    comments = false,
    operators = false,
    folds = false,
  },
  strikethrough = true,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  invert_intend_guides = false,
  inverse = true,
  contrast = "",
  palette_overrides = {},
  overrides = {},
  dim_inactive = false,
  transparent_mode = true,
})

local present, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)

if not present then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end
