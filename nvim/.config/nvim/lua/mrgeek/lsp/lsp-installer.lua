local present, lsp_installer = pcall(require, 'nvim-lsp-installer')

if not present then
  vim.notify('nvim-lsp-installer does not exist')
  return
end

-- Register a handler that will be called for all installed servers
-- Alternatively, you may also register handlers on specific server instances instead
lsp_installer.on_server_ready(function(server)
  local opts = {
    on_attach = require('mrgeek.lsp.handlers').on_attach,
    capabilities = require('mrgeek.lsp.handlers').capabilities,
  }

  if server.name == 'jsonls' then
    local jsonls_opts = require('mrgeek.lsp.settings.jsonls')
    opts = vim.tbl_deep_extend('force', jsonls_opts, opts)
  end

  if server.name == 'sumneko_lua' then
    local lua_opts = require('mrgeek.lsp.settings.sumneko_lua')
    opts = vim.tbl_deep_extend('force', lua_opts, opts)
  end

  server:setup(opts)
  vim.cmd [[ do User LspAttachBuffers ]]
end)
