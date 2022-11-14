--[[
lvim is the global options object

Linters should be
filled in as strings with either
a global executable or a path to
an executable
]]
-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT

local options = {
  cmdheight = 1, -- more space to neovim command line to display messages
  -- clipboard = "unnamedplus", -- allows neovim to access system clipboard
  -- completeopt = { "menuone", "noselect" }, -- mostly just for cmp
  -- conceallevel = 0, -- so that `` is visible on markdown
  -- fileencoding = "utf-8", -- the encoding written to file
  hlsearch = true, -- highlight all matches on previous search pattern
  ignorecase = true, -- ignore case while searching
  mouse = "", -- disable mouse mode to be used in vim
  pumheight = 10, -- pop up menu height
  showmode = false, -- dont show stuff like INSERT anymore
  showtabline = 2, -- always show tabs
  smartcase = true, -- override the 'ignorecase' option if the search pattern contains upper case characters
  smartindent = true, -- do smart autoindenting when starting a new line
  splitbelow = true, -- force all horizontal splits to go below current window
  splitright = true, -- force all vertical splits to go right of the current window
  swapfile = true, -- creates swap file
  termguicolors = true, -- set term gui colors
  timeoutlen = 200, -- time to wait for a mapped sequence to complete (ms)
  undofile = true, -- enable persistent undo
  updatetime = 30, -- faster completion (4000ms default)
  writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
  expandtab = true, -- convert tabs to spaces
  shiftwidth = 2, -- number of spaces inserted to each indentation
  tabstop = 2, -- insert 2 spaces for a tab
  cursorline = true, -- enable highlighting current line
  number = true, -- enable line numbers
  relativenumber = true, -- disable relative numbers
  numberwidth = 2, -- set number column width to 2 {default 4}
  signcolumn = "yes", -- always show sign column otherwise it will shift text every time
  wrap = false, -- disable text wrap and show it as 1 line
  scrolloff = 8, -- minimal number of screen lines to keep above and below the cursor
  sidescrolloff = 8,
  guifont = "monospace:h17", -- font used on neovim gui
  -- shadafile = "NONE",
}

local g_options = {
  tokyonight_style = "night", -- the main variant of tokyonight theme
  catppuccin_flavour = "mocha",
  material_style = "oceanic", -- the main variant of material theme
}

for key, value in pairs(options) do
  vim.opt[key] = value
end

for key, value in pairs(g_options) do
  vim.g[key] = value
end

vim.cmd("set whichwrap+=<,>,[,],h,l")
vim.cmd([[set iskeyword+=-]])
vim.cmd([[set formatoptions-=cro]])
vim.cmd([[set shell=/bin/bash]])
vim.opt.shortmess:append("c")

-- Folding options
vim.o.foldenable = true
vim.o.foldcolumn = "1"
vim.o.foldlevelstart = 99
vim.o.foldlevel = 99

-- general
lvim.log.level = "warn"
lvim.format_on_save.enabled = true
lvim.colorscheme = "catppuccin"

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"

-- add your own keymapping
local git_mappings = lvim.builtin.which_key.mappings["g"]
local find_mappings = lvim.builtin.which_key.mappings["s"]

local mappings = {
  globalNormal = {
    ["<C-q>"] = { ":wqall<CR>", "Close nvim" },
    ["<ESC>"] = { ":noh<CR>", "No highlight" },
    ["<Tab>"] = { ":BufferLineCycleNext<CR>", "Next" },
    ["<S-Tab>"] = { ":BufferLineCyclePrev<CR>", "Previous" },
    ["<C-p>"] = { ":Telescope find_files<CR>", "Find file" },
  },
  vGlobalMappings = {
    ["<S-Tab>"] = { "<gv", "Indent left" },
    ["<Tab>"] = { ">gv", "Indent right" },
    ["p"] = { '"_dP', "Keep what you are pasting in the clipboard register" },
  },
  normal = {
    ["x"] = { ':BufferKill<CR>', "Close current buffer" },
    ["f"] = vim.tbl_deep_extend("force", find_mappings, {
      w = { ":Telescope live_grep<CR>", "Text" },
      t = {},
    }),
    ["g"] = vim.tbl_deep_extend("force", git_mappings, {
      h = git_mappings.s,
      s = { ":G<CR>", "Status" }
    }),
    ["zR"] = { ":lua require('ufo').openAllFolds", "open all folds" },
    ["zM"] = { ":lua require('ufo').closeAllFolds", "close all folds" },
  },
}

-- Remove some mappings
lvim.builtin.which_key.mappings["c"] = {}
lvim.builtin.which_key.mappings["s"] = {}

-- Add global normal mappings
for key, value in pairs(mappings.globalNormal) do
  lvim.keys.normal_mode[key] = value[1]
