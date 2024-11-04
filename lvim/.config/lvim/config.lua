local isRosePine, rosePine = pcall(require, 'rose-pine')

if isRosePine then
  rosePine.setup({
    dark_variant = 'moon',
  })
end

local options = {
  cmdheight = 1, -- more space to neovim command line to display messages
  -- clipboard = "unnamedplus", -- allows neovim to access system clipboard
  -- completeopt = { "menuone", "noselect" }, -- mostly just for cmp
  -- conceallevel = 0, -- so that `` is visible on markdown
  -- fileencoding = "utf-8", -- the encoding written to file
  hlsearch = true,           -- highlight all matches on previous search pattern
  ignorecase = true,         -- ignore case while searching
  mouse = "a",               -- disable mouse mode to be used in vim
  pumheight = 10,            -- pop up menu height
  showmode = false,          -- dont show stuff like INSERT anymore
  showtabline = 2,           -- always show tabs
  smartcase = true,          -- override the 'ignorecase' option if the search pattern contains upper case characters
  smartindent = true,        -- do smart autoindenting when starting a new line
  splitbelow = true,         -- force all horizontal splits to go below current window
  splitright = true,         -- force all vertical splits to go right of the current window
  swapfile = true,           -- creates swap file
  termguicolors = true,      -- set term gui colors
  timeoutlen = 200,          -- time to wait for a mapped sequence to complete (ms)
  undofile = true,           -- enable persistent undo
  updatetime = 30,           -- faster completion (4000ms default)
  writebackup = false,       -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
  expandtab = true,          -- convert tabs to spaces
  shiftwidth = 2,            -- number of spaces inserted to each indentation
  tabstop = 2,               -- insert 2 spaces for a tab
  cursorline = true,         -- enable highlighting current line
  number = true,             -- enable line numbers
  relativenumber = true,     -- disable relative numbers
  numberwidth = 2,           -- set number column width to 2 {default 4}
  signcolumn = "yes",        -- always show sign column otherwise it will shift text every time
  wrap = false,              -- disable text wrap and show it as 1 line
  scrolloff = 8,             -- minimal number of screen lines to keep above and below the cursor
  sidescrolloff = 8,
  guifont = "monospace:h17", -- font used on neovim gui
  -- shadafile = "NONE",
}

