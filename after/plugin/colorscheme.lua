local colorscheme = "tokyonight"

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
  style = "storm",
  light_style = "day",
  transparent = false,
  styles = {
    sidebars = "normal", -- transparent / normal
    floats = "normal",   -- transparent / normal
  },
})

local present, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)

if not present then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end
