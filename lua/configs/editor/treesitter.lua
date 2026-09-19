-- Treesitter: the parser install list comes from settings.treesitter_parsers.

local M = {}

--- Runs before the plugin loads (lazy `init` hook).
function M.init()
	-- Use treesitter highlighting and indent expr on every filetype buffer
	vim.api.nvim_create_autocmd("FileType", {
		callback = function()
			-- Enable treesitter highlighting and disable regex syntax
			pcall(vim.treesitter.start)
			-- Enable treesitter-based indentation
			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end,
	})

	local want = vim.g.my_settings.treesitter_parsers or {}
	if #want == 0 then
		return
	end
	local ok, installed = pcall(function()
		return require("nvim-treesitter.config").get_installed()
	end)
	if not ok then
		return
	end
	local to_install = vim.iter(want)
		:filter(function(parser)
			return not vim.tbl_contains(installed, parser)
		end)
		:totable()
	if #to_install > 0 then
		pcall(require("nvim-treesitter").install, to_install)
	end
end

--- Runs after the plugin loads (lazy `config` hook).
function M.setup()
	require("utils").load_plugin("nvim-treesitter", {})
end

return M
