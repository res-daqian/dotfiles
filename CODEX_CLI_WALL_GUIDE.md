# Codex CLI 中文墙贴速查

适用场景：你用 `codex` / `cx` 在终端里工作，想搞清楚界面、会话和项目管理。

## 1. `codex` 和 `cx` 到底差什么

- `cx` 就是 `codex --no-alt-screen`
- 二者的模型、工具能力、会话管理没有区别
- 唯一核心区别：界面是否使用 terminal 的 `alternate screen`

一句话记忆：

- `codex` = 临时全屏覆盖当前终端
- `cx` = 在当前终端历史下面继续输出

## 2. 什么叫“临时覆盖当前终端”

把终端想成有两张纸：

- 正常纸：你平时敲 `ls`、`git status`、报错输出的地方
- 临时纸：给 `vim`、`less`、`top` 这类全屏程序临时借用的地方

`codex` 默认会切到“临时纸”。

```text
你原来的终端内容
$ ls
README.md  src
$ git status
On branch main
$

运行：codex

┌──────────────────────────────┐
│ Codex 全屏界面               │
│ 对话区                       │
│ 状态区                       │
│ 输入框                       │
└──────────────────────────────┘
```

退出后：

```text
$ ls
README.md  src
$ git status
On branch main
$
```

重点：

- 原来的 shell 内容不是没了，只是被盖住了
- 退出后会回到原来的 shell 画面
- Codex 那段界面通常不会像普通 shell 输出一样保留在滚动历史里

## 3. 什么叫“直接接在当前终端历史下面继续输出”

`cx` 不切到“临时纸”，而是在当前终端历史下面直接继续画。

```text
$ ls
README.md  src
$ git status
On branch main
$

运行：cx

$ ls
README.md  src
$ git status
On branch main
$
[Codex started]
你：帮我看看这个项目
Codex：我先检查目录结构
Codex：正在读取 package.json
Codex：准备修改 src/app.ts
...
```

退出后：

```text
$ ls
README.md  src
$ git status
On branch main
$
[Codex started]
你：帮我看看这个项目
Codex：我先检查目录结构
Codex：正在读取 package.json
Codex：准备修改 src/app.ts
...
$
```

重点：

- 上翻还能看到刚才的 Codex 内容
- 它和 `ls`、`git status` 一样，变成了这份终端历史的一部分

## 4. 为什么 `cx` 更适合 Ghostty split / tmux / zellij

- 这些工具本来就是把一个 pane 当作“持续工作的终端”
- 你通常想保留这个 pane 之前的命令、日志、报错和路径
- 默认 `codex` 会把这些内容盖住，退出后才回来
- `cx` 会把 Codex 对话直接接在原有历史下面，滚动查看更自然

一句话：

- pane 是“工作台”时，用 `cx`
- pane 是“给 Codex 独占的小全屏窗口”时，用 `codex`

## 5. `cwd` 是什么

`cwd` = `current working directory` = 当前工作目录。

最简单理解：

- 你当前终端里 `pwd` 打印出来的路径
- 也是你启动这次 Codex 会话时所在的目录

例如：

```bash
cd ~/test
pwd
# /Users/daqian_mbp/test
cx
```

那么这次会话的 `cwd` 基本就是 `~/test`。

项目管理里的关键作用：

- `codex resume` 默认会优先显示当前 `cwd` 相关的会话
- 所以回到旧项目时，最好先 `cd` 到项目根目录再 `resume`

## 6. 项目、thread、session、turn 怎么理解

对日常使用来说，最实用的理解是：

- 项目 = 你的目录 / `cwd`
- thread 或 session = 一条保存下来的对话
- thread name = 这条对话的人类可读名字
- session ID = 这条对话的唯一 UUID
- turn = 这条对话里的一轮提问和回复

不要这样理解：

```text
项目
└─ thread
   └─ 多个 session
```

更适合你的理解是：

```text
项目 ~/test
├─ 对话 A
│  ├─ session/thread ID: 019c...
│  ├─ thread name: test: main
│  └─ 多轮对话
├─ 对话 B
│  ├─ session/thread ID: 019d...
│  ├─ thread name: test: experiment
│  └─ 多轮对话
└─ 对话 C
   └─ ...
```

## 7. `codex` / `resume` / `fork` / `/quit` 的关系

```text
项目目录：~/test

├─ 你运行：codex
│  或：cx
│
│  └─ 创建一条新对话
│     对话 A
│     - ID: 019c...111
│     - 名称: test: main
│     - 内容: 第1轮、第2轮、第3轮……
│
│     你输入：/quit
│     └─ 只是退出界面
│        对话 A 还在，没有消失
│
├─ 过一周后，你回到 ~/test
│  运行：codex resume
│  或：codex resume 019c...111
│  或：codex resume "test: main"
│
│  └─ 继续的还是 对话 A
│     - ID 还是 019c...111
│     - 不是新开一条
│     - 只是在原来后面继续加第4轮、第5轮……
│
└─ 如果你运行：codex fork 019c...111
   └─ 会复制出一条新分支
      对话 B
      - ID: 019d...222
      - 可命名: test: experiment
      - 开头继承 A 的上下文
      - 但从这里开始，A 和 B 分开发展
```

一句话：

- `codex` / `cx` = 新建一条
- `resume` = 回到旧的那条继续
- `fork` = 从旧的那条复制出新的一条
- `/quit` = 只是退出，不删除

## 8. 为什么你会看到很多 `resume` 项

最常见原因不是系统坏了，而是你这样用：

```text
第 1 天：cx      -> 新建 对话 A
第 2 天：cx      -> 新建 对话 B
第 3 天：codex   -> 新建 对话 C
```

结果：

```text
同一个项目下面
├─ 对话 A
├─ 对话 B
└─ 对话 C
```

也就是：你在应该 `resume` 的场景里，反复用了新建。

## 9. 最省脑力的 5 条项目管理规则

1. 总是先 `cd` 到项目根目录，再启动或恢复 Codex。
2. 一个项目尽量维护一条“主线程”，不要每次都直接 `codex` / `cx` 新开。
3. 回到旧项目时优先用 `codex resume` 或 `codex resume --last`。
4. 只有明确想开新话题时才直接 `codex` / `cx`；只有明确想分叉时才用 `codex fork`。
5. 长期线程请用 `/rename` 命名，名字尽量稳定、短、可搜索。

推荐命名：

- `test: main`
- `test: parser-bug`
- `terminal-config: main`

## 10. 最常用命令

```bash
# 在当前项目目录里新开一条对话
codex

# 在当前项目目录里新开一条对话，但保留滚动历史
cx

# 在当前项目目录里恢复某条旧对话
codex resume

# 直接恢复当前项目最近的一条
codex resume --last

# 查看所有项目的对话
codex resume --all

# 用 ID 精准恢复
codex resume 019cxxxxxxxxxxxxxxxx

# 基于旧对话分叉出一条新对话
codex fork 019cxxxxxxxxxxxxxxxx
```

## 11. 贴墙版超短总结

```text
cx = codex --no-alt-screen

codex  = 临时全屏覆盖当前终端
cx     = 直接接在当前终端历史下面继续输出

cwd    = 你当前所在目录（pwd）

codex/cx = 新建一条
resume   = 回到旧的那条
fork     = 从旧的那条分叉出新的一条
/quit    = 退出，但不删除

项目管理铁律：
先 cd 到项目根目录
主线用 resume
分叉用 fork
长期线程用 /rename
```