end

-- Add global visual mappings
for key, value in pairs(mappings.vGlobalMappings) do
  lvim.keys.visual_mode[key] = value[1]
end

-- Add normal mappings
for key, value in pairs(mappings.normal) do
  lvim.builtin.which_key.mappings[key] = value
end

-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
-- local _, actions = pcall(require, "telescope.actions")
-- lvim.builtin.telescope.defaults.mappings = {
--   -- for input mode
--   i = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--     ["<C-n>"] = actions.cycle_history_next,
--     ["<C-p>"] = actions.cycle_history_prev,
--   },
--   -- for normal mode
--   n = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--   },
-- }

-- Change theme settings
-- lvim.builtin.theme.options.dim_inactive = true
-- lvim.builtin.theme.options.style = "storm"

-- Use which-key to add extra bindings with the leader-key prefix
-- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
-- lvim.builtin.which_key.mappings["t"] = {
--   name = "+Trouble",
--   r = { "<cmd>Trouble lsp_references<cr>", "References" },
--   f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
--   d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
--   q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
--   l = { "<cmd>Trouble loclist<cr>", "LocationList" },
--   w = { "<cmd>Trouble workspace_diagnostics<cr>", "Workspace Diagnostics" },
-- }

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "javascript",
  "json",
  "lua",
  "python",
  "typescript",
  "tsx",
  "css",
  "rust",
  "java",
  "yaml",
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enable = true
lvim.builtin.treesitter.indent.disable = { "python" }

-- generic LSP settings

-- -- make sure server will always be installed even if the server is in skipped_servers list
-- lvim.lsp.installer.setup.ensure_installed = {
--     "sumneko_lua",
--     "jsonls",
-- }
-- -- change UI setting of `LspInstallInfo`
-- -- see <https://github.com/williamboman/nvim-lsp-installer#default-configuration>
-- lvim.lsp.installer.setup.ui.check_outdated_servers_on_open = false
-- lvim.lsp.installer.setup.ui.border = "rounded"
-- lvim.lsp.installer.setup.ui.keymaps = {
--     uninstall_server = "d",
--     toggle_server_expand = "o",
-- }

-- ---@usage disable automatic installation of servers
-- lvim.lsp.installer.setup.automatic_installation = false

-- ---configure a server manually. !!Requires `:LvimCacheReset` to take effect!!
-- ---see the full default list `:lua print(vim.inspect(lvim.lsp.automatic_configuration.skipped_servers))`
-- vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pyright" })
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pyright", opts)

-- ---remove a server from the skipped list, e.g. eslint, or emmet_ls. !!Requires `:LvimCacheReset` to take effect!!
-- ---`:LvimInfo` lists which server(s) are skipped for the current filetype
-- lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
--   return server ~= "emmet_ls"
-- end, lvim.lsp.automatic_configuration.skipped_servers)

-- -- you can set a custom on_attach function that will be used for all the language servers
-- -- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end

-- set a formatter, this will override the language server formatting capabilities (if it exists)
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  -- { command = "black", filetypes = { "python" } },
  -- { command = "isort", filetypes = { "python" } },
  {
    -- each formatter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
    command = "prettier",
    ---@usage arguments to pass to the formatter
    -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
    extra_args = { "--print-with", "100" },
    ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
    filetypes = { "typescript", "typescriptreact" },
  },
}

-- -- set additional linters
-- local linters = require "lvim.lsp.null-ls.linters"
-- linters.setup {
--   { command = "flake8", filetypes = { "python" } },
--   {
--     -- each linter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
--     command = "shellcheck",
--     ---@usage arguments to pass to the formatter
--     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
--     extra_args = { "--severity", "warning" },
--   },
--   {
--     command = "codespell",
--     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
--     filetypes = { "javascript", "python" },
--   },
-- }

-- Additional Plugins
lvim.plugins = {
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = [[ require("better_escape").setup({
        mapping = { "jk" },
        timeout = 300,
      }) ]],
  },
  {
    "catppuccin/nvim",
    as = "catppuccin",
  },
  {
    "tpope/vim-fugitive",
  },
  {
    "kevinhwang91/nvim-ufo",
    requires = "kevinhwang91/promise-async",
    config = [[ require("ufo").setup() ]],
  }
}

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
-- vim.api.nvim_create_autocmd("BufEnter", {
--   pattern = { "*.json", "*.jsonc" },
--   -- enable wrap mode for json files only
--   command = "setlocal wrap",
-- })
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "zsh",
--   callback = function()
--     -- let treesitter use bash highlight for zsh files as well
--     require("nvim-treesitter.highlight").attach(0, "bash")
--   end,
-- })
