# claude-statusline

```
📁 crypto-trading │ 🤖 Claude Sonnet 4.6 │ $4.15 │ ✏️ +242/-3 │ 🔀 main
🧠 43% │ IN:251.6K  OUT:39.8K  cache:99%
⏱ 5h  ▰▰▱▱▱▱▱▱▱▱  19%  Resets 8pm (Asia/Tokyo)
📅 7d  ▰▰▱▱▱▱▱▱▱▱  17%  Resets Mar 14 at 3pm (Asia/Tokyo)
```

> **Claude Code のステータスバーに、作業状況・コンテキスト・レート制限を常時表示するシェルスクリプト**

---

## 日本語 | [English](#english) | [中文](#中文)

### これは何？

Claude Code のステータスバー（画面下部）に以下の情報をリアルタイム表示します。

| 行 | 表示内容 |
|----|---------|
| Line 1 | 📁 作業フォルダ　🤖 モデル　💰 コスト　✏️ 編集行数　🔀 gitブランチ |
| Line 2 | 🧠 コンテキスト使用率　入出力トークン数　キャッシュ率 |
| Line 3 | ⏱ 5時間枠の使用率・リセット時刻 |
| Line 4 | 📅 週次枠の使用率・リセット日時 |

### 各指標の説明

**📁 作業フォルダ名**
現在どのプロジェクトで作業しているかを常に表示します。複数のウィンドウを開いているときに特に便利です。

**🤖 モデル名**
現在使用中のモデル（例: `Claude Sonnet 4.6`）を表示します。

**💰 コスト（`$4.15`）**
セッション累計コストです。**注意：これは仮想コストです。**
Claude Code がローカルで「使用トークン数 × API 標準単価」で計算した推定値であり、実際の請求額ではありません。
- **APIキー課金ユーザー** → 実際の請求額とほぼ一致
- **サブスクリプションユーザー（Max/Pro）** → 実際には課金されない。「どれだけ複雑な作業をしたか」の相対指標として活用できます（複雑な指示 = 高コスト、効率的な指示 = 低コスト）

**✏️ 編集行数（`+242/-3`）**
このセッションで追加・削除した行数の累計です。

**🔀 gitブランチ名**
現在のブランチを表示します。gitリポジトリ外では `--` と表示されます。

**🧠 コンテキスト使用率（`43%`）**
コンテキストウィンドウの使用率です。色で状態が変わります。
- 🟢 緑（〜49%）: 余裕あり
- 🟡 黄（50〜79%）: 注意
- 🔴 赤（80%〜）: 残り僅か
- ⚠️ `>200k` アラート: 200kトークン超過時に警告表示

**IN / OUT / cache**
- `IN:251.6K` — セッション累計の入力トークン数
- `OUT:39.8K` — セッション累計の出力トークン数
- `cache:99%` — キャッシュヒット率。高いほど効率的に会話が再利用されています

**⏱ 5h / 📅 7d（Line 3-4）**
Anthropic のサブスクリプション制限（5時間枠・週次枠）の使用率とリセット時刻です。
macOS キーチェーンの OAuth トークンを使って取得します。**APIキーのみのユーザーには表示されません。**

### インストール（3ステップ）

**1.** ターミナルを開く

**2.** 以下をコピペして Enter:

```bash
curl -fsSL https://raw.githubusercontent.com/SATOYUSUKE/claude-statusline/main/install.sh | bash
```

**3.** Claude Code を再起動

### アンインストール

```bash
curl -fsSL https://raw.githubusercontent.com/SATOYUSUKE/claude-statusline/main/uninstall.sh | bash
```

Claude Code を再起動すれば元に戻ります。

### 手動インストール

```bash
# スクリプトをダウンロード
curl -fsSL https://raw.githubusercontent.com/SATOYUSUKE/claude-statusline/main/statusline.sh \
  -o ~/.claude/statusline.sh
chmod +x ~/.claude/statusline.sh
```

`~/.claude/settings.local.json` に以下を追記:

```json
{
  "statusLine": {
    "type": "command",
    "command": "bash ~/.claude/statusline.sh"
  }
}
```

### 動作環境

| 項目 | 要件 |
|------|------|
| OS | macOS（推奨）/ Linux |
| Claude Code | v1.x 以上 |
| 依存コマンド | `jq`（`brew install jq`）、`bc`（macOS 標準） |
| Line 3-4 表示 | macOS + Claude サブスクリプション（Max/Pro）が必要 |

<details>
<summary>トラブルシューティング</summary>

**2〜4行目が表示されず、更新通知が出ている**
→ Claude Code 本体のアップデートエラーが発生しており、ステータスラインの表示領域を占有している場合があります。以下のコマンドで更新してください：
```bash
claude install
```
または
```bash
npm i -g @anthropic-ai/claude-code
```

**ステータスラインが表示されない**
→ Claude Code を完全に終了して再起動してください。設定変更はセッション再起動後に反映されます。

