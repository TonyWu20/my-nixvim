-- Harper (grammar checker) for LaTeX and Typst. Merged over the lspconfig
-- default config for `harper_ls` (cmd `harper-ls --stdio`). The user's
-- original narrowed the attach filetypes to tex/typst.
return {
	filetypes = { "tex", "typst" },
}
