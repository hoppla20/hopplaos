{pkgs, ...}: {
  extraPlugins = [pkgs.vimPlugins.orgmode];
  extraConfigLua = ''
    do
      local org = require('orgmode')
      org.setup_ts_grammar()
      org.setup({
        org_agenda_files = {'~/Sync/org/*'},
        org_default_notes_file = '~/Sync/org/refile.org',
      })
    end
  '';
}