local g_options = {
  tokyonight_style = "night", -- the main variant of tokyonight theme
  catppuccin_flavour = "macchiato",
  material_style = "oceanic", -- the main variant of material theme
  repl_filetype_commands = {
    python = "ipython --no-autoindent",
  },
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
vim.g.material_style = "deep ocean"

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"

vim.g.repl_filetype_commands = {
  python = "ipython --no-autoindent",
  javascript = 'node',
}

local Job = require("plenary.job")

local function git_create_branch()
  vim.ui.input({
    prompt = "Branch Name: "
  }, function(input)
    if input == nil or input == "" then
      vim.schedule(function()
        vim.notify("Commit message cannot be empty")
      end)
      return
    end

    local cwd = vim.loop.cwd()
    if cwd == nil then
      vim.schedule(function()
        vim.notify('unknown working directory')
      end)
      return
    end

    Job:new({
      command = 'git',
      args = {
        'checkout',
        '-b',
        input
      },
      cwd = cwd,
      on_exit = function(j, return_val)
        if return_val ~= 0 then
          vim.schedule(function()
            vim.notify("Failed to create branch: " ..
              table.concat(j:stderr_result(), "\n") .. "\n" .. table.concat(j:result(), "\n"))
          end)
          return
        end
        vim.schedule(function()
          vim.notify("Created branch: " .. input)
        end)
      end
    }):start()
  end)
end

local function commit_push()
  vim.ui.input({
    prompt = "commit message: "
  }, function(input)
    if input == nil or input == "" then
      vim.schedule(function()
        vim.notify("Commit message cannot be empty")
      end)
      return
    end

    local cwd = vim.loop.cwd()

    if cwd == nil then
      vim.schedule(function()
        vim.notify('unknown working directory')
      end)
      return
    end

    Job:new({
      command = 'git',
      args = {
        'commit',
        '-m',
        input,
        cwd = cwd,
      },
      on_exit = function(commit_job, commit_return_val)
        if commit_return_val ~= 0 then
          vim.schedule(function()
            vim.notify("Failed to commit changes: " .. table.concat(commit_job:stderr_result(), "\n"))
          end)
          return
        end

        Job:new({
          command = 'git',
          args = {
            'push'
          },
          cwd = cwd,
          on_exit = function(push_job, push_return_val)
            if push_return_val ~= 0 then
              vim.schedule(function()
                vim.notify("Failed to push changes: " ..
                  table.concat(push_job:stderr_result(), "\n") .. "\n" .. table.concat(push_job:result(), "\n"))
              end)
              return
            end

            vim.schedule(function()
              vim.cmd('Git')
              vim.notify("Changes committed and pushed")
            end)
          end
        }):start()
      end
    }):start()
  end)
end

-- add your own keymapping
local git_mappings = lvim.builtin.which_key.mappings["g"]
local find_mappings = lvim.builtin.which_key.mappings["s"]
local telescope_mappings = lvim.builtin.which_key.mappings["l"]

local mappings = {
  globalNormal = {
    ["<C-q>"] = { ":wqall<CR>", "Close nvim" },
    ["<ESC>"] = { ":noh<CR>", "No highlight" },
    ["<S-L>"] = { ":BufferLineCycleNext<CR>", "Next" },
    ["<S-H>"] = { ":BufferLineCyclePrev<CR>", "Previous" },
    ["<C-p>"] = { ":Telescope find_files<CR>", "Find file" },
    ["<C-f>"] = { ":silent !tmux neww tmux-sessionizer<CR>", "Find project" },
  },
  vGlobalMappings = {
    ["<S-Tab>"] = { "<gv", "Indent left" },
    ["<Tab>"] = { ">gv", "Indent right" },
    ["p"] = { '"_dP', "Keep what you are pasting in the clipboard register" },
  },
  normal = {
    ["u"] = { ':UndotreeToggle<CR>', "Undo tree" },
    ["x"] = { ':BufferKill<CR>', "Close current buffer" },
    ["bd"] = { ':BufferKill<CR>', "Close current buffer" },
    ["c"] = { ':silent !chmod +x %<CR>', "Chmowd" },
    ["f"] = vim.tbl_deep_extend("force", find_mappings, {
      w = { ":Telescope live_grep<CR>", "Text" },
      F = { function() require("telescope.builtin").find_files { hidden = true, no_ignore = true } end,
        "Search all files" },
      b = { ":Telescope file_browser<CR>", "File Browser" },
      t = {},
    }),
    ["g"] = vim.tbl_deep_extend("force", git_mappings, {
      h = git_mappings.s,
      s = { ":G<CR>", "Status" },
      b = { git_create_branch, "Create new branch" },
      P = { commit_push, "Push with message" },
    }),
    ["zR"] = { ":lua require('ufo').openAllFolds", "open all folds" },
    ["zM"] = { ":lua require('ufo').closeAllFolds", "close all folds" },
    ["l"] = vim.tbl_deep_extend("force", telescope_mappings, {
      w = {
        ["l"] = { ":lua require('telescope').extensions.git_worktree.git_worktrees()<CR>", "List Worktree" },
        ["a"] = { ":lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>", "Create Worktree" }
      },
      W = { ":Telescope diagnostics<cr>", "Diagnostics" }
    }),
    ["h"] = {
      ["a"] = { ":lua require('harpoon.mark').add_file()<CR>", "Add file" },
      ["e"] = { ":lua require('harpoon.ui').toggle_quick_menu()<CR>", "Quick Menu" },
      ["t"] = { ":lua require('harpoon.ui').nav_file(1)<CR>", "Go to file 1" },
      ["h"] = { ":lua require('harpoon.ui').nav_file(2)<CR>", "Go to file 2" },
      ["j"] = { ":lua require('harpoon.ui').nav_file(3)<CR>", "Go to file 3" },
      ["n"] = { ":lua require('harpoon.ui').nav_file(4)<CR>", "Go to file 4" },
    },
    ["s"] = {
      ["S"] = { ":lua require('spectre').open()<CR>", "Open Spectre" },
      ["w"] = { ":lua require('spectre').open_visual({select_word=true})<CR>", "Search current word" },
      ["f"] = { "viw:lua require('spectre').open_file_search()<CR>", "Search current file" },
    }
  },
}

lvim.lsp.buffer_mappings.normal_mode['gk'] = { "<cmd>Lspsaga diagnostic_jump_prev<cr>", "Previous diagnostic" }
lvim.lsp.buffer_mappings.normal_mode['gj'] = { "<cmd>Lspsaga diagnostic_jump_next<cr>", "Next diagnostic" }
lvim.lsp.buffer_mappings.normal_mode['gp'] = { "<cmd>Lspsaga peek_definition<cr>", "Peek definition" }
lvim.lsp.buffer_mappings.normal_mode['gf'] = { "<cmd>Lspsaga finder<cr>", "Finder" }
lvim.lsp.buffer_mappings.normal_mode['go'] = { "<cmd>Lspsaga outline<cr>", "Outline" }

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

local isWorktree = pcall(require, 'git-worktree')

if isWorktree then
  require("telescope").load_extension("git_worktree")
end

lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = true

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

vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pyright", "yamlls" })
local opts = {
  cmd = { "pyright-langserver", "--stdio", "--generate-members" },
  filetypes = { "python" },
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "off"
      }
    }
  },
}
require("lvim.lsp.manager").setup("pyright", opts)


