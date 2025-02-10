return {
	{
		"kylechui/nvim-surround",
		event = "InsertEnter",
		config = function()
			require("nvim-surround").setup({
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
		end,
	},
}
