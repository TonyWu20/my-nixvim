-- Nushell's built-in language server (`nu --lsp`), attached to `nu` files.
-- Mirrors the user's original user/configs/nushell.lua.
return {
	filetypes = { "nu" },
	single_file_support = true,
}
