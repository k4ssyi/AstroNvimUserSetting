return {
  "petertriho/nvim-scrollbar",
  opts = function(_, opts)
    require("astronvim.utils").extend_tbl(opts, {
      handlers = {
        gitsigns = require("astronvim.utils").is_available "gitsigns.nvim",
        search = require("astronvim.utils").is_available "nvim-hlslens",
        ale = require("astronvim.utils").is_available "ale",
      },
    })
    require("scrollbar").setup {
      show = true,
      marks = {
        Cursor = {
          text = " ",
          priority = 0,
          gui = nil,
          color = "#1c1c1c",
          color_nr = 234,
          cterm = nil,
          highlight = "Normal",
        },
      },
      handlers = {
        cursor = true,
        diagnostic = true,
        gitsigns = true,
        handle = true,
        search = true,
        ale = true,
      },
    }

    return opts
  end,
  event = "User AstroFile",
}
