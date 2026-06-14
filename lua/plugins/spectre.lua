return {
  {
    "nvim-pack/nvim-spectre",
    lazy = true,
    cmd = { "Spectre" },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      -- ayu-flavored highlights (find = red, replace = green; dark text)
      vim.api.nvim_set_hl(0, "SpectreSearch", { bg = "#f07178", fg = "#0b0e14" })
      vim.api.nvim_set_hl(0, "SpectreReplace", { bg = "#aad94c", fg = "#0b0e14" })

      require("spectre").setup({
        highlight = {
          search = "SpectreSearch",
          replace = "SpectreReplace",
        },
        mapping = {
          ["send_to_qf"] = {
            map = "<C-q>",
            cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
            desc = "send all items to quickfix",
          },
        },
        replace_engine = {
          sed = {
            cmd = "sed",
          },
        },
      })
    end,
  },
}
