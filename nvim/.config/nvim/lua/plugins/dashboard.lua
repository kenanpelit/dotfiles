return {
  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      -- Renk tanımlaması - Yumuşak mavi tonları
      local colors = {
        header = "#b0b3f4", -- Ana ton
        buttons = "#a5a8f3", -- Biraz daha koyu
        shortcuts = "#b8bbf5", -- Biraz daha açık
        footer = "#9ea1f2", -- En koyu ton
      }

      -- Renkleri ayarla
      for name, color in pairs(colors) do
        vim.api.nvim_set_hl(0, "Alpha" .. name:gsub("^%l", string.upper), { fg = color })
      end

      -- KENP Logosu ve ASCII art
      dashboard.section.header.val = {
        [[                                                     ]],
        [[          ██╗  ██╗███████╗███╗   ██╗██████╗          ]],
        [[          ██║ ██╔╝██╔════╝████╗  ██║██╔══██╗         ]],
        [[          █████╔╝ █████╗  ██╔██╗ ██║██████╔╝         ]],
        [[          ██╔═██╗ ██╔══╝  ██║╚██╗██║██╔═══╝          ]],
        [[          ██║  ██╗███████╗██║ ╚████║██║              ]],
        [[          ╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝╚═╝              ]],
        [[                                                     ]],
      }

      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.header.opts.align = "center"

      -- Butonlar (ortalı)
      local function button(sc, txt, keybind)
        local b = dashboard.button(sc, txt, keybind)
        b.opts.hl = "AlphaButtons"
        b.opts.hl_shortcut = "AlphaShortcuts"
        b.opts.align = "center"
        b.opts.width = 40
        return b
      end

      dashboard.section.buttons.val = {
        button("f", "Dosya Bul", ":Telescope find_files <CR>"),
        button("n", "Yeni Dosya", ":ene <BAR> startinsert <CR>"),
        button("r", "Son Dosyalar", ":Telescope oldfiles <CR>"),
        button("t", "Metin Bul", ":Telescope live_grep <CR>"),
        button("p", "Projeler", ":Telescope projects <CR>"),
        button("b", "Yer İmleri", ":Telescope marks <CR>"),
        button("c", "Yapılandırma", ":e $MYVIMRC <CR>"),
        button("l", "Lazy", ":Lazy<CR>"),
        button("q", "Çıkış", ":qa<CR>"),
      }

      -- Footer (ortalı)
      dashboard.section.footer.val = ""
      dashboard.section.footer.opts.hl = "AlphaFooter"
      dashboard.section.footer.opts.align = "center"

      -- Layout
      dashboard.config.layout = {
        { type = "padding", val = 2 },
        dashboard.section.header,
        { type = "padding", val = 2 },
        dashboard.section.buttons,
        { type = "padding", val = 1 },
        dashboard.section.footer,
      }

      -- Ek ayarlar
      dashboard.config.opts.noautocmd = true
      dashboard.config.opts.margin = 5

      -- Dashboard'u kur
      alpha.setup(dashboard.opts)

      -- Yükleme süresi göstergesi (ortalı)
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        callback = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          dashboard.section.footer.val = "⚡ KENP " .. ms .. " ms'de yüklendi"
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  },
}
