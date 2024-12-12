-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
return {
  {
    "goolord/alpha-nvim",
    opts = function()
      local dashboard = require("alpha.themes.dashboard")

      -- Logo rengini değiştirmek için
      vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#FF69B4" })

      -- Buton rengini değiştirmek için
      vim.api.nvim_set_hl(0, "AlphaButtons", { fg = "#87CEEB" })

      -- Kısayol tuşlarının rengini değiştirmek için
      vim.api.nvim_set_hl(0, "AlphaShortcut", { fg = "#98FB98" })

      -- Footer rengini değiştirmek için
      vim.api.nvim_set_hl(0, "AlphaFooter", { fg = "#DDA0DD" })

      return dashboard
    end,
  },
}
