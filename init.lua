-- my-nix-nvim: minimal Neovim configuration.
--
-- Structure:
--   lua/settings.lua    base settings (overridable in lua/user/settings.lua)
--   lua/options.lua     vim options
--   lua/plugins/        lazy.nvim specs (overridable in lua/user/plugins/)
--   lua/configs/        per-plugin setup functions
--   lua/keymaps.lua     keybindings (overridable in lua/user/keymap/)
--   lua/user/           your customization layer

-- ---------------------------------------------------------------------------
-- Paths
-- ---------------------------------------------------------------------------
vim.g.my_globals = {
	vim_path = vim.fn.stdpath("config"),
	home = os.getenv("HOME"),
	cache_dir = vim.fn.stdpath("cache"),
	data_dir = vim.fn.stdpath("data"),
}

-- Make sure cache directories exist
local createdir = function()
	local dirs = {
		vim.g.my_globals.cache_dir .. "/backup",
		vim.g.my_globals.cache_dir .. "/session",
		vim.g.my_globals.cache_dir .. "/swap",
		vim.g.my_globals.cache_dir .. "/tags",
		vim.g.my_globals.cache_dir .. "/undo",
	}
	if vim.fn.isdirectory(vim.g.my_globals.cache_dir) == 0 then
		vim.fn.mkdir(vim.g.my_globals.cache_dir, "p")
	end
	for _, dir in ipairs(dirs) do
		if vim.fn.isdirectory(dir) == 0 then
			vim.fn.mkdir(dir, "p")
		end
	end
end
createdir()

-- Leader
vim.g.mapleader = " "
vim.g.mapleader2 = "-"

-- ---------------------------------------------------------------------------
-- Options
-- ---------------------------------------------------------------------------
require("options").load()

-- ---------------------------------------------------------------------------
-- Settings (base + user overrides)
-- ---------------------------------------------------------------------------
local settings = require("utils").extend_config(require("settings"), "user.settings")
vim.g.my_settings = settings

-- ---------------------------------------------------------------------------
-- lazy.nvim bootstrap
-- ---------------------------------------------------------------------------
local lazy_path = vim.g.my_globals.data_dir .. "/lazy/lazy.nvim"
local use_ssh = settings.use_ssh
if not vim.uv.fs_stat(lazy_path) then
	vim.fn.mkdir(vim.g.my_globals.data_dir .. "/lazy", "p")
	local lazy_repo = use_ssh
		and "git@github.com:folke/lazy.nvim.git"
		or "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazy_repo, lazy_path })
end
vim.opt.rtp:prepend(lazy_path)

local lazy_settings = {
	root = vim.g.my_globals.data_dir .. "/lazy",
	git = {
		url_format = use_ssh and "git@github.com:%s.git" or "https://github.com/%s.git",
	},
	install = {
		missing = true,
		colorscheme = { settings.colorscheme },
	},
	ui = {
		size = { width = 0.88, height = 0.8 },
		border = "rounded",
	},
	performance = {
		cache = {
			enabled = true,
			path = vim.fn.stdpath("cache") .. "/lazy/cache",
			ttl = 3600 * 24 * 2,
		},
	},
}

local spec = require("plugins")
require("lazy").setup(spec, lazy_settings)

-- ---------------------------------------------------------------------------
-- Keymaps
-- ---------------------------------------------------------------------------
require("keymaps")
