return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      -- tema ayarlarını burada yapılandırabilirsiniz
      vim.cmd([[colorscheme tokyonight-night]]) -- veya diğer varyantlardan birini
    end,
  },
}
