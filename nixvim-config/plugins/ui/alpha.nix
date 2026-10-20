{ lib, ... }:
let
  nlua = lib.nixvim.mkRaw;
in
{
  plugins.alpha = {
    enable = true;
    lazyLoad.settings.event = "BufWinEnter";
    # Port of the old nvimdots dashboard (lua/modules/configs/ui/alpha.lua):
    # the user's ASCII art, the two search.nvim buttons, and the dynamic
    # footer. The old layout's spacing is preserved:
    #   top gap      = ceil((winheight - occupied) * 0.25), where occupied is
    #                  19 art lines + 2*2 buttons + 2 head padding (the old
    #                  header_padding, recomputed at draw time)
    #   2 blank lines between the art and the buttons (old head_butt_padding)
    #   1 blank line between the buttons and the footer (old foot_butt_padding)
    # alpha.nvim evaluates a section's `val` when it is a function, so the
    # top gap and the footer are Lua functions inside the layout.
    #
    # The old footer showed the nvim version plus plugin count and startuptime
    # from `require("lazy").stats()`. Nixvim's lazy-load provider is lz-n
    # (native packadd), which has no stats API, so the plugin count comes
    # from `nvim_get_runtime_file` over the pack path (start + opt dirs).
    # The "in Mms" startuptime is restored with the monotonic clock: an
    # `extraConfigLuaPre` block (extra-lua.nix) captures
    # `(vim.uv or vim.loop).hrtime()` into `vim.g.nixvim_start_ns` early in
    # the generated init (ahead of the post-load plugin setup); the footer
    # below renders the delta in ms. No-arg `reltime()` is boot-relative,
    # not process-start, so a captured baseline is needed.
    settings.layout = [
      {
        type = "padding";
        val = nlua ''
          function()
            local occupied = 19 + 2 * 2 + 2
            return math.max(0, math.ceil((vim.fn.winheight(0) - occupied) * 0.25))
          end
        '';
      }
      {
        type = "text";
        val = [
          "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿"
          "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⣠⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿"
          "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣡⣾⣿⣿⣿⣿⣿⢿⣿⣿⣿⣿⣿⣿⣟⠻⣿⣿⣿⣿⣿⣿⣿⣿"
          "⣿⣿⣿⣿⣿⣿⣿⣿⡿⢫⣷⣿⣿⣿⣿⣿⣿⣿⣾⣯⣿⡿⢧⡚⢷⣌⣽⣿⣿⣿⣿⣿⣶⡌⣿⣿⣿⣿⣿⣿"
          "⣿⣿⣿⣿⣿⣿⣿⣿⠇⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣮⣇⣘⠿⢹⣿⣿⣿⣿⣿⣻⢿⣿⣿⣿⣿⣿"
          "⣿⣿⣿⣿⣿⣿⣿⣿⠀⢸⣿⣿⡇⣿⣿⣿⣿⣿⣿⣿⣿⡟⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⣻⣿⣿⣿⣿"
          "⣿⣿⣿⣿⣿⣿⣿⡇⠀⣬⠏⣿⡇⢻⣿⣿⣿⣿⣿⣿⣿⣷⣼⣿⣿⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⢻⣿⣿⣿⣿"
          "⣿⣿⣿⣿⣿⣿⣿⠀⠈⠁⠀⣿⡇⠘⡟⣿⣿⣿⣿⣿⣿⣿⣿⡏⠿⣿⣟⣿⣿⣿⣿⣿⣿⣿⣿⣇⣿⣿⣿⣿"
          "⣿⣿⣿⣿⣿⣿⡏⠀⠀⠐⠀⢻⣇⠀⠀⠹⣿⣿⣿⣿⣿⣿⣩⡶⠼⠟⠻⠞⣿⡈⠻⣟⢻⣿⣿⣿⣿⣿⣿⣿"
          "⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⢿⠀⡆⠀⠘⢿⢻⡿⣿⣧⣷⢣⣶⡃⢀⣾⡆⡋⣧⠙⢿⣿⣿⣟⣿⣿⣿⣿"
          "⣿⣿⣿⣿⣿⣿⡿⠀⠀⠀⠀⠀⠀⠀⡥⠂⡐⠀⠁⠑⣾⣿⣿⣾⣿⣿⣿⡿⣷⣷⣿⣧⣾⣿⣿⣿⣿⣿⣿⣿"
          "⣿⣿⡿⣿⣍⡴⠆⠀⠀⠀⠀⠀⠀⠀⠀⣼⣄⣀⣷⡄⣙⢿⣿⣿⣿⣿⣯⣶⣿⣿⢟⣾⣿⣿⢡⣿⣿⣿⣿⣿"
          "⣿⡏⣾⣿⣿⣿⣷⣦⠀⠀⠀⢀⡀⠀⠀⠠⣭⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⣡⣾⣿⣿⢏⣾⣿⣿⣿⣿⣿"
          "⣿⣿⣿⣿⣿⣿⣿⣿⡴⠀⠀⠀⠀⠀⠠⠀⠰⣿⣿⣿⣷⣿⠿⠿⣿⣿⣭⡶⣫⠔⢻⢿⢇⣾⣿⣿⣿⣿⣿⣿"
          "⣿⣿⣿⡿⢫⣽⠟⣋⠀⠀⠀⠀⣶⣦⠀⠀⠀⠈⠻⣿⣿⣿⣾⣿⣿⣿⣿⡿⣣⣿⣿⢸⣾⣿⣿⣿⣿⣿⣿⣿"
          "⡿⠛⣹⣶⣶⣶⣾⣿⣷⣦⣤⣤⣀⣀⠀⠀⠀⠀⠀⠀⠉⠛⠻⢿⣿⡿⠫⠾⠿⠋⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿"
          "⢀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣀⡆⣠⢀⣴⣏⡀⠀⠀⠀⠉⠀⠀⢀⣠⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿"
          "⠿⠛⠛⠛⠛⠛⠛⠻⢿⣿⣿⣿⣿⣯⣟⠷⢷⣿⡿⠋⠀⠀⠀⠀⣵⡀⢠⡿⠋⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿"
          "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠛⢿⣿⣿⠂⠀⠀⠀⠀⠀⢀⣽⣿⣿⣿⣿⣿⣿⣿⣍⠛⠿⣿⣿⣿⣿⣿⣿"
        ];
        opts = {
          position = "center";
          hl = "AlphaHeader";
        };
      }
      {
        type = "padding";
        val = 2;
      }
      {
        type = "group";
        val = [
          {
            type = "button";
            val = "  Find files";
            on_press = nlua "function() require('search').open({ collection = 'file' }) end";
            opts = {
              position = "center";
              shortcut = "ff";
              cursor = 5;
              width = 50;
              align_shortcut = "right";
            };
          }
          {
            type = "button";
            val = "  Find patterns";
            on_press = nlua "function() require('search').open({ collection = 'pattern' }) end";
            opts = {
              position = "center";
              shortcut = "fp";
              cursor = 5;
              width = 50;
              align_shortcut = "right";
            };
          }
        ];
      }
      {
        type = "padding";
        val = 1;
      }
      {
        type = "text";
        val = nlua ''
          function()
            local v = vim.version()
            local n = 0
            local ok, count = pcall(function()
              return #vim.api.nvim_get_runtime_file("pack/*/start/*", true)
                + #vim.api.nvim_get_runtime_file("pack/*/opt/*", true)
            end)
            if ok then n = count end
            -- Startuptime, in ms, rounded to 0.01ms: the delta from the
            -- monotonic baseline `vim.g.nixvim_start_ns` (captured in
            -- `extraConfigLuaPre`, extra-lua.nix) to now. No-arg
            -- `reltime()` is boot-relative, not process-start, so a
            -- captured monotonic baseline is required for a startup
            -- timer. Frozen on first render so a later dashboard
            -- redraw does not inflate it (matches the old lazy
            -- startuptime, a fixed value). Falls back to 0 ms if the
            -- baseline is missing (alpha loaded outside the nixvim init).
            local uv = vim.uv or vim.loop
            if not vim.g.nixvim_alpha_start_ms and vim.g.nixvim_start_ns then
              vim.g.nixvim_alpha_start_ms =
                math.floor((uv.hrtime() - vim.g.nixvim_start_ns) / 1e4 + 0.5) / 100
            end
            local ms = vim.g.nixvim_alpha_start_ms or 0
            return " \239\128\132  Have Fun with neovim"
              .. "  \239\128\168 v" .. v.major .. "." .. v.minor .. "." .. v.patch
              .. "  \239\130\150 " .. n .. " plugins in " .. ms .. "ms"
          end
        '';
        opts = {
          position = "center";
          hl = "AlphaFooter";
        };
      }
    ];
  };

}
