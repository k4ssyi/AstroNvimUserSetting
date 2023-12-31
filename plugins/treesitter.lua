return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    -- add more things to the ensure_installed table protecting against community packs modifying it
    opts.indent = { enable = false } -- disable indent
    opts.ensure_installed = require("astronvim.utils").list_insert_unique(opts.ensure_installed, {
      "c",
      "lua",
      "luadoc",
      "git_config",
      "git_rebase",
      "gitcommit",
      "gitignore",
      "go",
      "html",
      "javascript",
      "json",
      "prisma",
      "python",
      "query",
      "sql",
      "toml",
      "tsv",
      "typescript",
      "vim",
      "vimdoc",
      "xml",
      "yaml",
    })
  end,
}
