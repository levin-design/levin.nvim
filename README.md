# levin.nvim

基于 [LazyVim](https://github.com/LazyVim/LazyVim) 的个人 Neovim 配置。以 LazyVim v16 为底座，保留其开箱即用的默认体验，并针对 Git 工作流（diff、worktree、submodule）与符号导航做了增强，同时启用了 GitHub Copilot 与 Go 语言支持。

- 仓库地址（SSH）：`git@github.com:levin-design/levin.nvim.git`
- 仓库地址（HTTPS）：<https://github.com/levin-design/levin.nvim>
- 上游基线：LazyVim v16.0.2，`lazy-lock.json` 锁定 commit `0fa4a847929fc6beae40a3063615a58115678c34`
- 许可证：MIT（见 [LICENSE](LICENSE)）

## 定位

这是一份个人自用的 Neovim 配置（dotfiles），不是通用发行版。默认 leader 键为空格。除 `lua/plugins/` 下新增的插件和 `lazyvim.json` 中启用的 extras 外，其余行为均来自 LazyVim v16 默认配置；`lua/config/` 下的选项、键位和自动命令文件基本保持 LazyVim starter 原样。

## 特性

- 完整保留 LazyVim v16 的默认能力：blink.cmp 补全、snacks picker、LSP、Treesitter、格式化、lint、which-key 等。
- diffview.nvim：查看当前改动与文件提交历史。
- git-worktree.nvim：基于 Telescope 的 Git worktree 浏览、创建与切换。
- telescope-git-submodules.nvim：浏览子模块，并可在 toggleterm 中打开 lazygit。
- outline.nvim：符号大纲侧边栏。
- 启用 LazyVim extras：`ai.copilot`（GitHub Copilot 补全）与 `lang.go`（Go 语言支持）。

## 前置依赖

| 依赖 | 要求 / 说明 |
| --- | --- |
| Neovim | >= 0.11.2，需使用 LuaJIT 构建（LazyVim v16 的硬性要求） |
| Git | >= 2.19.0（lazy.nvim 使用 partial clone 安装插件） |
| C 编译器 | nvim-treesitter 编译解析器需要，如 gcc / clang |
| ripgrep（`rg`） | 全局搜索，snacks picker 的 grep 功能依赖它 |
| fd | 文件查找，snacks picker 使用 `fd` 或 `fdfind`；Debian / Ubuntu 的包名为 `fd-find`，安装后命令为 `fdfind` |
| curl | Mason 下载工具时使用（curl 优先，也支持 wget） |
| Nerd Font | 可选，用于显示文件类型等图标 |
| lazygit | 可选，但 submodule 的 Git TUI 功能需要它；LazyVim 在检测到 lazygit 时会提供 `<leader>gg` / `<leader>gG` |
| GitHub Copilot 订阅 | 使用 Copilot 补全时需要，首次使用执行 `:Copilot auth` |
| Go 工具链 | 开发或运行 Go 项目时建议安装；编辑器侧的 gopls 等工具由 Mason 自动安装 |

依赖缺失时，可用 `:checkhealth` 查看 LazyVim 给出的提示。

## 安装

### 1. 备份现有配置

如果已有 Neovim 配置，先备份（目录不存在时跳过对应命令）：

```sh
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak
```

### 2. 克隆仓库

```sh
git clone git@github.com:levin-design/levin.nvim.git ~/.config/nvim
```

没有配置 SSH key 时，使用 HTTPS：

```sh
git clone https://github.com/levin-design/levin.nvim.git ~/.config/nvim
```

### 3. 首次启动

```sh
nvim
```

lazy.nvim 会自动 bootstrap，并根据 `lua/config/lazy.lua` 安装 LazyVim 与所有插件。等待安装完成后，建议依次执行：

- `:Lazy restore`：按 `lazy-lock.json` 恢复锁定的插件版本。
- `:checkhealth`：检查 Neovim 版本、外部依赖与 Treesitter 环境。
- `:Mason`（或 `<leader>cm`）：查看 LSP 与工具安装情况。
- `:Copilot auth`：登录 GitHub Copilot。安装 copilot.lua 时其 `build` 也会触发该命令；登录状态可用 `:Copilot auth info` 查看。

完成后重启 Neovim 使配置完全生效。

## 目录结构

```text
~/.config/nvim
├── init.lua                 # 入口：加载 config.lazy，并关闭 swapfile
├── lazyvim.json             # 启用的 LazyVim extras
├── lazy-lock.json           # 插件版本锁定
├── stylua.toml              # Lua 格式化规则（2 空格缩进，行宽 120）
├── .neoconf.json            # neoconf / lua_ls 项目配置
├── .gitignore
├── LICENSE
├── README.md
└── lua
    ├── config
    │   ├── autocmds.lua     # 自动命令（未改动）
    │   ├── keymaps.lua      # 自定义键位（未改动）
    │   ├── lazy.lua         # lazy.nvim 启动与插件导入
    │   └── options.lua      # 编辑器选项（未改动）
    └── plugins
        ├── diffview.lua     # diffview.nvim
        ├── example.lua      # LazyVim starter 示例（未启用）
        ├── git.lua          # git-worktree + telescope-git-submodules
        └── outline.lua      # outline.nvim
```

## 新增插件

### 自定义插件（`lua/plugins/`）

| 插件 | 用途 | 常用命令 / 快捷键 |
| --- | --- | --- |
| [sindrets/diffview.nvim](https://github.com/sindrets/diffview.nvim) | Git diff 与文件提交历史 | `<leader>gd` → `:DiffviewOpen`<br>`<leader>gh` → `:DiffviewFileHistory`<br>`:DiffviewClose` 关闭视图 |
| [ThePrimeagen/git-worktree.nvim](https://github.com/ThePrimeagen/git-worktree.nvim) | 浏览、创建、切换 Git worktree（Telescope 扩展） | `<leader>gw` → `:Telescope git_worktree git_worktrees`<br>`<leader>gn` → `:Telescope git_worktree create_git_worktree` |
| [agoodshort/telescope-git-submodules.nvim](https://github.com/agoodshort/telescope-git-submodules.nvim) | 浏览 submodule，选中后可在 toggleterm 中打开 lazygit | `<leader>gs` → `:Telescope git_submodules`（键位存在冲突，见下文） |
| [hedyhli/outline.nvim](https://github.com/hedyhli/outline.nvim) | 符号大纲侧边栏 | `<leader>o` 切换<br>`:Outline`、`:OutlineOpen`、`:OutlineClose` |

补充说明：

- diffview.nvim 依赖 `plenary.nvim`，采用默认配置（`require("diffview").setup({})`），并通过 `cmd` + `keys` 懒加载。
- git-worktree.nvim 依赖 `telescope.nvim` 与 `plenary.nvim`，配置了 `update_on_change = true`：切换 worktree 后会尝试把当前缓冲区切换到新 worktree 中的同名文件；找不到时执行默认的 `e .` 打开新 worktree 根目录。
- telescope-git-submodules.nvim 依赖 `telescope.nvim` 与 `toggleterm.nvim`。插件默认 `git_cmd = "lazygit"`，因此需要在系统中安装 lazygit 才能打开 Git TUI。
- outline.nvim 通过 `lazy = true`、`cmd` 与 `keys` 懒加载，`opts = {}` 使用插件默认配置。
- 以上插件只在触发命令或快捷键时加载，不占用启动时间。

### 启用的 LazyVim extras（`lazyvim.json`）

| Extra | 包含内容 | 用途 | 常用命令 / 快捷键 |
| --- | --- | --- | --- |
| `lazyvim.plugins.extras.ai.copilot` | `copilot.lua`、`blink-copilot`（配合默认的 blink.cmp） | GitHub Copilot 补全 | `:Copilot auth` 登录<br>`:Copilot auth info` 查看认证状态<br>`<C-y>` 接受补全，`<M-]>` / `<M-[>` 切换建议 |
| `lazyvim.plugins.extras.lang.go` | gopls 配置、Go Treesitter 解析器、Mason 工具、conform / nvim-lint 的 Go 规则 | Go 语言支持 | LSP 快捷键沿用 LazyVim，例如 `gd` 跳转定义、`K` 悬停文档、`<leader>ca` 代码操作<br>`<leader>?` 查看当前缓冲区的全部快捷键 |

说明：启用 `lang.go` 后，Mason 会确保安装 `gopls`、`goimports`、`gofumpt`、`golangci-lint` 等工具；`conform.nvim` 使用 `goimports`、`gofumpt` 格式化 Go 代码，`nvim-lint` 使用 `golangci-lint` 做 lint。

### 快捷键冲突说明

LazyVim v16 默认启用 snacks picker（默认 extra `editor.snacks_picker`），其中已经占用了：

- `<leader>gs`：Git Status
- `<leader>gd`：Git Diff (hunks)

这与本配置新增的 submodule（`<leader>gs`）和 diffview（`<leader>gd`）键位重复。lazy.nvim 对重复键位的合并结果并不稳定：同一份配置多次启动，可能由本配置的插件响应，也可能由 snacks picker 响应。`<leader>gh` 不与 snacks picker 冲突，可以稳定触发 diffview 的文件历史；但它与 LazyVim 的 hunk 分组前缀 `<leader>gh*` 重叠，按下后会有超时等待，`<leader>ghs` 等 Gitsigns 快捷键仍然可用。

如果上述键位未按预期工作，请直接使用 Ex 命令（`:DiffviewOpen`、`:Telescope git_submodules`），或修改 `lua/plugins/diffview.lua`、`lua/plugins/git.lua` 中的 `keys`（例如改为 `<leader>gD`、`<leader>gS`）。

## 相对原生 LazyVim 的改动

以 [LazyVim starter](https://github.com/LazyVim/starter) 模板为基准逐文件对比，改动如下：

| 文件 | 状态 | 说明 |
| --- | --- | --- |
| `init.lua` | 修改 | 在 starter 的两行基础上增加 `vim.opt.swapfile = false`，关闭交换文件 |
| `lua/config/options.lua` | 未改动 | 仅保留 starter 注释，未设置额外选项 |
| `lua/config/keymaps.lua` | 未改动 | 仅比 starter 多一行空注释 `--`，没有新增键位 |
| `lua/config/autocmds.lua` | 未改动 | 仅保留 starter 注释 |
| `lua/config/lazy.lua` | 未改动 | 与 starter 完全一致（bootstrap 与 lazy.nvim 配置） |
| `lua/plugins/example.lua` | 未改动 | LazyVim starter 自带示例；首行 `if true then return {} end` 使其整体不生效，不影响启动 |
| `lua/plugins/diffview.lua` | 新增 | diffview.nvim：diff 与文件历史 |
| `lua/plugins/git.lua` | 新增 | git-worktree.nvim 与 telescope-git-submodules.nvim |
| `lua/plugins/outline.lua` | 新增 | outline.nvim |
| `lazyvim.json` | 修改 | 启用 `ai.copilot`、`lang.go` 两个 extra |
| `lazy-lock.json` | 新增 | 锁定全部插件版本 |
| `README.md` | 改写 | 由 starter 的占位说明改为本中文 README |
| `LICENSE` | 替换 | starter 自带 Apache-2.0 模板，本仓库改为 MIT |
| `.gitignore`、`stylua.toml`、`.neoconf.json` | 未改动 | 与 starter 一致 |

### lazyvim.json

启用的 extras：

```json
"extras": [
  "lazyvim.plugins.extras.ai.copilot",
  "lazyvim.plugins.extras.lang.go"
]
```

文件中的 `install_version`、`version`、`news` 字段由 LazyVim 自动维护，不是手写配置。

### lazy-lock.json

与默认 LazyVim v16 相比，额外锁定的插件（含传递依赖）为：

- `diffview.nvim`
- `git-worktree.nvim`
- `outline.nvim`
- `telescope-git-submodules.nvim`
- `telescope.nvim`（git-worktree 与 telescope-git-submodules 的依赖）
- `toggleterm.nvim`（telescope-git-submodules 的依赖）
- `copilot.lua`、`blink-copilot`（来自 `ai.copilot` extra）

`lazy-lock.json` 同时把 LazyVim 锁定在 v16.0.2（commit `0fa4a847929fc6beae40a3063615a58115678c34`）。LazyVim v16 默认使用 snacks picker，因此默认配置不会安装 telescope.nvim；本仓库安装它是因为新增的 Git 插件依赖 Telescope。

## 常用维护命令

| 命令 | 作用 |
| --- | --- |
| `:Lazy` | 打开插件管理界面 |
| `:Lazy restore` | 按 `lazy-lock.json` 恢复插件版本 |
| `:Lazy update` | 更新插件（会改写 lock 文件） |
| `:Mason`（或 `<leader>cm`） | 打开 LSP / 工具安装界面 |
| `:checkhealth` | 检查 Neovim 版本、外部依赖与 Treesitter 环境 |
| `:Copilot auth` | 登录 GitHub Copilot |
| `:Copilot auth info` | 查看 Copilot 认证状态 |

## 许可证

本仓库以 [MIT](LICENSE) 许可证发布。

本项目基于 [LazyVim](https://github.com/LazyVim/LazyVim) 与 [LazyVim starter](https://github.com/LazyVim/starter) 构建；LazyVim 项目本身采用 Apache-2.0 许可证，相关版权归其作者所有。

## 致谢

- [LazyVim](https://github.com/LazyVim/LazyVim) 与 [LazyVim starter](https://github.com/LazyVim/starter)
- 本配置使用的所有插件作者
