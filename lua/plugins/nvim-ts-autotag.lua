return {
  'windwp/nvim-ts-autotag',
  dependencies = 'nvim-treesitter/nvim-treesitter',
  config = function()
    require('nvim-ts-autotag').setup {
      enable = true,
      filetypes = { 'html', 'text', 'tsx', 'jsx', 'python' },
      indent = { enable = true },
      autotag = { enable = true },
      autopairs = { enable = true },
    }
  end,
  lazy = true,
  event = 'VeryLazy',
}
