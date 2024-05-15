{pkgs, ...}: {
  extraPlugins = with pkgs.vimPlugins; [
    lspsaga-nvim
  ];

  autoGroups = {
    my_lspsaga = {clear = true;};
    my_lspsaga_outline = {clear = true;};
  };

  autoCmd = [
    {
      event = "LspAttach";
      group = "my_lspsaga";
      callback = {
        __raw = ''
          function(args)
            local bufopts = { noremap = true, silent = true, buffer = args.buf }
            vim.keymap.set('n', 'gd', '<Cmd>Lspsaga goto_definition<CR>', bufopts)
            vim.keymap.set('n', '[d', '<Cmd>Lspsaga diagnostic_jump_prev<CR>', bufopts)
            vim.keymap.set('n', ']d', '<Cmd>Lspsaga diagnostic_jump_next<CR>', bufopts)
            vim.keymap.set('n', 'K', '<Cmd>Lspsaga hover_doc<CR>', bufopts)
            vim.keymap.set('n', 'gt', '<Cmd>Lspsaga goto_type_definition<CR>', bufopts)
            vim.keymap.set('n', 'gr', '<Cmd>Lspsaga finder ref<CR>', bufopts)
            vim.keymap.set('n', 'gi', '<Cmd>Lspsaga finder imp<CR>', bufopts)
            vim.keymap.set('n', 'gI', '<Cmd>Lspsaga incoming_calls<CR>', bufopts)
            vim.keymap.set('n', 'gO', '<Cmd>Lspsaga outgoing_calls<CR>', bufopts)
            vim.keymap.set('n', '[LSP]R', '<Cmd>Lspsaga rename<CR>', bufopts)
            vim.keymap.set('n', '[LSP]a', '<Cmd>Lspsaga code_action<CR>', bufopts)
            vim.keymap.set('n', '[LSP]f', function() vim.lsp.buf.format { async = true } end, bufopts)
            vim.keymap.set('n', '[LSP]o', '<Cmd>Lspsaga outline<CR>', bufopts)
          end
        '';
      };
    }
    {
      event = "FileType";
      pattern = "sagaoutline";
      group = "my_lspsaga_outline";
      callback = {
        __raw = ''
          function()
            vim.bo.buflisted = false
            vim.keymap.set('n', '<C-q>', ':clo<CR>', { buffer = true })
            vim.keymap.set('n', '<C-n>', '<Nop>', { buffer = true })
            vim.keymap.set('n', '<C-p>', '<Nop>', { buffer = true })
          end
        '';
      };
    }
  ];

  extraConfigLua = ''
    require('lspsaga').setup({
      lightbulb = {
        enable = false,
      },
      outline = {
        keys = {
          toggle_or_jump = '<CR>',
          quit = '<C-q>',
        },
      },
      code_action = {
        keys = {
          quit = '<C-q>',
        }
      },
      diagnostic = {
        show_code_action = false,
        keys = {
          quit = '<C-q>',
        }
      },
      finder = {
        keys = {
          toggle_or_open = '<CR>',
          quit = {'<C-q>', '<C-t>', '<C-l>'},
        }
      },
      definition = {
        width = 1,
        height = 1,
        keys = {
          edit = '<CR>',
          quit = {'<C-q>', '<C-t>', '<C-l>'},
        }
      },
      callhierarchy = {
        keys = {
          edit = '<CR>',
          quit = {'<C-q>', '<C-t>', '<C-l>'},
        }
      },
      rename = {
        keys = {
          quit = '<C-q>',
        }
      },
    })
  '';
}
