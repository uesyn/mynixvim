{pkgs, ...}: {
  extraPlugins = with pkgs.vimPlugins; [
    fidget-nvim
  ];

  extraConfigLua = ''
    require("fidget").setup({})
  '';
}
