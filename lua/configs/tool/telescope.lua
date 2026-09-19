return function()
	local icons = { ui = require("icons").get("ui", true) }
	local lga_actions = require("telescope-live-grep-args.actions")

	require("utils").load_plugin("telescope", {
		defaults = {
			vimgrep_arguments = {
				"rg",
				"--no-heading",
				"--with-filename",
				"--line-number",
				"--column",
				"--smart-case",
			},
			initial_mode = "insert",
			prompt_prefix = " " .. icons.ui.Telescope .. " ",
			selection_caret = icons.ui.ChevronRight,
			scroll_strategy = "limit",
			results_title = false,
			layout_strategy = "flex",
			path_display = { "absolute" },
			selection_strategy = "reset",
			color_devicons = true,
			file_ignore_patterns = {
				".git/",
				".cache",
				"build/",
				"%.class",
				"%.pdf",
				"%.mkv",
				"%.mp4",
				"%.zip",
			},
			layout_config = {
				horizontal = {
					preview_width = 0.55,
				},
				vertical = {
					mirror = false,
				},
				width = 0.85,
				height = 0.92,
				preview_cutoff = 120,
			},
			file_previewer = require("telescope.previewers").vim_buffer_cat.new,
			grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
			qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
			file_sorter = require("telescope.sorters").get_fuzzy_file,
			generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
			buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
		},
		extensions = {
			fzf = {
				fuzzy = false,
				override_generic_sorter = true,
				override_file_sorter = true,
				case_mode = "smart_case",
			},
			frecency = {
				show_scores = true,
				show_unindexed = true,
				ignore_patterns = { "*.git/*", "*/tmp/*" },
			},
			live_grep_args = {
				auto_quoting = true,
				mappings = {
					i = {
						["<C-k>"] = lga_actions.quote_prompt(),
						["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
					},
				},
			},
		},
	})

	require("telescope").load_extension("frecency")
	-- fzf-native is a compiled C extension; only load it if it built.
	local ok, err = pcall(require("telescope").load_extension, "fzf")
	if not ok then
		vim.notify(
			"[telescope] fzf-native extension unavailable (" .. tostring(err)
			.. "); falling back to builtin sorter",
			vim.log.levels.WARN
		)
	end
	require("telescope").load_extension("live_grep_args")
end
