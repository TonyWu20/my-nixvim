-- Shared helpers.

local M = {}

---Call a plugin's setup function.
---@param name string
---@param opts? table
---Load a plugin's setup function with graceful degradation.
---@param name string @Plugin module name
---@param opts? table @Options passed to setup()
---@param vim_plugin? boolean @Set for plugin-file-driven plugins (vimscript
---or `plugin/*.lua`) that configure themselves via `vim.g.*` and ship no
---Lua setup() to call. Skips the setup call entirely.
function M.load_plugin(name, opts, vim_plugin)
	if vim_plugin then
		-- The plugin's plugin/ file is sourced automatically by lazy and
		-- reads vim.g.*; there is nothing to call from here.
		return
	end
	local ok, err = pcall(function()
		local mod = require(name)
		if type(mod) ~= "table" or mod.setup == nil then
			print(string.format("%s has no setup(); assuming it self-configures", name))
			return
		end
		mod.setup(opts or {})
	end)
	if not ok then
		print(string.format("Cannot load %s: %s", name, err))
	end
end

---Get the LSP client capabilities.
---@return table
function M.get_lsp_capabilities()
	local base = vim.lsp.protocol.make_client_capabilities()
	local ok, blink_caps = pcall(function()
		return require("blink.cmp").get_lsp_capabilities({}, false)
	end)
	if ok then
		return vim.tbl_deep_extend("force", base, blink_caps)
	end
	return base
end

---Register an LSP server and enable it.
---@param name string
---@param config? table
function M.register_server(name, config)
	if config then
		vim.lsp.config(name, config)
	end
	vim.lsp.enable(name)
end

---Recursively merge `src` into `dst` (the nvimdots merge semantics).
--- A user function value is called with the base table and its return
--- replaces it. A user list extends a base list (except dashboard_image).
--- Nested dicts merge recursively; scalars replace.
local function tbl_recursive_merge(dst, src)
	for key, value in pairs(src) do
		if type(dst[key]) == "table" and type(value) == "function" then
			dst[key] = value(dst[key])
		elseif type(dst[key]) == "table" and vim.islist(dst[key]) and key ~= "dashboard_image" then
			vim.list_extend(dst[key], value)
		elseif type(dst[key]) == "table" and type(value) == "table" and not vim.islist(dst[key]) then
			tbl_recursive_merge(dst[key], value)
		else
			dst[key] = value
		end
	end
	return dst
end

---Merge the user module named `user` (a `require` path) into `base`.
---@param base table
---@param user? string
---@return table
function M.extend_config(base, user)
	if user == nil then
		return base
	end
	local ok, extras = pcall(require, user)
	if ok and type(extras) == "table" then
		base = tbl_recursive_merge(base, extras)
	elseif not ok and type(extras) == "string" and not tostring(extras):find("module .* not found") then
		vim.notify(
			string.format("[utils] Error loading %s: %s", user, extras),
			vim.log.levels.ERROR,
			{ title = "[utils] Runtime Error" }
		)
	end
	return base
end

---Get the catppuccin palette, falling back to a hardcoded set.
---@return table
function M.get_palette()
	local ok, palette = pcall(function()
		return require("catppuccin.palettes").get_palette("macchiato")
	end)
	if ok then
		return palette
	end
	-- Fallback palette (macchiato)
	return {
		rosewater = "#f5e0dc",
		red = "#f38f8b",
		orange = "#fee7ca",
		green = "#a7f2b0",
		teal = "#94e4d8",
		blue = "#939fe2",
		sapphire = "#81c5d7",
		sky = "#8bd5ca",
		lavender = "#b7bdf0",
		text = "#cad3f5",
		subtext1 = "#91a1c7",
		subtext0 = "#78858f",
		overlay2 = "#7287cd",
		overlay1 = "#89dceb",
		overlay0 = "#96e2d4",
		surface2 = "#b0b9ea",
		surface1 = "#a3abc3",
		surface0 = "#9aa3e0",
		base = "#0e1428",
		mantle = "#111827",
		crust = "#0d121f",
	}
end

---Darken a hex color.
---@param color string
---@param percent number
---@return string
function M.darken(color, percent)
	local r = tonumber(color:sub(2, 3), 16)
	local g = tonumber(color:sub(4, 5), 16)
	local b = tonumber(color:sub(6, 7), 16)
	local factor = (100 - percent) / 100
	r = math.floor(r * factor)
	g = math.floor(g * factor)
	b = math.floor(b * factor)
	local function to_hex(v)
		return string.format("%02x", v)
	end
	return string.format("#%s%s%s", to_hex(r), to_hex(g), to_hex(b))
end

---Lighten a hex color.
---@param color string
---@param percent number
---@return string
function M.lighten(color, percent)
	local r = tonumber(color:sub(2, 3), 16)
	local g = tonumber(color:sub(4, 5), 16)
	local b = tonumber(color:sub(6, 7), 16)
	local factor = (100 + percent) / 100
	local function mix(c)
		c = math.min(255, math.floor(c + (255 - c) * factor))
		return c
	end
	local function to_hex(v)
		return string.format("%02x", v)
	end
	return string.format("#%s%s%s", to_hex(mix(r)), to_hex(mix(g)), to_hex(mix(b)))
end

---Generate highlight groups for alpha.
---@return function
function M.gen_alpha_hl()
	local color = require("utils").get_palette().rosewater
	local darker_color = require("utils").darken(color, 25)
	return function(hl, name, color_)
		color_ = color_ or color
		vim.api.nvim_set_hl(0, hl, { fg = color_, blend = 75 })
		vim.api.nvim_set_hl(0, "Default" .. name, { fg = color_ })
		vim.api.nvim_set_hl(0, "Alpha" .. name, { fg = darker_color })
	end
end

---Generate highlight groups for mini.cursorword.
---@return function
function M.gen_cursorword_hl()
	local color = require("utils").get_palette().rosewater
	local darker_color = require("utils").darken(color, 25)
	return function(hl, name, color_)
		color_ = color_ or color
		vim.api.nvim_set_hl(0, hl, { bg = color_ })
		vim.api.nvim_set_hl(0, "Default" .. name, { bg = color_ })
		vim.api.nvim_set_hl(0, "Alpha" .. name, { bg = darker_color })
	end
end

---Set a global highlight group.
---@param name string
---@param attrs table
function M.set_global_hl(name, attrs)
	vim.api.nvim_set_hl(0, name, attrs)
end

return M
