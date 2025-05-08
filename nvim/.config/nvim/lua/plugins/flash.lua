return {
	"folke/flash.nvim",
	event = "VeryLazy",
	opts = {
		labels = "asdfghjklqwertyuiopzxcvbnm", -- ergonomic label order
		search = {
			multi_window = true,               -- jump across windows
			wrap = true,                       -- wrap search at end of buffer
			mode = "exact",                    -- exact match mode
			incremental = false,               -- disable incsearch-style jump
			exclude = {
				"notify",
				"cmp_menu",
				"noice",
				"flash_prompt",
				function(win) -- exclude non-focusable windows
					return not vim.api.nvim_win_get_config(win).focusable
				end,
			},
		},
		modes = {
			search = { enabled = false }, -- don't auto-activate on `/` or `?`
			char = {
				enabled = true,
				jump_labels = true,
			},
		},
		highlight = {
			backdrop = false,
		},
		jump = {
			history = true,
			register = true,
			nohlsearch = true,
		},
	},
	keys = {
		-- Use <leader>s to trigger Flash jump
		{
			"f",
			mode = { "n", "x", "o" },
			function()
				require("flash").jump()
			end,
			desc = "Flash Jump",
		},
		-- Use <leader>S to trigger Treesitter jump
		{
			"F",
			mode = { "n", "x", "o" },
			function()
				require("flash").treesitter()
			end,
			desc = "Flash Treesitter",
		},
		-- (Optional) Add more mappings as needed
	},
}
