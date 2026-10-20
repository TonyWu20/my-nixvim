{ lib, ... }:
let
  nlua = lib.nixvim.mkRaw;
in
{
  plugins.blink-cmp = {
    enable = true;
    lazyLoad.settings.event = [
      "BufReadPost"
      "InsertEnter"
      "CmdlineEnter"
    ];
    settings.snippets.preset = "default";
    settings.term.enabled = false;
    settings.appearance.nerd_font_variant = "normal";
    settings.fuzzy.implementation = "prefer_rust_with_warning";
    settings.cmdline.enabled = true;
    settings.cmdline.sources = nlua ''
      function()
        local t = vim.fn.getcmdtype()
        if t == '/' or t == '?' then return { 'buffer' } end
        if t == ':' or t == '@' then return { 'cmdline', 'path' } end
        return {}
      end
    '';
    settings.sources.default = [
      "lsp"
      "snippets"
      "path"
      "buffer"
      "ripgrep"
      "latex-symbols"
    ];
    # lazydev is a per-filetype source, not a global default. Its module
    # (lazydev.integrations.blink) only lands on package.path once lazydev.nvim
    # is loaded (ft = "lua"). blink requires the module for every provider in
    # `sources.default` on InsertEnter, so a global lazydev entry would crash
    # on any non-lua buffer. Registering it for the lua filetype only keeps the
    # completion available there while leaving other buffers crash-free.
    settings.sources.per_filetype = nlua ''
      {
        lua = { "lazydev", inherit_defaults = true },
      }
    '';
    settings.sources.providers = {
      lazydev = {
        name = "LazyDev";
        module = "lazydev.integrations.blink";
        score_offset = 100;
        enabled = nlua "function() return vim.bo.filetype == 'lua' end";
      };
      ripgrep = {
        name = "Ripgrep";
        module = "blink-ripgrep";
        max_items = 3;
        opts.prefix_min_len = 3;
      };
      latex-symbols = {
        name = "LaTeX";
        module = "blink-cmp-latex";
      };
      buffer = {
        opts.get_bufnrs = nlua ''
          function()
            return vim.api.nvim_buf_line_count(0) < 15000 and vim.api.nvim_list_bufs() or {}
          end
        '';
      };
    };
    settings.keymap.preset = "none";
    settings.keymap."<C-p>" = [
      "select_prev"
      "fallback"
    ];
    settings.keymap."<C-n>" = [
      "select_next"
      "fallback"
    ];
    settings.keymap."<C-d>" = [
      "scroll_documentation_up"
      "fallback"
    ];
    settings.keymap."<C-f>" = [
      "scroll_documentation_down"
      "fallback"
    ];
    settings.keymap."<C-w>" = [
      "cancel"
      "fallback"
    ];
    settings.keymap."<Tab>" = [
      "select_next"
      "snippet_forward"
      "fallback"
    ];
    settings.keymap."<S-Tab>" = [
      "select_prev"
      "snippet_backward"
      "fallback"
    ];
    settings.keymap."<CR>" = [
      "accept"
      "fallback"
    ];
    settings.completion.ghost_text.enabled = false;
    settings.completion.list.max_items = 120;
    settings.completion.menu.border = "single";
    settings.completion.menu.scrollbar = false;
  };
}
