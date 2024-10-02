return {
  -- {
  --   "datsfilipe/vesper.nvim",
  --   config = function()
  --     require("vesper").setup({
  --       transparent = true, -- Boolean: Sets the background to transparent
  --       italics = {
  --         comments = false, -- Boolean: Italicizes comments
  --         keywords = false, -- Boolean: Italicizes keywords
  --         functions = false, -- Boolean: Italicizes functions
  --         strings = false, -- Boolean: Italicizes strings
  --         variables = false, -- Boolean: Italicizes variables
  --       },
  --       overrides = {},  -- A dictionary of group names, can be a function returning a dictionary or a table.
  --       palette_overrides = {},
  --     })
  --
  --     vim.cmd("colorscheme vesper")
  --
  --   end,
  -- },
  {
    "ellisonleao/gruvbox.nvim",
    config = function()
      -- Default options:
      require("gruvbox").setup({
        terminal_colors = true, -- add neovim terminal colors
        undercurl = true,
        underline = true,
        bold = true,
        italic = {
          strings = false,
          emphasis = false,
          comments = false,
          operators = false,
          folds = false,
        },
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        invert_intend_guides = false,
        inverse = true, -- invert background for search, diffs, statuslines and errors
        contrast = "", -- can be "hard", "soft" or empty string
        palette_overrides = {},
        overrides = {},
        dim_inactive = false,
        transparent_mode = true,
      })
      vim.cmd("colorscheme gruvbox")
    end,
  },
}
