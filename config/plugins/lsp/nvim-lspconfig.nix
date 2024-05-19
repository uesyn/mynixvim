{pkgs, ...}: {
  extraPackages = with pkgs; [
    gopls
    nixd
    nodePackages.typescript-language-server
    nodePackages.bash-language-server
  ];

  extraPlugins = with pkgs.vimPlugins; [
    cmp-nvim-lsp
    nvim-lspconfig
  ];

  autoGroups = {
    my_lspconfig = {
      clear = true;
    };
  };

  autoCmd = [
    {
      event = "LspAttach";
      callback = {
        __raw = ''
          function(args)
            if not (args.data and args.data.client_id) then
              return
            end

            local bufnr = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)

            local bufopts = { noremap = true, silent = true, buffer = bufnr }
            vim.keymap.set('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', bufopts)
            vim.keymap.set('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', bufopts)
            vim.keymap.set('n', '[d', '<Cmd>lua vim.diagnostic.goto_prev()<CR>', bufopts)
            vim.keymap.set('n', ']d', '<Cmd>lua vim.diagnostic.goto_next()<CR>', bufopts)
            vim.keymap.set('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', bufopts)
            vim.keymap.set('n', 'gt', '<Cmd>lua vim.lsp.buf.type_definition()<CR>', bufopts)
            vim.keymap.set('n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>', bufopts)
            vim.keymap.set('n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', bufopts)
            vim.keymap.set('n', 'gI', '<Cmd>lua vim.lsp.buf.incoming_calls()<CR>', bufopts)
            vim.keymap.set('n', 'gO', '<Cmd>lua vim.lsp.buf.outgoing_calls()<CR>', bufopts)
            vim.keymap.set('n', '[LSP]R', '<Cmd>lua vim.lsp.buf.rename()<CR>', bufopts)
            vim.keymap.set('n', '[LSP]a', '<Cmd>lua vim.lsp.buf.code_action()<CR>', bufopts)
            vim.keymap.set('n', '[LSP]f', function() vim.lsp.buf.format { async = true } end, bufopts)
            vim.keymap.set('n', '[LSP]i', '<Cmd>lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<CR>', bufopts)
          end
        '';
      };
      group = "my_lspconfig";
    }
  ];

  extraConfigLua = ''
    local lspconfig = require('lspconfig')
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    if vim.fn.executable("gopls") == 1 then
      lspconfig.gopls.setup {
        handlers = handlers,
        capabilities = capabilities,
        settings = {
          gopls = {
            hints = {
              assignVariableTypes = false,
              compositeLiteralFields = false,
              compositeLiteralTypes = false,
              constantValues = false,
              functionTypeParameters = false,
              parameterNames = false,
              rangeVariableTypes = false,
            },
          },
        },
      }
    end

    if vim.fn.executable("typescript-language-server") == 1 then
      lspconfig.tsserver.setup {
        handlers = handlers,
        capabilities = capabilities,
        root_dir = require('lspconfig').util.root_pattern("package.json"),
      }
    end

    if vim.fn.executable("deno") == 1 then
      lspconfig.denols.setup {
        handlers = handlers,
        capabilities = capabilities,
        root_dir = require('lspconfig').util.root_pattern("deno.json", "deno.jsonc", "deps.ts",
          "import_map.json"),
        settings = {
          denols = {
            enable = true,
            lint = true,
            unstable = true,
            suggest = {
              imports = {
                autoDiscovery = true,
              }
            },
          },
        },
      }
    end

    if vim.fn.executable("rust-analyzer") == 1 then
      lspconfig.rust_analyzer.setup {
        -- Server-specific settings. See `:help lspconfig-setup`
        settings = {
          ["rust-analyzer"] = {
            cargo = { allFeatures = true },
            checkOnSave = { allFeatures = true },
            diagnostics = {
              enable = true,
              disabled = { "unresolved-proc-macro" },
              enableExperimental = true,
            },
          },
        },
      }
    end


    if vim.fn.executable("bash-language-server") == 1 then
      lspconfig.bashls.setup {}
    end

    if vim.fn.executable("pyright") == 1 then
      lspconfig.pyright.setup {}
    end

    if vim.fn.executable("nixd") == 1 then
      lspconfig.nixd.setup {}
    end
  '';
}
