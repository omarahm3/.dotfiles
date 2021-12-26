-- This is an example init file , its supposed to be placed in /lua/custom dir
-- lua/custom/init.lua

-- This is where your custom modules and plugins go.
-- Please check NvChad docs if you're totally new to nvchad + dont know lua!!

local hooks = require "core.hooks"

-- MAPPINGS
-- To add new plugins, use the "setup_mappings" hook,

vim.g.copilot_no_tab_map = true;

hooks.add("setup_mappings", function(map)
  map("n", "<C-p>", ":Telescope find_files<CR>")
  map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
  map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
  map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
  map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
  map("n", "ge", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>")
  map("n", "gh", "<cmd>lua vim.lsp.diagnostic.disable()<CR>")
  map("n", "gs", "<cmd>lua vim.lsp.diagnostic.enable()<CR>")
  map("n", "<leader>gs", ":G<CR>")
  map("n", "<leader>gb", ":G blame<CR>")
end)

-- NOTE : opt is a variable  there (most likely a table if you want multiple options),
-- you can remove it if you dont have any custom options

-- Install plugins
-- To add new plugins, use the "install_plugin" hook,

-- examples below:

hooks.add("install_plugins", function(use)
  use {
    "williamboman/nvim-lsp-installer",
    config = function()
      local lsp_installer = require "nvim-lsp-installer"

      lsp_installer.on_server_ready(function(server)
        local opts = {}

        server:setup(opts)
        vim.cmd [[ do User LspAttachBuffers ]]
      end)
    end,
  }

  use {"tpope/vim-fugitive"}

  use {"folke/tokyonight.nvim"}

  -- use {"sbdchd/neoformat"}

  -- use {"github/copilot.vim"}
end)

-- NOTE: we heavily suggest using Packer's lazy loading (with the 'event' field)
-- see: https://github.com/wbthomason/packer.nvim
-- https://nvchad.github.io/config/walkthrough
