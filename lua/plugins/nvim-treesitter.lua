-- Code Tree Support / Syntax Highlighting
return {
  -- https://github.com/nvim-treesitter/nvim-treesitter
  'nvim-treesitter/nvim-treesitter',
  event = 'VeryLazy',
  dependencies = {
    -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    'nvim-treesitter/nvim-treesitter-textobjects',
    { 'windwp/nvim-ts-autotag' }
  },
  build = ':TSUpdate',
  opts = {
    highlight = {
      enable = true,
    },
    indent = { enable = true },
    auto_install = true, -- automatically install syntax support when entering new file type buffer
    ensure_installed = {
      'bash',
      'c',
      'cmake',
      'comment',
      'cpp',
      'css',
      'diff',
      'dockerfile',
      'gitignore',
      'go',
      'html',
      'java',
      'javascript',
      'lua',
      'luadoc',
      'markdown',
      'python',
      'regex',
      'rust',
      'sql',
      'typescript',
      'xml',
      'yaml'
    },
    autopairs = { enable = true },
    autotag = { enable = true },
  },
  config = function(_, opts)
    local configs = require("nvim-treesitter.configs")
    configs.setup(opts)
  end
}
