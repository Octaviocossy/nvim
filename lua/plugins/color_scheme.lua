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

      -- Follow the macOS system appearance. `colorscheme ayu` (no suffix) picks
      -- its palette from `vim.o.background`, so we just keep that in sync with
      -- the OS and reload. lualine (`theme = "auto"`) follows via ColorScheme.
      local current

      local function apply(bg)
        if bg == current then
          return
        end
        current = bg
        vim.o.background = bg
        vim.cmd("colorscheme ayu")
      end

      -- `AppleInterfaceStyle` is "Dark" in dark mode and absent in light mode.
      local function read_async(cb)
        vim.system(
          { "defaults", "read", "-g", "AppleInterfaceStyle" },
          { text = true },
          function(out)
            local bg = (out.stdout or ""):match("Dark") and "dark" or "light"
            vim.schedule(function()
              cb(bg)
            end)
          end
        )
      end

      if vim.fn.has("mac") == 1 then
        -- Initial read is synchronous so the right theme loads with no flash.
        local out = vim.fn.system({ "defaults", "read", "-g", "AppleInterfaceStyle" })
        apply(out:match("Dark") and "dark" or "light")

        -- Poll so the theme follows a live system toggle (e.g. auto at sunset).
        local timer = assert(vim.uv.new_timer())
        timer:start(3000, 3000, function()
          read_async(apply)
        end)

        -- And re-check immediately whenever Neovim regains focus.
        vim.api.nvim_create_autocmd("FocusGained", {
          callback = function()
            read_async(apply)
          end,
        })
      else
        apply("dark")
      end
    end,
  },
}
