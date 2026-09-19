-- search.nvim: tabbed file/pattern collections for <leader>ff and <leader>fp.

return function()
	local extensions = require("telescope").extensions
	local builtins = require("telescope.builtin")
	local prompt_pos = require("telescope.config").values.layout_config.horizontal.prompt_position

	local collections = {
		file = {
			initial_tab = 1,
			tabs = {
				{ "Files", builtins.find_files },
				{
					"Frecency",
					function()
						extensions.frecency.frecency()
					end,
				},
				{ "Buffers", builtins.buffers },
			},
		},
		pattern = {
			initial_tab = 1,
			tabs = {
				{ "Word in project", extensions.live_grep_args.live_grep_args },
				{ "Word under cursor", builtins.grep_string },
			},
		},
	}

	require("utils").load_plugin("search", {
		prompt_position = prompt_pos,
		collections = collections,
	})
end