local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

require("lvim.lsp.manager").setup("yamlls", {
  capabilities = capabilities,
})

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { command = "black", filetypes = { "python" } },
  { command = "isort", filetypes = { "python" } },
  {
    command = "prettier",
    extra_args = { "--print-with", "100" },
    filetypes = { "typescript", "typescriptreact" },
  },
  {
    command = "shfmt",
  },
}

local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  {
    command = "shellcheck",
    extra_args = { "--severity", "warning" },
  },
}

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
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    config = [[ require("ufo").setup() ]],
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
  { 'rose-pine/neovim', name = 'rose-pine' },
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
  },
  {
    'nvimdev/lspsaga.nvim',
    config = function()
      require('lspsaga').setup({
        ui = {
          code_action = ''
        }
      })
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter', -- optional
      'nvim-tree/nvim-web-devicons'      -- optional
    }
  },
  {
    "Mofiqul/dracula.nvim"
  },
  {
    "Vigemus/iron.nvim",
    ft = "python",
    keys = {
      { "<leader>rt", "<cmd>ReplToggle<cr>",  desc = "Toggle nvim-repl" },
      { "<leader>rc", "<cmd>ReplRunCell<cr>", desc = "nvim-repl run cell" },
      { "<leader>rr", "<cmd>ReplClear<cr>",   desc = "nvim-repl clear" },
    },
  },
  {
    "OXY2DEV/markview.nvim",
    lazy = false, -- Recommended
    -- ft = "markdown" -- If you decide to lazy-load anyway

    dependencies = {
      -- You will not need this if you installed the
      -- parsers manually
      -- Or if the parsers are in your $RUNTIMEPATH
      "nvim-treesitter/nvim-treesitter",

      "nvim-tree/nvim-web-devicons"
    }
  },
  {
    -- Make sure to setup it properly if you have lazy=true
    'MeanderingProgrammer/render-markdown.nvim',
    opts = {
      file_types = { "markdown", "Avante" },
    },
    ft = { "markdown", "Avante" },
  },
  {
    'linux-cultist/venv-selector.nvim',
    dependencies = {
      "neovim/nvim-lspconfig",
      "mfussenegger/nvim-dap", "mfussenegger/nvim-dap-python", --optional
      { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
    },
    opts = {
      name = ".venv",
      auto_refresh = true,
    },
    lazy = false,
    branch = "regexp",
    keys = {
      { '<leader>vs', '<cmd>VenvSelect<cr>' },
    },
  },
  -- {
  --   "yetone/avante.nvim",
  --   event = "VeryLazy",
  --   lazy = false,
  --   opts = {
  --     provider = "ollama",
  --     vendors = {
  --       ollama = {
  --         ["local"] = true,
  --         endpoint = "localhost:11434/v1",
  --         model = "deepseek-coder:33b",
  --         parse_curl_args = function(opts, code_opts)
  --           return {
  --             url = opts.endpoint .. "/chat/completions",
  --             headers = {
  --               ["Accept"] = "application/json",
  --               ["Content-Type"] = "application/json",
  --             },
  --             body = {
  --               model = opts.model,
  --               messages = require("avante.providers").copilot.parse_message(code_opts), -- you can make your own message, but this is very advanced
  --               max_tokens = 2048,
  --               stream = true,
  --             },
  --           }
  --         end,
  --         parse_response_data = function(data_stream, event_state, opts)
  --           require("avante.providers").openai.parse_response(data_stream, event_state, opts)
  --         end,
  --       },
  --     }
  --   },
  --   keys = {
  --     { "<leader>aa", function() require("avante.api").ask() end,     desc = "avante: ask",    mode = { "n", "v" } },
  --     { "<leader>ar", function() require("avante.api").refresh() end, desc = "avante: refresh" },
  --     { "<leader>ae", function() require("avante.api").edit() end,    desc = "avante: edit",   mode = "v" },
  --   },
  --   dependencies = {
  --     "stevearc/dressing.nvim",
  --     "nvim-lua/plenary.nvim",
  --     "MunifTanjim/nui.nvim",
  --     --- The below dependencies are optional,
  --     "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
  --     "zbirenbaum/copilot.lua",      -- for providers='copilot'
  --     {
  --       -- support for image pasting
  --       "HakonHarnes/img-clip.nvim",
  --       event = "VeryLazy",
  --       opts = {
  --         -- recommended settings
  --         default = {
  --           embed_image_as_base64 = false,
  --           prompt_for_file_name = false,
  --           drag_and_drop = {
  --             insert_mode = true,
  --           },
  --           -- required for Windows users
  --           use_absolute_path = true,
  --         },
  --       },
  --     },
  --   },
  -- }
}

