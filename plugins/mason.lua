-- customize mason plugins
return {
  -- use mason-lspconfig to configure LSP installations
  {
    "williamboman/mason-lspconfig.nvim",
    -- overrides `require("mason-lspconfig").setup(...)`
    opts = function(_, opts)
      -- add more things to the ensure_installed table protecting against community packs modifying it
      opts.ensure_installed = require("astronvim.utils").list_insert_unique(opts.ensure_installed, {
        "bashls",
        "lua_ls",
        "yamlls",
        "tsserver",
        "tailwindcss",
        "docker_compose_language_service",
        "dockerls",
        "html",
        "jsonls",
        "prismals",
        "sqlls",
        "vimls",
        "biome",
        "pylsp",
      })
      opts.settings = {
        ["pylsp"] = {
          codeLens = { enable = true },
        },
        ["tsserver"] = {
          codeLens = { enable = true },
        },
      }
    end,
  },
  -- use mason-null-ls to configure Formatters/Linter installation for null-ls sources
  {
    "jay-babu/mason-null-ls.nvim",
    -- overrides `require("mason-null-ls").setup(...)`
    opts = function(_, opts)
      -- add more things to the ensure_installed table protecting against community packs modifying it
      opts.ensure_installed = require("astronvim.utils").list_insert_unique(opts.ensure_installed, {
        -- "cspell",
        "typos",
        "gitlint",
        "shellcheck",
        "jsonlint",
        "markdownlint",
        "yamllint",
        "fixjson",
        "stylua",
        "biome",
        "jq",
        "flake8",
        -- "black",
        -- "isort",
        -- "eslint_d",
        -- "prettierd",
      })
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    -- overrides `require("mason-nvim-dap").setup(...)`
    opts = function(_, opts)
      -- add more things to the ensure_installed table protecting against community packs modifying it
      opts.ensure_installed = require("astronvim.utils").list_insert_unique(opts.ensure_installed, {
        -- "python",
      })
    end,
  },
}
