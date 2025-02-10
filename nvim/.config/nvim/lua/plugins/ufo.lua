return {
  "kevinhwang91/nvim-ufo",
  enabled = true,
  dependencies = "kevinhwang91/promise-async",
  config = [[ require("ufo").setup() ]],
  keys = {
    { "zR", function() require("ufo").openAllFolds() end },
    { "zM", function() require("ufo").closeAllFolds() end },
  },
}
