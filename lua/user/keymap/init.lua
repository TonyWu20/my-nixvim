-- User keymap overrides for the minimal config.
--
-- Return a table keyed by "<mode>|<lhs>":
--   * value = false or ""   -> remove the base keymap
--   * value = string / fn   -> replace the base keymap
--
-- The base maps live in lua/keymaps.lua. This file runs last, so its
-- entries win. Add per-scope files (editor, tool, ...) under this
-- directory to keep the override set small.

local overrides = {}

-- examples:
-- overrides["n|<leader>zz"] = ":Lazy update"
-- overrides["n|<leader>px"] = false

return overrides
