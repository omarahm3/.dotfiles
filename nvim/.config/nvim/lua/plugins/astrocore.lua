-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

local Job = require("plenary.job")

local function git_create_branch()
	vim.ui.input({
		prompt = "Branch Name: ",
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
				vim.notify("unknown working directory")
			end)
			return
		end

		Job:new({
			command = "git",
			args = {
				"checkout",
				"-b",
				input,
			},
			cwd = cwd,
			on_exit = function(j, return_val)
				if return_val ~= 0 then
					vim.schedule(function()
						vim.notify(
							"Failed to create branch: "
								.. table.concat(j:stderr_result(), "\n")
								.. "\n"
								.. table.concat(j:result(), "\n")
						)
					end)
					return
				end
				vim.schedule(function()
					vim.notify("Created branch: " .. input)
				end)
			end,
		}):start()
	end)
end

local function commit_push()
	vim.ui.input({
		prompt = "commit message: ",
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
				vim.notify("unknown working directory")
			end)
			return
		end

		Job:new({
			command = "git",
			args = {
				"commit",
				"-m",
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
					command = "git",
					args = {
						"push",
					},
					cwd = cwd,
					on_exit = function(push_job, push_return_val)
						if push_return_val ~= 0 then
							vim.schedule(function()
								vim.notify(
									"Failed to push changes: "
										.. table.concat(push_job:stderr_result(), "\n")
										.. "\n"
										.. table.concat(push_job:result(), "\n")
								)
							end)
							return
						end

						vim.schedule(function()
							vim.cmd("Git")
							vim.notify("Changes committed and pushed")
						end)
					end,
				}):start()
			end,
		}):start()
	end)
end

---@type LazySpec
return {
	"AstroNvim/astrocore",
	---@type AstroCoreOpts
	opts = {
		-- Configure core features of AstroNvim
		features = {
			large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
			autopairs = true, -- enable autopairs at start
			cmp = true, -- enable completion at start
			diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
			highlighturl = true, -- highlight URLs at start
			notifications = true, -- enable notifications at start
		},
		-- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
		diagnostics = {
			virtual_text = true,
			underline = true,
		},
		options = {
			opt = { -- vim.opt.<key>
				cmdheight = 1,
				hlsearch = true,
				ignorecase = true,
				mouse = "a",
				pumheight = 10,
				showmode = false,
				showtabline = 2,
				smartcase = true,
				smartindent = true,
				splitbelow = true,
				splitright = true,
				swapfile = true,
				termguicolors = true,
				timeoutlen = 200,
				undofile = true,
				updatetime = 30,
				writebackup = false,
				expandtab = true,
				shiftwidth = 2,
				tabstop = 2,
				cursorline = true,
				numberwidth = 2,
				scrolloff = 8,
				sidescrolloff = 8,
				relativenumber = true,
				number = true,
				spell = false,
				signcolumn = "yes",
				wrap = false,
			},
			g = { -- vim.g.<key>
				-- configure global vim variables (vim.g)
				-- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
				-- This can be found in the `lua/lazy_setup.lua` file
				tokyonight_style = "night",
				catppuccin_flavour = "macchiato",
				material_style = "deep ocean",
				repl_filetype_commands = {
					python = "ipython --no-autoindent",
				},
			},
		},
		mappings = {
			n = {
				["<S-L>"] = {
					function()
						require("astrocore.buffer").nav(vim.v.count1)
					end,
					desc = "Next buffer",
				},
				["<S-H>"] = {
					function()
						require("astrocore.buffer").nav(-vim.v.count1)
					end,
					desc = "Previous buffer",
				},
				["<C-p>"] = {
					function()
						require("telescope.builtin").find_files({ hidden = true, no_ignore = true })
					end,
					desc = "Find all files",
				},
				["<C-f>"] = { ":silent !tmux neww tmux-sessionizer<CR>", desc = "Find project" },
				["<Leader>u"] = { ":UndotreeToggle<CR>", desc = "Undo tree" },
				["<Leader>x"] = { ":bd<CR>", desc = "Close current buffer" },
				["<Leader>c"] = { ":silent !chmod +x %<CR>", desc = "Chmowd" },
				["<Leader>gb"] = { git_create_branch, desc = "Create new branch" },
				["<Leader>gP"] = { commit_push, desc = "Push with message" },

				-- mappings seen under group name "Buffer"
				["<Leader>bd"] = {
					function()
						require("astroui.status.heirline").buffer_picker(function(bufnr)
							require("astrocore.buffer").close(bufnr)
						end)
					end,
					desc = "Close buffer from tabline",
				},

				-- tables with just a `desc` key will be registered with which-key if it's installed
				-- this is useful for naming menus
				-- ["<Leader>b"] = { desc = "Buffers" },
			},
			v = {
				["<S-Tab>"] = { "<gv", desc = "Indent left" },
				["<Tab>"] = { ">gv", desc = "Indent right" },
				["p"] = { '"_dP', desc = "Keep what you are pasting in the clipboard register" },
			},
		},
	},
}
