local editor = {}

editor["echasnovski/mini.surround"] = {
	version = false,
	config = function()
		require("mini.surround").setup()
	end,
}

editor["keaising/im-select.nvim"] = {
	lazy = false,
	opts = {
		default_im_select = "keyboard-us",
		default_command = "fcitx5-remote",
	},
}

editor["rainzm/flash-zh.nvim"] = {
	event = "VeryLazy",
	dependencies = "folke/flash.nvim",
	keys = {
		{
			"s",
			mode = { "n", "x", "o" },
			function()
				require("flash-zh").jump({
					chinese_only = false,
				})
			end,
			desc = "Flash between Chinese",
		},
	},
}

editor["kkew3/jieba.vim"] = {
	tag = "v2.1.0",
	build = ":call jieba_vim#install()",
	init = function()
		vim.g.jieba_vim_lazy = 1
		vim.g.jieba_vim_keymap = 1
	end,
}

return editor
