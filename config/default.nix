{inputs, ...}: {
  imports = [
    ./options.nix
    ./keymaps.nix
    ./autocmds.nix
    ./ftplugin.nix
    ./plugins
  ];

  viAlias = true;
  vimAlias = true;
  luaLoader.enable = true;
}
