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
	italic = {
		strings = false,
		emphasis = false,
		comments = true,
		operators = false,
		folds = false,
	},
	contrast = "hard", -- can be "hard", "soft" or empty string
	transparent_mode = false,
})

local present, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)

if not present then
	vim.notify("colorscheme " .. colorscheme .. " not found!")
	return
end
