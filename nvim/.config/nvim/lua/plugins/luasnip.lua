-- ~/.config/nvim/lua/plugins/luasnip.lua
-- ~/.config/nvim/lua/plugins/luasnip.lua
return {
  "L3MON4D3/LuaSnip",
  config = function()
    require("luasnip.loaders.from_lua").lazy_load()
    local ls = require("luasnip")
    local s = ls.snippet
    local t = ls.text_node

    ls.add_snippets("sh", {
      s({
        trig = "header",
        name = "Bash Script Header",
        dscr = "Add a standardized header to bash scripts",
      }, {
        t({
          "#!/bin/bash",
          "",
          "#===============================================================================",
          "#",
          "#   Script Adı: ",
          "#   Versiyon: 1.0.0",
          string.format("#   Tarih: %s", os.date("%Y-%m-%d")),
          "#   Yazar: ",
          "#   E-posta: ",
          "#   ",
          "#   Açıklama: ",
          "#   ",
          "#   Gereksinimler:",
          "#   - ",
          "#   ",
          "#   Kullanım: ",
          "#   bash script.sh [PARAMETRELER]",
          "#   ",
          "#   Lisans: MIT",
          "#   ",
          "#===============================================================================",
          "",
          'VERSION="1.0.0"',
          'SCRIPT_NAME=$(basename "$0")',
          "",
          '[[ "${BASH_SOURCE[0]}" != "$0" ]] && echo "Script source edilemez!" && exit 1',
          "",
        }),
      }),
    })
  end,
}
