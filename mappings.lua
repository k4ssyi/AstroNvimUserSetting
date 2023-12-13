-- Mapping data with "desc" stored directly by vim.keymap.set().
--
-- Please use this mappings table to set keyboard mapping since this is the
-- lower level configuration and more robust one. (which-key will
-- automatically pick-up stored data by this setting.)
return {
  -- first key is the mode
  n = {
    -- 行の端に行く
    ["<C-a>"] = { "^" },
    ["<C-e>"] = { "$" },

    -- split window resize
    -- Alt key
    ["∆"] = { ":resize +2<CR>", desc = "Resize split up" },
    ["˚"] = { ":resize -2<CR>", desc = "Resize split down" },
    ["¬"] = { ":vertical resize +2<CR>", desc = "Resize split left" },
    ["˙"] = { ":vertical resize -2<CR>", desc = "Resize split right" },

    -- Do not yank with x
    x = { '"_x', desc = "do not yank with x" },

    -- second key is the lefthand side of the map
    ["\\"] = { "<cmd>vsplit<cr>", desc = "Vertical Split" },
    ["-"] = { "<cmd>split<cr>", desc = "Horizontal Split" },

    -- navigate buffer tabs with `H` and `L`
    L = {
      function() require("astronvim.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end,
      desc = "Next buffer",
    },
    H = {
      function() require("astronvim.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
      desc = "Previous buffer",
    },

    -- mappings seen under group name "Buffer"
    ["<leader>bD"] = {
      function()
        require("astronvim.utils.status").heirline.buffer_picker(
          function(bufnr) require("astronvim.utils.buffer").close(bufnr) end
        )
      end,
      desc = "Pick to close",
    },
    -- tables with the `name` key will be registered with which-key if it's installed
    -- this is useful for naming menus
    ["<leader>b"] = { name = "Buffers" },
    -- quick save
    -- ["<C-s>"] = { ":w!<cr>", desc = "Save File" },  -- change description but the same command
  },
  i = {
    -- カーソルを行の末尾に移動
    ["<C-e>"] = { "<Esc>A", desc = "Move to end of line" },
    -- カーソルを行の先頭に移動
    ["<C-a>"] = { "<Esc>I", desc = "Move to start of line" },
  },
  v = {
    x = { '"_x', desc = "do not yank with x" },
    ["<C-a>"] = { "^" },
    ["<C-e>"] = { "$" },
  },
  t = {
    -- setting a mapping to false will disable it
    -- ["<esc>"] = false,
  },
}