lvim.builtin.dap.active = true
local dap = require("dap")

dap.adapters.go = function(callback, _)
  local stdout = vim.loop.new_pipe(false)
  local handle
  local pid_or_err
  local port = 38697
  local opts = {
    stdio = { nil, stdout },
    args = { "dap", "-l", "127.0.0.1:" .. port },
    detached = true,
  }
  handle, pid_or_err = vim.loop.spawn("dlv", opts, function(code)
    stdout:close()
    handle:close()
    if code ~= 0 then
      print("dlv exited with code", code)
    end
  end)
  assert(handle, "Error running dlv: " .. tostring(pid_or_err))
  stdout:read_start(function(err, chunk)
    assert(not err, err)
    if chunk then
      vim.schedule(function()
        require("dap.repl").append(chunk)
      end)
    end
  end)
  -- Wait for delve to start
  vim.defer_fn(function()
    callback { type = "server", host = "127.0.0.1", port = port }
  end, 100)
end
-- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
dap.configurations.go = {
  {
    type = "go",
    name = "Debug",
    request = "launch",
    program = "${file}",
  },
  {
    type = "go",
    name = "Debug test", -- configuration for debugging test files
    request = "launch",
    mode = "test",
    program = "${file}",
  },
  -- works with go.mod packages and sub packages
  {
    type = "go",
    name = "Debug test (go.mod)",
    request = "launch",
    mode = "test",
    program = "./${relativeFileDirname}",
  },
}

local function GoPrettyTag()
  local filename = vim.fn.expand('%')
  local command = 'formattag -file ' .. vim.fn.shellescape(filename)
  vim.fn.system(command)
  vim.cmd('silent! write!')
end

vim.api.nvim_create_user_command('PrettyTag', GoPrettyTag, { nargs = 0 })
vim.api.nvim_create_autocmd({ "BufWritePost", "FileWritePost" }, {
  pattern = "*.go",
  callback = GoPrettyTag,
})
