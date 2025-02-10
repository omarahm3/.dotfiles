return {
  -- {
  --   'Exafunction/codeium.nvim',
  --   event = 'BufEnter',
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --   },
  --   config = function()
  --     vim.g.coeium_no_map_tab = 1
  --     vim.g.codeium_disable_bindings = 1

  --     vim.keymap.set('i', '<C-g>', function() return vim.fn['codeium#Accept']() end, { expr = true })
  --     vim.keymap.set('i', '<c-;>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true })
  --     vim.keymap.set('i', '<c-,>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true })
  --     vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end, { expr = true })
  --   end,
  --   keys = {
  --     { "<C-g>", function() return vim.fn['codeium#Accept']() end,             mode = "i", desc = "Codeium Accept" },
  --     { "<c-;>", function() return vim.fn['codeium#CycleCompletions'](1) end,  mode = "i", desc = "Codeium Cycle Completions" },
  --     { "<c-,>", function() return vim.fn['codeium#CycleCompletions'](-1) end, mode = "i", desc = "Codeium Cycle Completions" },
  --     { "<c-x>", function() return vim.fn['codeium#Clear']() end,              mode = "i", desc = "Codeium Clear" },
  --   },
  -- },
  {
    "Exafunction/codeium.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- "hrsh7th/nvim-cmp",
    },
    config = function()
      require("codeium").setup({
        virtual_text = {
          enabled = true,
          key_bindings = {
            accept = "<C-g>",
          },
        },
      })
    end,
  },
}