**`jq: command not found`**
→ `brew install jq` を実行してください。

**Line 3-4 が表示されない（サブスクユーザーなのに）**
→ Claude Code に ChatGPT/Claude アカウントでログインしているか確認してください。APIキーのみの認証では OAuth トークンが取得できません。

**`IN:0 OUT:0 cache:0%` と表示される**
→ セッション開始直後は 0 になります。数回やり取りをすると更新されます。

**ブランチ名が `--` と表示される**
→ 正常動作です。gitリポジトリ外（ホームディレクトリ等）で起動しているためです。
プロジェクトディレクトリで `claude` を起動すると正しく表示されます。

</details>

### クレジット

| 参考元 | 実装に取り込んだ内容 |
|--------|-------------------|
| [@suthio](https://zenn.dev/suthio/articles/f832922e18f994) | スクリプト本体・OAuth APIで5h/7d レート制限取得・プログレスバー（▰▱）・カラーコーディング・APIレスポンスのキャッシュ機構 |
| [@tonkotsuboy_com](https://x.com/tonkotsuboy_com/status/2031168969705734605) | Line 1 へのフォルダ名表示（`${cwd##*/}`） |
| [@ariyasu](https://x.com/ariyasu) | IN/OUTトークン数表示・キャッシュヒット率表示・コスト表示（`$X.XX`）・コストを複雑さの指標として捉える考え方 |
| [@Develop0x](https://x.com/Develop0x) | `>200k` アラートのアイデア（`exceeds_200k_tokens` フィールドを使って実装） |
| [usedhonda/ccsl](https://github.com/usedhonda/statusline) | 週次予算・スパークライン表示の概念（設計の参考） |
| [@SATOYUSUKE](https://github.com/SATOYUSUKE) | 上記の統合・gitリポジトリ外での `--` 表示・正しいJSONフィールドパスの特定・各指標のMECE整理 |

---

## English

### What is this?

A shell script that displays real-time information in Claude Code's status bar (bottom of screen).

| Line | Content |
|------|---------|
| Line 1 | 📁 Folder　🤖 Model　💰 Cost　✏️ Lines changed　🔀 Git branch |
| Line 2 | 🧠 Context usage　Token counts　Cache hit rate |
| Line 3 | ⏱ 5-hour rate limit usage + reset time |
| Line 4 | 📅 Weekly rate limit usage + reset date |

### Key metrics explained

**💰 Cost (`$4.15`)**
This is a **virtual/estimated cost**, not your actual bill.
Claude Code calculates this locally as `tokens used × standard API price`.
- **API key users** → Matches your actual charges
- **Subscription users (Max/Pro)** → Not actually billed. Use as a proxy for session complexity (high cost = complex prompts, low cost = efficient prompts)

**🧠 Context (`43%`)**
Context window usage. Color changes: 🟢 green (<50%) → 🟡 yellow (50-79%) → 🔴 red (80%+).
Shows `⚠ >200k` alert when exceeding 200k tokens.

**cache rate**
Percentage of input tokens served from cache. Higher = more efficient conversation reuse.

**Line 3-4 (Rate limits)**
Subscription usage limits (5-hour window and weekly window) via Anthropic OAuth API.
**Only available for macOS + subscription users (Max/Pro).**

### Install

```bash
curl -fsSL https://raw.githubusercontent.com/SATOYUSUKE/claude-statusline/main/install.sh | bash
```

Then restart Claude Code.

### Uninstall

```bash
curl -fsSL https://raw.githubusercontent.com/SATOYUSUKE/claude-statusline/main/uninstall.sh | bash
```

Then restart Claude Code.

### Requirements

- macOS (recommended) / Linux
- Claude Code v1.x+
- `jq` (`brew install jq`)
- Subscription (Max/Pro) required for Line 3-4

> **Note:** If Claude Code shows an auto-update error, lines 2-4 may not appear until you update: `claude install` or `npm i -g @anthropic-ai/claude-code`

### Credits

| Author | What was adopted |
|--------|-----------------|
| [@suthio](https://zenn.dev/suthio/articles/f832922e18f994) | Base script, OAuth API for 5h/7d rate limits, progress bar (▰▱), color coding, API response cache |
| [@tonkotsuboy_com](https://x.com/tonkotsuboy_com/status/2031168969705734605) | Folder name in Line 1 (`${cwd##*/}`) |
| [@ariyasu](https://x.com/ariyasu) | IN/OUT token display, cache hit rate, cost display (`$X.XX`), the idea of using cost as a complexity proxy |
| [@Develop0x](https://x.com/Develop0x) | `>200k` alert concept (implemented via `exceeds_200k_tokens` field) |
| [usedhonda/ccsl](https://github.com/usedhonda/statusline) | Weekly budget & sparkline concepts (design reference) |
| [@SATOYUSUKE](https://github.com/SATOYUSUKE) | Integration of all above, `--` branch for non-git dirs, correct JSON field path discovery, MECE metrics design |

---

## 中文

### 这是什么？

在 Claude Code 状态栏（屏幕底部）实时显示以下信息的 Shell 脚本。

| 行 | 显示内容 |
|----|---------|
| 第1行 | 📁 工作目录　🤖 模型　💰 费用　✏️ 修改行数　🔀 Git 分支 |
| 第2行 | 🧠 上下文使用率　输入/输出 Token 数　缓存命中率 |
| 第3行 | ⏱ 5小时限额使用率和重置时间 |
| 第4行 | 📅 每周限额使用率和重置日期 |

### 各指标说明

**💰 费用（`$4.15`）**
这是**虚拟费用，并非实际账单金额。**
Claude Code 在本地按「使用 Token 数 × API 标准单价」计算的估算值。
- **API Key 用户** → 与实际收费基本一致
- **订阅用户（Max/Pro）** → 实际不收费。可作为「本次会话消耗了多少算力」的相对指标（复杂指令 = 高费用，高效指令 = 低费用）

**🧠 上下文使用率（`43%`）**
上下文窗口的使用率，颜色随使用量变化。
- 🟢 绿色（～49%）：充裕
- 🟡 黄色（50～79%）：注意
- 🔴 红色（80%～）：剩余不多
- ⚠️ `>200k` 警告：超过 200k Token 时显示

**IN / OUT / cache**
- `IN:251.6K` — 本次会话累计输入 Token 数
- `OUT:39.8K` — 本次会话累计输出 Token 数
- `cache:99%` — 缓存命中率。越高说明对话复用效率越好

**⏱ 5h / 📅 7d（第3-4行）**
Anthropic 订阅限额（5小时窗口和每周窗口）的使用率及重置时间。
通过 macOS Keychain 中的 OAuth Token 获取。**仅 API Key 用户不显示此内容。**

### 安装（3步）

**1.** 打开终端

**2.** 复制粘贴以下命令并按 Enter:

```bash
curl -fsSL https://raw.githubusercontent.com/SATOYUSUKE/claude-statusline/main/install.sh | bash
```

**3.** 重启 Claude Code

### 卸载

```bash
curl -fsSL https://raw.githubusercontent.com/SATOYUSUKE/claude-statusline/main/uninstall.sh | bash
```

重启 Claude Code 后即可恢复原状。

### 运行环境

| 项目 | 要求 |
|------|------|
| 操作系统 | macOS（推荐）/ Linux |
| Claude Code | v1.x 以上 |
| 依赖命令 | `jq`（`brew install jq`）、`bc`（macOS 自带） |
| 第3-4行显示 | 需要 macOS + Claude 订阅（Max/Pro） |

<details>
<summary>常见问题</summary>

**第2〜4行不显示，出现更新通知**
→ Claude Code 本体更新失败，占用了状态栏显示区域。请执行以下命令更新：
```bash
claude install
```
或
```bash
npm i -g @anthropic-ai/claude-code
```

**状态栏未显示**
→ 请完全退出 Claude Code 后重新启动。配置更改在重启后生效。

**`jq: command not found`**
→ 执行 `brew install jq`。

**第3-4行不显示（明明是订阅用户）**
→ 请确认是否通过 ChatGPT/Claude 账号登录 Claude Code。仅使用 API Key 认证时无法获取 OAuth Token。

**显示 `IN:0 OUT:0 cache:0%`**
→ 会话刚开始时显示为 0，属于正常现象。进行几次对话后会更新。

**分支名显示为 `--`**
→ 正常现象。表示当前在 Git 仓库目录以外（如主目录）启动了 Claude Code。
在项目目录下启动 `claude` 即可正常显示。

</details>

### 致谢

| 参考来源 | 实际采用的内容 |
|---------|--------------|
| [@suthio](https://zenn.dev/suthio/articles/f832922e18f994) | 基础脚本、通过 OAuth API 获取5h/7d 限额、进度条（▰▱）、颜色编码、API 响应缓存机制 |
| [@tonkotsuboy_com](https://x.com/tonkotsuboy_com/status/2031168969705734605) | 在第1行显示目录名（`${cwd##*/}`） |
| [@ariyasu](https://x.com/ariyasu) | IN/OUT Token 数显示、缓存命中率显示、费用显示（`$X.XX`）、将费用作为复杂度指标的理念 |
| [@Develop0x](https://x.com/Develop0x) | `>200k` 警告的构思（通过 `exceeds_200k_tokens` 字段实现） |
| [usedhonda/ccsl](https://github.com/usedhonda/statusline) | 每周预算与 Sparkline 可视化概念（设计参考） |
| [@SATOYUSUKE](https://github.com/SATOYUSUKE) | 以上内容的整合、非 Git 目录显示 `--`、正确 JSON 字段路径的发现、各指标的 MECE 整理 |
