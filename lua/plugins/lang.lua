-- Language-specific plugins.

local lang = {}

lang["mrcjkb/rustaceanvim"] = {
	lazy = true,
	ft = "rust",
	init = require("configs.lang.rust"),
	dependencies = "nvim-lua/plenary.nvim",
}
lang["MeanderingProgrammer/render-markdown.nvim"] = {
	lazy = true,
	ft = "markdown",
	config = require("configs.lang.render-markdown"),
}

return lang
