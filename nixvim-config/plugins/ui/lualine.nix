{ lib, ... }:
let
  nlua = lib.nixvim.mkRaw;
in
{
    # Statusline. The nixvim lualine defaults (mode/branch/filename/encoding/
    # progress/location) have no LSP client-name component, so the active
    # server is invisible. The old nvimdots statusline
    # (lua/modules/configs/ui/lualine.lua) rendered a custom `components.lsp`
    # that listed the attached server names next to the diagnostics count, so
    # that indicator is ported into `lualine_c` here: `filename` keeps the
    # default section-c entry, `diagnostics` restores the old E/W/I/H counts,
    # and the raw component lists the active LSP server name(s).
  plugins.lualine = {
    enable = true;
    lazyLoad.settings.event = [
      "BufReadPost"
      "BufAdd"
      "BufNewFile"
    ];
    settings.sections.lualine_c = [
      "filename"
      "diagnostics"
      (nlua "function() local ft=vim.bo.filetype if ft=='' then return '' end local names={} for _,c in ipairs(vim.lsp.get_clients({bufnr=0})) do local fts=c.config.filetypes or {} if vim.fn.index(fts,ft)~= -1 then names[#names+1]=c.name end end if #names==0 then return '' end local seen={} local uniq={} for _,n in ipairs(names) do if not seen[n] then seen[n]=true uniq[#uniq+1]=n end end return 'LSP['..table.concat(uniq, ', ')..']' end")
    ];
  };
}
