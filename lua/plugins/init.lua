-- Aggregate plugin specs from lua/plugins/ with overrides from
-- lua/user/plugins/.
--
-- Base files each return a dict: { plugin_key = spec_fields }. This module
-- converts them into lazy.nvim's spec list format:
--     { "owner/repo", key = value, ... }   (repo name at index 1)
--
-- Override rules (lua/user/plugins/*.lua use the same dict convention):
--   * A user spec for an existing base plugin deep-merges onto it
--     (user fields win; nested dicts merge; lists/functions replace).
--   * A user spec for a new plugin key adds a new entry.
--   * Setting a plugin key to `false` removes the base entry.
--   * A base spec file that fails to load is a hard error; a failing
--     user spec file is skipped with a warning.

local specs = {} -- hybrid lazy specs: [1] = plugin key, rest = fields

---Deep-merge `src` into `dst`. User fields win. Lists and non-tables
---replace; nested dicts merge recursively.
local function deep_merge(dst, src)
	for k, v in pairs(src) do
		if type(v) == "table" and type(dst[k]) == "table" and not vim.tbl_islist(v) then
			deep_merge(dst[k], v)
		else
			dst[k] = v
		end
	end
	return dst
end

---Build a hybrid spec entry: { plugin_key, [field]=value, ... }.
local function new_entry(key, conf)
	local t = { key }
	if type(conf) == "table" then
		for k, v in pairs(conf) do
			t[k] = v
		end
	end
	return t
end

---Find the index of the entry for `key` in the spec list.
local function find_entry(key)
	for i, t in ipairs(specs) do
		if t[1] == key then
			return i
		end
	end
	return nil
end

-- Base specs: part of the config, so a failure is a hard error.
local base_files = { "ui", "editor", "completion", "lang", "tool" }
for _, name in ipairs(base_files) do
	local ok, mod = pcall(require, "plugins." .. name)
	if not ok then
		error("plugins." .. name .. " failed to load: " .. tostring(mod), 0)
	end
	for key, conf in pairs(mod) do
		specs[#specs + 1] = new_entry(key, conf)
	end
end

-- List the *.lua files in a directory. Uses libuv fs_opendir + readdir
-- (one entry per call, nil to stop) rather than vim.fn.glob, because glob
-- does not expand patterns through symlinked directory components. The
-- home-manager deployment makes ~/.config/nvim/lua a symlink into the
-- store, so glob would silently find nothing there.
local function list_lua_files(dir)
	local ok, handle = pcall(vim.uv.fs_opendir, dir)
	if not ok then
		return {}
	end
	local out = {}
	while true do
		local entries = handle:readdir()
		if entries == nil then
			break
		end
		for _, entry in ipairs(entries) do
			if entry.name:match("%.lua$") then
				out[#out + 1] = dir .. "/" .. entry.name
			end
		end
	end
	table.sort(out)
	return out
end

-- User overrides: optional, failures are non-fatal.
local user_dir = vim.g.my_globals.vim_path .. "/lua/user/plugins"
local user_files = list_lua_files(user_dir)
for _, file in ipairs(user_files) do
	local name = vim.fn.fnamemodify(file, ":t:r")
	local ok, mod = pcall(require, "user.plugins." .. name)
	if not ok then
		vim.notify(
			string.format("[plugins] user spec %s not loaded: %s", name, tostring(mod)),
			vim.log.levels.WARN
		)
		goto continue
	end
	for key, conf in pairs(mod) do
		if conf == false then
			local i = find_entry(key)
			if i then
				table.remove(specs, i)
			end
		else
			local i = find_entry(key)
			if i then
				deep_merge(specs[i], conf)
			else
				specs[#specs + 1] = new_entry(key, conf)
			end
		end
	end
	::continue::
end

return specs