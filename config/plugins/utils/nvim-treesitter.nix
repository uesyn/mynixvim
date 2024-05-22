{pkgs, ...}: {
  extraPlugins = with pkgs.vimPlugins; [
    (nvim-treesitter.withPlugins (
      plugins: with plugins; [
        markdown
        markdown_inline
      ]
    ))
  ];

  extraConfigLua = ''
    require'nvim-treesitter.configs'.setup {
      auto_install = false,
    }
  '';
}
