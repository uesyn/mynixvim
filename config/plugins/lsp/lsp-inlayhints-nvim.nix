{pkgs, ...}: {
  extraPlugins = with pkgs.vimPlugins; [
    lsp-inlayhints-nvim
  ];

  autoGroups = {
    my_inlay_hints = {clear = true;};
  };

  autoCmd = [
    {
      event = "LspAttach";
      group = "my_inlay_hints";
      callback = {
        __raw = ''
          function(args)
            if not (args.data and args.data.client_id) then
              return
            end

            local bufnr = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            require("lsp-inlayhints").on_attach(client, bufnr)
          end
        '';
      };
    }
  ];

  extraConfigLua = ''
    require("lsp-inlayhints").setup()
  '';
}
