# Codex CLI 一页海报

## 核心区别

- `cx` = `codex --no-alt-screen`
- 功能不变，只改界面显示方式

```text
codex  = 临时全屏覆盖当前终端
cx     = 直接接在当前终端历史下面继续输出
```

## 两张纸比喻

```text
正常纸 = 你平时敲命令的地方
临时纸 = 给全屏程序临时借用的地方
```

- `codex`：切到临时纸
- `cx`：不换纸，直接在正常纸下面继续写

## 什么时候用哪个

- 想要干净、像独立全屏工具：用 `codex`
- 想保留历史、方便上翻：用 `cx`
- 在 Ghostty split / tmux / zellij 里，通常更推荐 `cx`

## `cwd` 是什么

```text
cwd = current working directory = 当前工作目录
```

- 基本就是你当前 `pwd` 的路径
- 项目管理时，先 `cd` 到项目根目录再启动或恢复 Codex

## 正确的心智模型

```text
项目 = 目录 / cwd
一条 thread 或 session = 一条保存下来的对话
thread name = 这条对话的名字
session ID = 这条对话的唯一 UUID
turn = 这条对话里的一轮问答
```

不要想成：

```text
项目
└─ thread
   └─ 多个 session
```

更应该想成：

```text
项目 ~/test
├─ 对话 A
├─ 对话 B
└─ 对话 C
```

## 三个动作的区别

```text
codex / cx = 新建一条对话
resume     = 回到旧的那条继续
fork       = 从旧的那条分叉出新的一条
/quit      = 退出，但不删除
```

## 为什么你的 `resume` 列表会很长

```text
第1天：cx      -> 新建 A
第2天：cx      -> 新建 B
第3天：codex   -> 新建 C
```

结果：

```text
同一个项目里出现很多条独立对话
```

也就是：应该 `resume` 的时候，你反复用了新建。

## 5 条项目管理规则

1. 总是先 `cd` 到项目根目录。
2. 一个项目尽量维护一条主线程。
3. 回到旧项目优先用 `codex resume` 或 `codex resume --last`。
4. 需要分叉实验时用 `codex fork`，不要乱开新线程。
5. 长期线程用 `/rename` 命名。

## 推荐命名

- `test: main`
- `test: experiment`
- `terminal-config: main`

## 最常用命令

```bash
codex
cx
codex resume
codex resume --last
codex resume --all
codex resume <SESSION_ID>
codex fork <SESSION_ID>
```

## 贴墙总结

```text
先 cd 到项目根目录
主线用 resume
分叉用 fork
长期线程用 /rename

codex = 临时全屏
cx    = 保留滚动历史
```
