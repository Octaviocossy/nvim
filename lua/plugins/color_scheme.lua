return {
  {
    "Shatur/neovim-ayu",
    priority = 1000,
    config = function()
      require("ayu").setup({
        mirage = false, -- dark variant
        -- Transparent editor background. Floats (completion, pickers, hover)
        -- intentionally keep ayu's background so they stay readable.
        overrides = {
          Normal = { bg = "None" },
          NormalNC = { bg = "None" },
          SignColumn = { bg = "None" },
          EndOfBuffer = { bg = "None" },
          Folded = { bg = "None" },
        },
      })

      vim.cmd("colorscheme ayu-dark")
    end,
  },
}
