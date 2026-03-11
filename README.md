# claude-statusline

```
📁 crypto-trading │ 🤖 Claude Sonnet 4.6 │ $4.15 │ ✏️ +242/-3 │ 🔀 main
🧠 43% │ IN:251.6K  OUT:39.8K  cache:99%
⏱ 5h  ▰▰▱▱▱▱▱▱▱▱  19%  Resets 8pm (Asia/Tokyo)
📅 7d  ▰▰▱▱▱▱▱▱▱▱  17%  Resets Mar 14 at 3pm (Asia/Tokyo)
```

> **Claude Code のステータスバーに、作業状況・コンテキスト・レート制限を常時表示するシェルスクリプト**

---

## 日本語 | [English](#english)

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

- ベーススクリプト: [@suthio](https://zenn.dev/suthio/articles/f832922e18f994)
- 指標設計・改善: [@SATOYUSUKE](https://github.com/SATOYUSUKE)

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

### Requirements

- macOS (recommended) / Linux
- Claude Code v1.x+
- `jq` (`brew install jq`)
- Subscription (Max/Pro) required for Line 3-4

### Credits

- Base script: [@suthio](https://zenn.dev/suthio/articles/f832922e18f994)
- Metrics design & improvements: [@SATOYUSUKE](https://github.com/SATOYUSUKE)
