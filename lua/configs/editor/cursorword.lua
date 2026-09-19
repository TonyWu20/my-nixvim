return function()
	require("utils").load_plugin("mini.cursorword", {
		-- Delay (in ms) between when cursor moved and when highlighting appeared
		delay = 200,
	})
	require("utils").gen_cursorword_hl()
end
