return function()
	require("utils").load_plugin("render-markdown", {
		-- Whether Markdown should be rendered by default or not
		enabled = true,
		-- Maximum file size (in MB) that this plugin will attempt to render
		max_file_size = 2.0,
		-- Milliseconds that must pass before updating marks
		debounce = 100,
		-- Vim modes that will show a rendered view of the markdown file
		render_modes = { "n", "c", "t" },
		-- Hides added text on the cursor line (performance cost)
		anti_conceal = { enabled = true },
		log_level = "error",
	})
end
