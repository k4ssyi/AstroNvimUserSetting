return {
  "karb94/neoscroll.nvim",
  event = "VeryLazy",
  config = function()
    require("neoscroll").setup {
      mappings = { "<C-u>", "<C-d>" },
    }
    local t = {}
    t["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "125" } }
    t["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "125" } }
    require("neoscroll.config").set_mappings(t)
  end,
}
