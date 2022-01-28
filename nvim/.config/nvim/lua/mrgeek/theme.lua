local theme = 'github_dark_default'

local status_ok, _ = pcall(vim.cmd, 'colorscheme ' .. theme)

if not status_ok then
  vim.notify('Theme ' .. theme .. ' was not found and it was not applied!')
  return
end
