return {
	"AstroNvim/astrolsp",
	---@type AstroLSPOpts
	opts = {
		config = {
			-- the key is the server name to configure
			-- the value is the configuration table
			gopls = {
				settings = {
					gopls = {
						buildFlags = { "-tags=integration" },
						analyses = {
							shadow = false,
							-- fieldalignment = true,
						},
						gofumpt = false,
						hints = {
							assignVariableTypes = true,
							compositeLiteralFields = true,
							compositeLiteralTypes = true,
							constantValues = true,
							functionTypeParameters = true,
							parameterNames = true,
							rangeVariableTypes = true,
						},
					},
				},
			},
		},
	},
}
