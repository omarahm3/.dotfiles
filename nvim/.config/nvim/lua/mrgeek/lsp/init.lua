local present, _ = pcall(require, 'lspconfig')

if not present then
  vim.notify('LspConfig does not exist')
  return
end

require 'mrgeek.lsp.lsp-installer'
require 'mrgeek.lsp.handlers'.setup()
