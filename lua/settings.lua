-- Base settings. Override in lua/user/settings.lua.
-- A value may be a function: it is called with the base value and its
-- return value replaces the base (used to extend lists like lsp_deps).

local settings = {}

-- Use HTTPS to update plugins and Treesitter parsers.
---@type boolean
settings.use_ssh = false

-- colorscheme: "catppuccin" | "catppuccin-latte" | "catppuccin-frappe"
-- | "catppuccin-macchiato" | "catppuccin-mocha"
settings.colorscheme = "catppuccin-macchiato"

-- Set to true if your terminal supports a transparent background.
settings.transparent_background = false

-- Set to false if you do not want format on save.
settings.format_on_save = true

-- Format timeout in milliseconds.
settings.format_timeout = 1000

-- Set to false to disable format notification.
settings.format_notify = true

-- Filetypes in this list will skip LSP formatting if the value is true.
settings.formatter_block_list = {}

-- Servers in this list will skip formatting capabilities if the value is true.
settings.server_formatting_block_list = {
	clangd = true,
	lua_ls = true,
	ts_ls = true,
}

-- LSP servers to install via mason-lspconfig at setup.
settings.lsp_deps = {
	"bashls",
	"jsonls",
	"lua_ls",
}

-- None-ls formatters to install via mason-null-ls at setup.
settings.null_ls_deps = {
	"shfmt",
	"stylua",
}

-- Workspace directories in this list will skip format-on-save.
settings.format_disabled_dirs = {}

-- Treesitter parsers to install at setup.
settings.treesitter_parsers = {
	"lua",
	"markdown",
	"markdown_inline",
	"vim",
	"vimdoc",
}

-- The ASCII art shown on the alpha splash screen.
settings.dashboard_image = {
	[[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
	[[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
	[[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
}

return settings
