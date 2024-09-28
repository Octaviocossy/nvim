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
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        transparent = true,
        styles = {
          -- Style to be applied to different syntax groups
          -- Value is any valid attr-list value for `:help nvim_set_hl`
          comments = { italic = true },
          keywords = { italic = true },
          functions = {},
          variables = {},
          -- Background styles. Can be "dark", "transparent" or "normal"
          sidebars = "transparent", -- style for sidebars, see below
          floats = "transparent", -- style for floating windows
        },
      })

      vim.cmd("colorscheme tokyonight-night")
    end,
  },
}
