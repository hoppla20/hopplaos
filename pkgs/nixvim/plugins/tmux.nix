{pkgs, ...}: {
  extraPlugins = [pkgs.vimPlugins.tmux-nvim];
  extraConfigLua = ''
    require('tmux').setup({
      copy_sync = {
        sync_register = false,
      },
      navigation = {
        cycle_navigation = false,
        enable_default_keybindings = true,
      },
      resize = {
        enable_default_keybindings = true,
      },
    })
  '';
}
