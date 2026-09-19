-- Editing plugins: treesitter stack, commenting, quick jump, and quality-of-life.

local editor = {}

editor["m4xshen/autoclose.nvim"] = {
	lazy = true,
	event = "InsertEnter",
	config = require("configs.editor.autoclose"),
}
editor["pteroctopus/faster.nvim"] = {
	lazy = false,
	config = require("configs.editor.faster"),
}
editor["ojroques/nvim-bufdel"] = {
	lazy = true,
	cmd = { "BufDel", "BufDelAll", "BufDelOthers" },
}
editor["folke/flash.nvim"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	config = require("configs.editor.flash"),
}
editor["numToStr/Comment.nvim"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	config = require("configs.editor.comment"),
}
editor["echasnovski/mini.cursorword"] = {
	lazy = true,
	event = { "BufReadPost", "BufAdd", "BufNewFile" },
	config = require("configs.editor.cursorword"),
}
editor["lambdalisue/suda.vim"] = {
	lazy = true,
	cmd = { "SudaRead", "SudaWrite" },
	init = require("configs.editor.suda"),
}

----------------------------------------------------------------------
--                       Treesitter stack                          --
----------------------------------------------------------------------
editor["nvim-treesitter/nvim-treesitter"] = {
	lazy = false,
	branch = "main",
	build = function()
		if #vim.api.nvim_list_uis() > 0 then
			vim.api.nvim_command([[TSUpdate]])
		end
	end,
	init = require("configs.editor.treesitter").init,
	config = require("configs.editor.treesitter").setup,
	dependencies = {
		{ "mfussenegger/nvim-treehopper" },
		{
			"nvim-treesitter/nvim-treesitter-textobjects",
			branch = "main",
			config = require("configs.editor.ts-textobjects"),
		},
		{
			"andymass/vim-matchup",
			init = require("configs.editor.matchup"),
		},
		{
			"windwp/nvim-ts-autotag",
			config = require("configs.editor.autotag"),
		},
		{
			"hiphish/rainbow-delimiters.nvim",
			submodules = false,
			config = require("configs.editor.rainbow_delims"),
		},
		{
			"nvim-treesitter/nvim-treesitter-context",
			config = require("configs.editor.ts-context"),
		},
	},
}

return editor
