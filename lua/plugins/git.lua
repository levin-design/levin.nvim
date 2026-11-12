return {
  -- 1. 工作树管理 (Worktree)
  {
    "ThePrimeagen/git-worktree.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("git-worktree").setup({
        update_on_change = true, -- 切换后自动刷新缓冲区和 LSP
      })
      -- 加载 Telescope 扩展
      require("telescope").load_extension("git_worktree")
    end,
    keys = {
      { "<leader>gw", "<cmd>Telescope git_worktree git_worktrees<cr>", desc = "切换工作树 (Worktree)" },
      { "<leader>gn", "<cmd>Telescope git_worktree create_git_worktree<cr>", desc = "新建工作树 (Worktree)" },
    },
  },

  -- 2. 子仓库管理 (Submodule)
  {
    "agoodshort/telescope-git-submodules.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "akinsho/toggleterm.nvim", -- 依赖终端插件来打开 Lazygit
    },
    config = function()
      require("telescope").load_extension("git_submodules")
    end,
    keys = {
      { "<leader>gs", "<cmd>Telescope git_submodules<cr>", desc = "查看子仓库 (Submodule)" },
    },
  },
}
