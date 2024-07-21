return {
  "mgierada/lazydocker.nvim",
  dependencies = { "akinsho/toggleterm.nvim" },
  config = function() require("lazydocker").setup {} end,
  even  = "VeryLazy"
}

