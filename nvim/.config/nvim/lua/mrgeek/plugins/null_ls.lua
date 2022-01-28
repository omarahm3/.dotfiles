local present, null_ls = pcall(require, 'null-ls')

if not present then
  return
end

local b = null_ls.builtins

local sources = {
  -- JS
  b.formatting.prettierd.with { filetypes = { 'html', 'markdown', 'css' } },
  b.formatting.eslint_d,
  b.diagnostics.eslint_d,

  -- PHP
  null_ls.builtins.diagnostics.php,

  -- Lua
  b.formatting.stylua,
  b.diagnostics.luacheck.with { extra_args = { '--global vim' } },

  -- Shell
  b.formatting.shfmt,
  b.diagnostics.shellcheck.with { diagnostics_format = '#{m} [#{c}]' },
}

null_ls.setup {
  debug = true,
  sources = sources,

  -- format on save
  on_attach = function(client)
    -- if client.resolved_capabilities.document_formatting then
    --   vim.cmd 'autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()'
    -- end
  end,
}
