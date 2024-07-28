return {
  'nvim-neo-tree/neo-tree.nvim',
  cmd = 'Neotree',
  keys = {
    {
      '<leader>fe',
      function()
        require('neo-tree.command').execute { toggle = true, dir = vim.uv.cwd() }
      end,
      desc = 'Explorer NeoTree (Current Dir)',
    },
    { '<leader>e', '<leader>fe', desc = 'Explorer NeoTree (Current Dir)', remap = true },
    {
      '<leader>fE',
      function()
        require('neo-tree.command').execute { action = 'focus', dir = vim.uv.cwd() }
      end,
      desc = 'Close NeoTree',
    },
    {
      '<leader>ge',
      function()
        require('neo-tree.command').execute { source = 'git_status', toggle = true }
      end,
      desc = 'Git Explorer',
    },
    {
      '<leader>be',
      function()
        require('neo-tree.command').execute { source = 'buffers', toggle = true }
      end,
      desc = 'Buffer Explorer',
    },
  },
  deactivate = function()
    vim.cmd [[Neotree close]]
  end,
  init = function()
    vim.api.nvim_create_autocmd('BufEnter', {
      group = vim.api.nvim_create_augroup('Neotree_start_directory', { clear = true }),
      desc = 'Start Neo-tree with directory',
      once = true,
      callback = function()
        if package.loaded['neo-tree'] then
          return
        else
          local stats = vim.uv.fs_stat(vim.fn.argv(0))
          if stats and stats.type == 'directory' then
            require 'neo-tree'
          end
        end
      end,
    })
  end,
  opts = {
    sources = { 'filesystem', 'buffers', 'git_status' },
    open_files_do_not_replace_types = { 'terminal', 'Trouble', 'trouble', 'qf', 'Outline' },
    filesystem = {
      bind_to_cwd = false,
      follow_current_file = { enabled = true },
      use_libuv_file_watcher = true,
    },
    window = {
      position = 'right',
      mappings = {
        ['l'] = 'open',
        ['h'] = 'close_node',
        ['<space>'] = 'none',
        ['Y'] = {
          function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            vim.fn.setreg('+', path, 'c')
          end,
          desc = 'Copy Path to Clipboard',
        },
        ['O'] = 'system_open',
        ['P'] = { 'toggle_preview', config = { use_float = false } },
        ['D'] = 'diff_files',
      },
    },
    default_component_configs = {
      indent = {
        with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
        expander_collapsed = '',
        expander_expanded = '',
        expander_highlight = 'NeoTreeExpander',
      },
      git_status = {
        symbols = {
          unstaged = '󰄱',
          staged = '󰱒',
        },
      },
    },
    commands = {
      system_open = function()
        vim.fn.jobstart({ 'open', '.' }, { detach = true })
      end,
      diff_files = function(state)
        local node = state.tree:get_node()
        local log = require 'neo-tree.log'
        state.clipboard = state.clipboard or {}
        if diff_Node and diff_Node ~= tostring(node.id) then
          local current_Diff = node.id
          require('neo-tree.utils').open_file(state, diff_Node, open)
          vim.cmd('vert diffs ' .. current_Diff)
          log.info('Diffing ' .. diff_Name .. ' against ' .. node.name)
          diff_Node = nil
          current_Diff = nil
          state.clipboard = {}
          require('neo-tree.ui.renderer').redraw(state)
        else
          local existing = state.clipboard[node.id]
          if existing and existing.action == 'diff' then
            state.clipboard[node.id] = nil
            diff_Node = nil
            require('neo-tree.ui.renderer').redraw(state)
          else
            state.clipboard[node.id] = { action = 'diff', node = node }
            diff_Name = state.clipboard[node.id].node.name
            diff_Node = tostring(state.clipboard[node.id].node.id)
            log.info('Diff source file ' .. diff_Name)
            require('neo-tree.ui.renderer').redraw(state)
          end
        end
      end,
    },
  },
  config = function(_, opts)
    local function on_move(data)
      LazyVim.lsp.on_rename(data.source, data.destination)
    end

    local events = require 'neo-tree.events'
    opts.event_handlers = opts.event_handlers or {}
    vim.list_extend(opts.event_handlers, {
      { event = events.FILE_MOVED, handler = on_move },
      { event = events.FILE_RENAMED, handler = on_move },
    })
    require('neo-tree').setup(opts)
    vim.api.nvim_create_autocmd('TermClose', {
      pattern = '*lazygit',
      callback = function()
        if package.loaded['neo-tree.sources.git_status'] then
          require('neo-tree.sources.git_status').refresh()
        end
      end,
    })
  end,
}
