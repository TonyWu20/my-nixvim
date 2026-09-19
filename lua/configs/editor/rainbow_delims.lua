return function()
	---@param threshold number @Use global strategy if nr of lines exceeds this value
	---@return fun(bufnr: integer): table?
	local function init_strategy(threshold)
		-- The plugin's lib.attach calls this with the buffer number;
		-- return a strategy module, or nil to disable for this buffer.
		return function(bufnr)
			bufnr = bufnr or 0
			-- Disable on very large files
			local line_count = vim.api.nvim_buf_line_count(bufnr)
			if line_count > 15000 then
				return nil
			end

			-- Disable on parser error
			local parser = vim.treesitter.get_parser(bufnr)
			if not parser then
				return nil
			end
			local errors = 200
			parser:for_each_tree(function(lt)
				if lt:root():has_error() and errors >= 0 then
					errors = errors - 1
				end
			end)
			if errors < 0 then
				return nil
			end

			-- Strategy submodules of the installed hiphish/rainbow-delimiters.nvim.
			return line_count > threshold
				and require("rainbow-delimiters.strategy.global")
				or require("rainbow-delimiters.strategy.local")
		end
	end

	vim.g.rainbow_delimiters = {
		strategy = {
			[""] = init_strategy(500),
			c = init_strategy(300),
			cpp = init_strategy(300),
			lua = init_strategy(500),
			vimdoc = init_strategy(300),
			vim = init_strategy(300),
		},
		query = {
			[""] = "rainbow-delimiters",
			latex = "rainbow-blocks",
			javascript = "rainbow-delimiters-react",
		},
		highlight = {
			"RainbowDelimiterRed",
			"RainbowDelimiterOrange",
			"RainbowDelimiterYellow",
			"RainbowDelimiterGreen",
			"RainbowDelimiterBlue",
			"RainbowDelimiterCyan",
			"RainbowDelimiterViolet",
		},
	}

	require("utils").load_plugin("rainbow_delimiters", nil, true)
end
