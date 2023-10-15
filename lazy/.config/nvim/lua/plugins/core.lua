local _, actions = pcall(require, "telescope.actions")

return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    }
  },
  { "folke/flash.nvim", enabled = false },
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
    name = "catppuccin",
    config = function()
      require('catppuccin').setup({
        flavour = "mocha",
      })
    end
  },
  {
    "tpope/vim-fugitive",
  },
  {
    "kylechui/nvim-surround",
    event = "InsertEnter",
    config = function()
      require('nvim-surround').setup({
        keymaps = {
          -- vim-surround style keymaps
          -- insert = "ys",
          -- insert_line = "yss",
          visual = "S",
          delete = "ds",
          change = "cx",
        },
        highlight = { -- Highlight before inserting/changing surrounds
          duration = 0,
        },
      })
    end
  },
  {
    "stevearc/dressing.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    config = [[ require("dressing").setup({}) ]],
  },
  {
    "gbprod/cutlass.nvim",
    config = [[ require("cutlass").setup({}) ]],
  },
  {
    "j-hui/fidget.nvim",
    config = [[ require("fidget").setup({}) ]],
  },
  {
    "ThePrimeagen/git-worktree.nvim",
    config = [[ require("git-worktree").setup({}) ]],
  },
  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup {
        keywords = {
          FIX = {
            icon = " ", -- icon used for the sign, and in search results
            color = "error", -- can be a hex color, or a named color (see below)
            alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
            -- signs = false, -- configure signs for some keywords individually
          },
          TODO = { icon = " ", color = "info" },
          HACK = { icon = " ", color = "warning" },
          WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
          PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
          NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
          TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
        },
      }
    end
  },
  {
    'rose-pine/neovim',
    name = 'rose-pine',
  },
  {
    'ThePrimeagen/harpoon',
  },
  {
    'mbbill/undotree',
  },
  {
    'elkowar/yuck.vim'
  },
  {
    'Exafunction/codeium.vim',
    config = function()
      -- Change '<C-g>' here to any keycode you like.
      vim.keymap.set('i', '<C-g>', function() return vim.fn['codeium#Accept']() end, { expr = true })
      vim.keymap.set('i', '<c-;>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true })
      vim.keymap.set('i', '<c-,>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true })
      vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end, { expr = true })
    end
  },
  {
    "iamcco/markdown-preview.nvim",
    build = function() vim.fn["mkdp#util#install"]() end,
  },
  {
    "windwp/nvim-spectre",
  },
  {
    "marko-cerovac/material.nvim",
  },
  {
    "projekt0n/github-nvim-theme"
  },
  {
    "rebelot/kanagawa.nvim"
  },
  {
    "dnlhc/glance.nvim",
    config = function()
      require("glance").setup({})
    end
  },
  {
    "ray-x/go.nvim",
    dependencies = { -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup()
    end,
    event = { "CmdlineEnter" },
    ft = { "go", 'gomod' },
    build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
  },
  {
    'akinsho/git-conflict.nvim',
    version = "*",
    config = function()
      require('git-conflict').setup({
      })
    end,
  },
  {
    'simrat39/rust-tools.nvim'
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",
          "--glob=!.git/",
        },
        pickers = {
          find_files = {
            hidden = true,
          },
          live_grep = {
            --@usage don't include the filename in the search results
            only_sort_text = true,
          },
          grep_string = {
            only_sort_text = true,
          },
          buffers = {
            initial_mode = "normal",
            mappings = {
              i = {
                ["<C-d>"] = actions.delete_buffer,
              },
              n = {
                ["dd"] = actions.delete_buffer,
              },
            },
          },
          planets = {
            show_pluto = true,
            show_moon = true,
          },
          git_files = {
            hidden = true,
            show_untracked = true,
          },
          colorscheme = {
            enable_preview = true,
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
          },
        },
      },
    },
  },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim"
    },
  },
  {
    dir = "~/projects/pretty-ts-errors.nvim"
  },
  {
    "rafcamlet/nvim-luapad"
  }
}
