{pkgs, ...}: {
  extraPlugins = with pkgs.vimPlugins; [
    dracula-nvim
  ];
  colorscheme = "dracula";
}
