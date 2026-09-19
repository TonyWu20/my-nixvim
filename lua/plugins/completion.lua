-- Completion and LSP tooling: mason, lspconfig, none-ls, and blink.cmp.

local completion = {}

completion["mason-org/mason.nvim"] = {
	lazy = true,
	cmd = {
		"Mason",
		"MasonInstall",
		"MasonUninstall",
		"MasonUninstallAll",
		"MasonUpdate",
		"MasonLog",
	},
	config = require("configs.completion.mason").setup,
}
completion["neovim/nvim-lspconfig"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	config = require("configs.completion.lsp"),
	dependencies = {
		{ "mason-org/mason.nvim" },
		{ "mason-org/mason-lspconfig.nvim" },
	},
}
completion["nvimtools/none-ls.nvim"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	config = require("configs.completion.null-ls"),
	dependencies = {
		"nvim-lua/plenary.nvim",
		"jay-babu/mason-null-ls.nvim",
	},
}
completion["saghen/blink.cmp"] = {
	lazy = true,
	version = "1.*",
	event = { "VeryLazy", "InsertEnter", "CmdlineEnter" },
	config = require("configs.completion.blink"),
	dependencies = {
		{ "mikavilpas/blink-ripgrep.nvim" },
		{ "xzbdmw/colorful-menu.nvim" },
	},
}
completion["folke/lazydev.nvim"] = {
	lazy = true,
	ft = "lua",
	config = require("configs.completion.lazydev"),
}

return completion
