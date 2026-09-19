-- User overrides for lua/settings.lua.
-- A value may be a function: it is called with the base value and its
-- return value replaces the base (used to extend lists like lsp_deps).

local settings = {}

-- Use HTTPS to update plugins and Treesitter parsers.
settings.use_ssh = false

settings.colorscheme = "catppuccin-macchiato"

settings.format_timeout = 8000

-- Treesitter parsers to install at setup.
settings.treesitter_parsers = {
	"lua",
	"python",
	"rust",
	"latex",
	"markdown",
	"markdown_inline",
	"fortran",
}

-- LSP servers to install via mason-lspconfig at setup.
settings.lsp_deps = function(_default)
	return {
		"bashls",
		"jsonls",
		"lua_ls",
		"pylsp",
		"fish_lsp",
		"tinymist",
	}
end

-- None-ls formatters to install via mason-null-ls at setup.
settings.null_ls_deps = function(_default)
	return {
		"clang_format",
		"prettier",
		"shfmt",
		"stylua",
		"vint",
	}
end

return settings
