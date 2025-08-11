-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

local Job = require("plenary.job")

local function get_snacks()
  if type(_G.Snacks) == "table" then
    return _G.Snacks
  end
  local ok, snacks = pcall(require, "snacks")
  if ok and type(snacks) == "table" then
    return snacks
  end
  return nil
end

-- Helper function to show notifications safely
local function show_notification(message, level)
  local snacks = get_snacks()
  if snacks and snacks.notifier then
    -- Try different possible API methods
    if snacks.notifier[level] then
      snacks.notifier[level](message)
    elseif snacks.notifier.notify then
      snacks.notifier.notify(message, { level = level })
    else
      vim.notify(message, vim.log.levels[level:upper()] or vim.log.levels.INFO)
    end
  else
    vim.notify(message, vim.log.levels[level:upper()] or vim.log.levels.INFO)
  end
end

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
	local snacks = get_snacks()
	
	-- Debug: Check if snacks is available
	if not snacks then
		vim.notify("Snacks not available, using fallback notifications", vim.log.levels.WARN)
	end
	
	vim.ui.input({
		prompt = "commit message: ",
	}, function(input)
		if input == nil or input == "" then
			vim.schedule(function()
				show_notification("Commit message cannot be empty", "error")
			end)
			return
		end

		local cwd = vim.loop.cwd()

		if cwd == nil then
			vim.schedule(function()
				show_notification("Unknown working directory", "error")
			end)
			return
		end

        -- Create a window to show the git operation progress
        local win_id = nil
        local buf_id = nil
        local commit_job_handle = nil
        local push_job_handle = nil
        
        -- Create a simple floating window (no snacks dependency for window creation)
        local buf = vim.api.nvim_create_buf(false, true)
        win_id = vim.api.nvim_open_win(buf, true, {
            relative = "editor",
            width = math.floor(vim.o.columns * 0.6),
            height = math.floor(vim.o.lines * 0.4),
            row = math.floor(vim.o.lines * 0.3),
            col = math.floor(vim.o.columns * 0.2),
            style = "minimal",
            border = "rounded",
        })
        buf_id = buf
        
        -- Set buffer options
        vim.bo[buf_id].modifiable = true
        vim.bo[buf_id].buftype = "nofile"
        vim.bo[buf_id].filetype = "git"
        vim.bo[buf_id].bufhidden = "wipe"
        vim.bo[buf_id].swapfile = false
        
        -- Set initial content
        local initial_lines = {
            "🔄 Starting git commit and push...",
            "",
            "📝 Commit message: " .. input,
            "📁 Working directory: " .. cwd,
            "",
            "⏳ Please wait...",
            "",
        }
        vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, initial_lines)
        vim.bo[buf_id].modifiable = false
        
        -- Function to append lines to the buffer
        local function append_lines(new_lines)
            if type(new_lines) == "string" then
                new_lines = { new_lines }
            end
            if not (buf_id and vim.api.nvim_buf_is_valid(buf_id)) then return end
            vim.bo[buf_id].modifiable = true
            vim.api.nvim_buf_set_lines(buf_id, -1, -1, false, new_lines)
            vim.bo[buf_id].modifiable = false
        end
		
        -- Ensure window is visible and has content
        vim.schedule(function()
          if win_id and buf_id and vim.api.nvim_win_is_valid(win_id) then
            vim.api.nvim_win_set_cursor(win_id, { 1, 0 })
            vim.cmd("redraw!")
          else
            show_notification("Failed to create window or window is invalid", "error")
          end
        end)

        -- q / :q to cancel running jobs and close
        local function cancel_jobs_and_close()
          local function try_shutdown(job)
            if job and type(job.shutdown) == "function" then
              pcall(function() job:shutdown() end)
            elseif job and type(job.kill) == "function" then
              pcall(function() job:kill() end)
            end
          end
          try_shutdown(commit_job_handle)
          try_shutdown(push_job_handle)
          if win_id and vim.api.nvim_win_is_valid(win_id) then
            vim.api.nvim_win_close(win_id, true)
          end
        end
        if buf_id and vim.api.nvim_buf_is_valid(buf_id) then
          vim.keymap.set("n", "q", cancel_jobs_and_close, { buffer = buf_id, nowait = true, silent = true, desc = "Close" })
          vim.api.nvim_create_autocmd({ "BufWinLeave", "WinClosed" }, {
            once = true,
            callback = function()
              cancel_jobs_and_close()
            end,
            buffer = buf_id,
          })
        end

		-- Function to update the window content
		local function update_window(content)
			if win_id and buf_id and vim.api.nvim_win_is_valid(win_id) then
				vim.api.nvim_buf_set_option(buf_id, "modifiable", true)
				vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, content)
				vim.api.nvim_buf_set_option(buf_id, "modifiable", false)
			end
		end

		-- Function to close the window
		local function close_window()
			if win_id and vim.api.nvim_win_is_valid(win_id) then
				vim.api.nvim_win_close(win_id, true)
			end
		end

        commit_job_handle = Job:new({
			command = "git",
			args = {
				"commit",
				"-m",
				input,
			},
			cwd = cwd,
          on_stdout = function(_, data)
            if data and data ~= "" then
              vim.schedule(function()
                append_lines(data)
              end)
            end
          end,
          on_stderr = function(_, data)
            if data and data ~= "" then
              vim.schedule(function()
                append_lines(data)
              end)
            end
          end,
			on_exit = function(commit_job, commit_return_val)
				if commit_return_val ~= 0 then
					local error_msg = "Failed to commit changes: " .. table.concat(commit_job:stderr_result(), "\n")
					
												vim.schedule(function()
								if snacks then
                  append_lines({
                    "",
                    "❌ Git Commit Failed",
                    "",
                    "🔍 Error details:",
                  })
                  append_lines(commit_job:stderr_result())
									show_notification("Git commit failed", "error")
								else
									vim.notify(error_msg)
									close_window()
								end
							end)
					return
				end

				-- Update window with commit success
				vim.schedule(function()
                              append_lines({ "", "✅ Git Commit Successful", "", "🚀 Pushing to remote..." })
				end)

            push_job_handle = Job:new({
					command = "git",
					args = {
						"push",
					},
					cwd = cwd,
              on_stdout = function(_, data)
                if data and data ~= "" then
                  vim.schedule(function()
                    append_lines(data)
                  end)
                end
              end,
              on_stderr = function(_, data)
                if data and data ~= "" then
                  vim.schedule(function()
                    append_lines(data)
                  end)
                end
              end,
					on_exit = function(push_job, push_return_val)
						if push_return_val ~= 0 then
							local error_msg = "Failed to push changes: " .. table.concat(push_job:stderr_result(), "\n")
							
							vim.schedule(function()
								if snacks then
                      append_lines({ "", "❌ Git Push Failed", "", "🔍 Error details:" })
                      append_lines(push_job:stderr_result())
									show_notification("Git push failed", "error")
								else
									vim.notify(error_msg)
									close_window()
								end
							end)
							return
						end

						vim.schedule(function()
							if snacks then
                    append_lines({ "", "🎉 Git Commit & Push Successful!", "", "✅ Changes committed and pushed to remote", "", "Press q to close" })
								show_notification("Changes committed and pushed successfully", "info")
							else
								vim.cmd("Git")
								vim.notify("Changes committed and pushed")
								close_window()
							end
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
