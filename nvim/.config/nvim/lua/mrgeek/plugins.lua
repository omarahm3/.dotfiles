local fn = vim.fn

-- automatically install packer if its not there
local present, packer = pcall(require, 'mrgeek.packerinit')

if not present then
  vim.notify('Packer was not loaded, probably this is your first time huh?')
  return
end

-- autocommand that will reload neovim whenever you save plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

return packer.startup(function(use)
  -- Packer plugin --
  use {
    'wbthomason/packer.nvim', -- have packer manage itself
    event = 'VimEnter',
  }

  -- Dependencies --
  use 'nvim-lua/popup.nvim' -- implementation of popup api from vim in neovim
  use 'nvim-lua/plenary.nvim' -- useful lua functions that is used by lots of plugins

  use {
    'lewis6991/impatient.nvim',
    setup = function()
      require('mrgeek.plugins.impatient')
    end
  }

  -- UI stuff --
  use {
    'nvim-treesitter/nvim-treesitter',
    event = 'BufRead',
    run = ':TSUpdate',
    config = function()
      require('mrgeek.treesitter').setup()
    end,
  }

  use {
    'p00f/nvim-ts-rainbow',
    after = 'nvim-treesitter',
  }

  use {
    'windwp/nvim-autopairs',
    after = 'nvim-treesitter',
    config = function()
      require('mrgeek.plugins.autopairs')
    end,
  }

  use {
    'kyazdani42/nvim-web-devicons',
    after = 'nvim-treesitter',
  }

  use {
    'akinsho/bufferline.nvim',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function()
      require('mrgeek.plugins.bufferline')
    end,
    setup = function()
      require('mrgeek.keymaps').buffer_line()
    end,
  }

  use {
    'JoosepAlviste/nvim-ts-context-commentstring',
    after = 'nvim-treesitter',
  }

  use {
    'numToStr/Comment.nvim',
    after = 'nvim-ts-context-commentstring',
    config = function()
      require('mrgeek.plugins.comment')
    end,
    setup = function()
      require('mrgeek.keymaps').comment()
    end,
  }

  use {
    'lukas-reineke/indent-blankline.nvim',
    event = 'BufRead',
    config = function()
      require('mrgeek.plugins.indent_line')
    end
  }

  use {
    'folke/which-key.nvim',
    event = 'BufRead',
    config = function()
      require('mrgeek.plugins.whichkey')
    end
  }

  use {
    'glepnir/dashboard-nvim',
    config = function()
      require('mrgeek.plugins.dashboard')
    end,
    setup = function()
      require('mrgeek.keymaps').dashboard()
    end,
  }

  use {
    'max397574/better-escape.nvim',
    event = 'InsertEnter',
    config = function()
      require('better_escape').setup {
        mapping = { 'jk' },
        timeout = 300,
      }
    end,
  }

  use {
    'norcalli/nvim-colorizer.lua',
    opt = true,
    event = 'BufRead',
    config = function()
      require 'colorizer'.setup()
    end
  }

  -- Git --
  use {
    'lewis6991/gitsigns.nvim',
    opt = true,
    config = function()
      require('mrgeek.plugins.gitsigns')
    end,
    setup = function()
      require('mrgeek.keymaps').git_signs()
      require('mrgeek.utils').packer_lazy_load 'gitsigns.nvim'
    end,
  }

  use {
    'tpope/vim-fugitive',
    opt = true,
    config = function()
    end,
    setup = function()
      require('mrgeek.keymaps').vim_fugitive()
      require('mrgeek.utils').packer_lazy_load 'vim-fugitive'
    end,
  }

  -- Color schemes --
  use 'folke/tokyonight.nvim' -- tokyonight theme yay
  use {
    'projekt0n/github-nvim-theme',
  }

  -- File managing plugins --
  use {
    'kyazdani42/nvim-tree.lua', -- the filemaneger basically
    requires = {
      'kyazdani42/nvim-web-devicons', -- optional, for file icon
    },
    cmd = { 'NvimTreeToggle', 'NvimTreeFocus' },
    config = function()
      require('mrgeek.plugins.nvimtree')
    end
  }

  use {
    'karb94/neoscroll.nvim', -- pretty smooth scrolling
    config = function()
      require('neoscroll').setup {

      }
    end,
  }

  use {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    config = function()
      require('mrgeek.telescope').setup()
    end,
    setup = function()
      require('mrgeek.keymaps').telescope()
    end,
  }

  -- LSP stuff --
  use {
    'neovim/nvim-lspconfig',
  }

  use {
    'williamboman/nvim-lsp-installer',
  }

  use {
    'jose-elias-alvarez/null-ls.nvim',
    after = 'nvim-lspconfig',
    config = function()
       require('mrgeek.plugins.null_ls')
    end,
  }

  use {
    'ray-x/lsp_signature.nvim',
    after = 'nvim-lspconfig',
    config = function()
      require('mrgeek.plugins.lsp_signature')
    end,
  }

  -- CMP and snippets plugins --
  use {
    'hrsh7th/cmp-nvim-lsp',
  }

  use {
    'rafamadriz/friendly-snippets',
  }

  use {
    'L3MON4D3/LuaSnip',
  }

  use {
    'hrsh7th/nvim-cmp',
    config = function()
      require('mrgeek.cmp').setup()
    end,
  }

  use {
    'saadparwaiz1/cmp_luasnip',
  }

  use {
    'hrsh7th/cmp-nvim-lua',
  }

  use {
    'hrsh7th/cmp-buffer',
  }

  use {
    'hrsh7th/cmp-path',
  }

  use {
    'hrsh7th/cmp-cmdline',
  }

  -- Experimental plugins --
  use 'nathom/filetype.nvim' -- better and more extensive filetypes list

  -- -- Packer stuff --
  -- -- automatically set up configuration after cloning packer
  -- -- this must be at the end of all plugins
  -- if PACKER_BOOTSTRAP then
  --   require 'packer'.sync()
  -- end
end)
