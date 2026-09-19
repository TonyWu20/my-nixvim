return function()
	vim.api.nvim_set_hl(
		0,
		"FlashLabel",
		{ underline = true, bold = true, fg = "Orange", bg = "NONE", ctermfg = "Red", ctermbg = "NONE" }
	)

	require("utils").load_plugin("flash", {
		labels = "asdfghjklqwertyuiopzxcvbnm",
		label = {
			uppercase = true,
			current = true,
			distance = true,
		},
		modes = {
			search = { enabled = false },
			char = {
				enabled = true,
				autohide = false,
				-- jump labels (user preference, carried over from the old config)
				jump_labels = true,
				multi_line = true,
				-- When using jump labels, don't use these keys
				label = { exclude = "hjkliardc" },
			},
		},
	})
end
