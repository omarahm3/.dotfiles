return {
	"olimorris/codecompanion.nvim",
	enabled = true,
	config = function()
		require("codecompanion").setup({
			adapters = {
				copilot = function()
					return require("codecompanion.adapters").extend("ollama", {
						schema = {
							model = {
								default = "deepseek-r1:14b",
							},
						},
					})
				end,
			},
		})
	end,
	opts = {
		strategies = {
			chat = {
				adapter = "ollama",
			},
			inline = {
				adapter = "ollama",
			},
		},
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
}
