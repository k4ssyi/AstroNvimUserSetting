return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvimtools/none-ls-extras.nvim",
  },
  opts = function(_, config)
    -- config variable is the default configuration table for the setup function call
    local ok, null_ls = pcall(require, "null-ls")
    if not ok then return end
    -- Check supported formatters and linters
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
    config.sources = {
      require("none-ls.formatting.jq").with {
        condition = function(utils) return utils.has_file { "biome.json", "biome.jsonc" } == false end,
      },
      require("none-ls.formatting.eslint_d").with {
        condition = function(utils) return utils.has_file { ".eslintrc.json", ".eslintrc.js", ".eslint.config.js" } end,
      },
      null_ls.builtins.formatting.prettierd.with {
        condition = function(utils) return utils.has_file { ".prettierrc", ".prettierrc.js" } end,
      },
      null_ls.builtins.formatting.biome.with {
        condition = function(utils) return utils.has_file { "biome.json", "biome.jsonc" } end,
        args = {
          "check",
          "--apply",
          "--formatter-enabled=true",
          "--organize-imports-enabled=true",
          "--skip-errors",
          "--additional-arg",
          "$FILENAME",
        },
      },
      -- 診断専用に設定,formatはしない
      null_ls.builtins.diagnostics.typos,
      null_ls.builtins.diagnostics.flake8,
    }
    return config -- return final config table
  end,
}
