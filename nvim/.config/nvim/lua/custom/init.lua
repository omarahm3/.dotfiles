-- This is an example init file , its supposed to be placed in /lua/custom dir
-- lua/custom/init.lua

-- This is where your custom modules and plugins go.
-- Please check NvChad docs if you're totally new to nvchad + dont know lua!!

local hooks = require "core.hooks"

-- MAPPINGS
-- To add new plugins, use the "setup_mappings" hook,

vim.g.copilot_no_tab_map = true;
-- This to enable treesitter and lsp for file like Dockerfile.dev
vim.cmd 'autocmd BufRead,BufNewFile Dockerfile,Dockerfile.* set filetype=dockerfile'
-- Stop sourcing filetype.vim
vim.g.did_load_filetypes = 1

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
  map("n", "<leader>t", ":TroubleToggle<CR>")
  map("n", "<F12>", ":TZAtaraxis<CR>")
  map("n", "<leader>ff", ":lua require('spectre').open()<CR>")
  map("n", "<leader>fc", ":lua require('spectre').open_visual({select_word=true})<CR>")
  map("n", "<leader>fp", "viw:lua require('spectre').open_file_search()<cr>")
  -- Cheat sheet script
  map("n", "<leader>ct", ":w! | :vne | te cht <c-r>% ")
  -- Hop keys
  map("n", "<leader>hh", ":lua require'hop'.hint_words()<CR>")
  map("n", "<leader>hl", ":lua require'hop'.hint_lines()<CR>")
  map("v", "<leader>hh", ":lua require'hop'.hint_words()<CR>")
  map("v", "<leader>hl", ":lua require'hop'.hint_lines()<CR>")
end)

-- Hop colors
vim.cmd 'hi HopNextKey guifg=#ff9900'
vim.cmd 'hi HopNextKey1 guifg=#ff9900'
vim.cmd 'hi HopNextKey2 guifg=#ff9900'

-- NOTE : opt is a variable  there (most likely a table if you want multiple options),
-- you can remove it if you dont have any custom options

-- Install plugins
-- To add new plugins, use the "install_plugin" hook,

-- examples below:
hooks.add("install_plugins", function(use)
  use {
    "williamboman/nvim-lsp-installer",
  }

  use {
    "karb94/neoscroll.nvim",
    opt = true,
    config = function()
      require("neoscroll").setup()
    end,

    -- lazy loading
    setup = function()
      require("core.utils").packer_lazy_load "neoscroll.nvim"
    end,
  }

  use {"tpope/vim-fugitive"}

  use {"folke/tokyonight.nvim"}

  use { "nathom/filetype.nvim" }

  use {
    "Pocco81/TrueZen.nvim",
    cmd = {
      "TZAtaraxis",
      "TZMinimalist",
      "TZFocus",
    },
    config = function()
      -- check https://github.com/Pocco81/TrueZen.nvim#setup-configuration (init.lua version)
      local true_zen = require("true-zen")

      true_zen.setup {
        integrations = {
          tmux = true,
        }
      }
    end
  }

  use {
    "luukvbaal/stabilize.nvim",
    config = function() require("stabilize").setup() end
  }

  use {
    "folke/trouble.nvim",
    opt = true,
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end,

    -- lazy loading
    setup = function()
      require("core.utils").packer_lazy_load "trouble.nvim"
    end,
  }

  use {
    "windwp/nvim-spectre",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("spectre").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end,
  }

  use {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  }

  use {
    'phaazon/hop.nvim',
    branch = 'v1', -- optional but strongly recommended
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
    end
  }

  -- use {"sbdchd/neoformat"}

  -- use {"github/copilot.vim"}
end)

-- NOTE: we heavily suggest using Packer's lazy loading (with the 'event' field)
-- see: https://github.com/wbthomason/packer.nvim
-- https://nvchad.github.io/config/walkthrough
