return {
  {
    "sindrets/diffview.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim", -- 通常 LazyVim 已经包含了，写上更保险
    },
    cmd = { "DiffviewOpen", "DiffviewFileHistory" }, -- 懒加载，执行这些命令时才加载插件
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "打开 Diffview" },
      { "<leader>gh", "<cmd>DiffviewFileHistory<cr>", desc = "文件历史" },
    },
    config = function()
      require("diffview").setup({})
    end,
  },
}
