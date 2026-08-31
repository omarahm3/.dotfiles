-- Customize Mason plugins

---@type LazySpec
return {
  -- use mason-lspconfig to configure LSP installations
  {
    "williamboman/mason-lspconfig.nvim",
    -- overrides `require("mason-lspconfig").setup(...)`
    opts = {
      ensure_installed = {
        "lua_ls",
        "ts_ls",
        "terraformls",
        "yamlls",
        "bashls",
        "pyright",
        -- add more arguments for adding more language servers
      },
    },
  },
  -- use mason-null-ls to configure Formatters/Linter installation for null-ls sources
  {
    "jay-babu/mason-null-ls.nvim",
    -- overrides `require("mason-null-ls").setup(...)`
    opts = {
      ensure_installed = {
        "stylua",
        "black",
        "mypy",
        "pylint",
        -- add more arguments for adding more null-ls sources
      },
      -- Prefer the project's local .venv binaries so Python linters/formatters
      -- resolve project dependencies and type stubs (e.g. psycopg2,
      -- types-psycopg2). Mason installs each tool in an isolated venv without
      -- project deps, which otherwise causes spurious import-error/import-untyped.
      handlers = {
        black = function()
          require("null-ls").register(
            require("null-ls").builtins.formatting.black.with { prefer_local = ".venv/bin" }
          )
        end,
        mypy = function()
          require("null-ls").register(
            require("null-ls").builtins.diagnostics.mypy.with { prefer_local = ".venv/bin" }
          )
        end,
        pylint = function()
          require("null-ls").register(
            require("null-ls").builtins.diagnostics.pylint.with { prefer_local = ".venv/bin" }
          )
        end,
      },
    },
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    -- overrides `require("mason-nvim-dap").setup(...)`
    opts = {
      ensure_installed = {
        "python",
        -- add more arguments for adding more debuggers
      },
    },
  },
}
