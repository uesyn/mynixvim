{pkgs, ...}: {
  extraPlugins = with pkgs.vimPlugins; [
    nvim-notify
  ];
}
