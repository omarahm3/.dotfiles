-- these are vim.opt.<OPTIONS>
local options = {
  backup = false,                                   -- creates backup file
  clipboard = 'unnamedplus',                        -- allows neovim to access system clipboard
  cmdheight = 1,                                    -- more space to neovim command line to display messages
  completeopt = { 'menuone', 'noselect' },          -- mostly just for cmp
  conceallevel = 0,                                 -- so that `` is visible on markdown
  fileencoding = 'utf-8',                           -- the encoding written to file
  hlsearch = true,                                  -- highlight all matches on previous search pattern
  ignorecase = true,                                -- ignore case while searching
  mouse = 'a',                                      -- allow mouse mode to be used in vim
  pumheight = 10,                                   -- pop up menu height
  showmode = false,                                 -- dont show stuff like INSERT anymore
  showtabline = 2,                                  -- always show tabs
  smartcase = true,                                 -- override the 'ignorecase' option if the search pattern contains upper case characters
  smartindent = true,                               -- do smart autoindenting when starting a new line
  splitbelow = true,                                -- force all horizontal splits to go below current window
  splitright = true,                                -- force all vertical splits to go right of the current window
  swapfile = true,                                  -- creates swap file
  termguicolors = true,                             -- set term gui colors
  timeoutlen = 1000,                                -- time to wait for a mapped sequence to complete (ms)
  undofile = true,                                  -- enable persistent undo
  updatetime = 30,                                  -- faster completion (4000ms default)
  writebackup = false,                              -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
  expandtab = true,                                 -- convert tabs to spaces
  shiftwidth = 2,                                   -- number of spaces inserted to each indentation
  tabstop = 2,                                      -- insert 2 spaces for a tab
  cursorline = true,                                -- enable highlighting current line
  number = true,                                    -- enable line numbers
  relativenumber = false,                           -- disable relative numbers
  numberwidth = 2,                                  -- set number column width to 2 {default 4}
  signcolumn = 'yes',                               -- always show sign column otherwise it will shift text every time
  wrap = false,                                     -- disable text wrap and show it as 1 line
  scrolloff = 8,                                   -- minimal number of screen lines to keep above and below the cursor
  sidescrolloff = 8,
  guifont = 'monospace:h17',                        -- font used on neovim gui
}

-- these are vim.g.<OPTIONS>
local g_options = {
  tokyonight_style = 'night',                       -- the main variant of tokyonight theme
}

vim.opt.shortmess:append 'c'

for key, value in pairs(g_options) do
  vim.g[key] = value
end

for key, value in pairs(options) do
  vim.opt[key] = value
end

vim.cmd'set whichwrap+=<,>,[,],h,l'
vim.cmd[[set iskeyword+=-]]
vim.cmd[[set formatoptions-=cro]]
