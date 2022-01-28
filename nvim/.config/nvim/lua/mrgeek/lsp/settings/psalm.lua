local present, lspconfig = pcall(require, 'lspconfig')

if not present then
  return
end

return {
  root_dir = lspconfig.util.root_pattern('composer.json'),
}

