-- Native blink.cmp source that provides LaTeX symbol completion.
--
-- Replaces the old nvim-cmp `cmp-latex-symbols` bridge: it serves the same
-- symbol data (vendored from kdheepak/cmp-latex-symbols) without requiring
-- nvim-cmp to be installed. The data lives in completion/latex_symbols_data.lua.
-- The provider is wired up in configs/completion/blink.lua via
-- `module = "configs.completion.latex_symbols"`.

local Kind = require("blink.cmp.types").CompletionItemKind

--- Lazily load the (large) symbol table on first use.
local items_cache

local function get_items()
	if items_cache == nil then
		items_cache = require("completion.latex_symbols_data")
	end
	return items_cache
end

local Source = {}
Source.__index = Source

---@param _opts table|nil
---@param config any
---@return table
function Source.new(_opts, config)
	local self = setmetatable({}, { __index = Source })
	self.opts = (config and config.opts) or {}
	return self
end

--- Only active in LaTeX-family filetypes, so backslashes in other buffers
--- do not surface 4,900+ symbols.
function Source:enabled()
	local ft = vim.bo.filetype
	return ft == "latex" or ft == "tex" or ft == "pandoc" or ft == "tex_noweb"
end

--- Trigger on a backslash.
function Source:get_trigger_characters()
	return { "\\" }
end

--- A backslash followed by non-whitespace (the in-progress symbol name).
function Source:get_keyword_pattern()
	return "\\\\[^[:blank:]]*"
end

---@param _context any
---@param callback fun(items: table[])
function Source:get_completions(_context, callback)
	local raw = get_items()
	local items = {}
	for _, it in ipairs(raw) do
		table.insert(items, {
			label = it.label or it.word,
			insertText = it.insertText or it.word,
			insertTextFormat = vim.lsp.protocol.InsertTextFormat.PlainText,
			kind = Kind.Constant,
		})
	end
	callback(items)
end

return Source
