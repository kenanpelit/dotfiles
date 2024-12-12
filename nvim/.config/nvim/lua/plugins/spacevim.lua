return {
  -- add SpaceVim
  { "https://github.com/SpaceVim/SpaceVim-theme" },

  -- Configure LazyVim to load SpaceVim
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "SpaceVim",
    },
  },
}
