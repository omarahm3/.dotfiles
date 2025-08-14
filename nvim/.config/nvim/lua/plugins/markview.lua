return {
  -- Ensure treesitter brings markview in first
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = { "OXY2DEV/markview.nvim" },
    lazy = false,
  },
  {
    "OXY2DEV/markview.nvim",
    lazy = false,
    opts = {
      experimental = {
        check_rtp = true,
        check_rtp_message = false,
      },
    },
  },
}
