# Claude Code Statusline

Claude Code のステータスバーに、作業状況・コンテキスト使用量・レート制限をリアルタイム表示するシェルスクリプトです。

## 表示イメージ

```
📁 crypto-trading │ 🤖 Claude Sonnet 4.6 │ $4.15 │ ✏️ +242/-3 │ 🔀 main
🧠 43% │ IN:251.6K  OUT:39.8K  cache:99%
⏱ 5h  ▰▱▱▱▱▱▱▱▱▱  15%  Resets 8pm (Asia/Tokyo)
📅 7d  ▰▰▱▱▱▱▱▱▱▱  17%  Resets Mar 14 at 3pm (Asia/Tokyo)
```

## 各指標の説明

### Line 1: セッション情報

| 項目 | 説明 |
|------|------|
| 📁 `crypto-trading` | 現在の作業フォルダ名 |
| 🤖 `Claude Sonnet 4.6` | 使用中のモデル |
| `$4.15` | セッション累計コスト ※注意点あり（後述） |
| ✏️ `+242/-3` | このセッションでの追加/削除行数 |
| 🔀 `main` | gitブランチ名（gitリポジトリ外では `--`） |

### Line 2: コンテキスト詳細

| 項目 | 説明 |
|------|------|
| 🧠 `43%` | コンテキストウィンドウの使用率（緑→黄→赤） |
| `IN:251.6K` | セッション累計の入力トークン数 |
| `OUT:39.8K` | セッション累計の出力トークン数 |
| `cache:99%` | キャッシュヒット率（高いほど効率的） |

> ⚠️ コンテキストが200kトークンを超えると `⚠ >200k` の警告が表示されます

### Line 3-4: レート制限（サブスクリプションユーザーのみ）

| 項目 | 説明 |
|------|------|
| `⏱ 5h` | 5時間枠の使用率とリセット時刻 |
| `📅 7d` | 週次枠の使用率とリセット日時 |

> APIキーのみのユーザーには Line 3-4 は表示されません（macOS Keychain の OAuth トークンが必要）

### コスト表示について

`$4.15` はAPIの標準単価 × 使用トークン数で **Claude Code がローカルで計算した仮想コスト** です。

- **APIキー課金ユーザー** → 実際の請求額と一致
- **サブスクリプションユーザー（Max/Pro）** → 実際には課金されない。「どれだけの計算量を使ったか」の相対指標として活用できる（複雑な指示 = 高コスト、効率的な指示 = 低コスト）

## インストール

### 1コマンドでインストール

```bash
curl -fsSL https://raw.githubusercontent.com/SATOYUSUKE/claude-statusline/main/install.sh | bash
```

### 手動インストール

```bash
# スクリプトをダウンロード
curl -fsSL https://raw.githubusercontent.com/SATOYUSUKE/claude-statusline/main/statusline.sh \
  -o ~/.claude/statusline.sh
chmod +x ~/.claude/statusline.sh

# ~/.claude/settings.local.json に追記
# "statusLine": { "type": "command", "command": "bash ~/.claude/statusline.sh" }
```

## 動作環境

- macOS（Linux は Line 3-4 の日付フォーマットが動作しない場合あり）
- Claude Code v1.x 以上
- `jq` コマンド（`brew install jq`）
- `bc` コマンド（macOS 標準搭載）
- サブスクリプション（Max/Pro）利用者は Line 3-4 も表示

## クレジット

- ベーススクリプト: [@suthio](https://zenn.dev/suthio/articles/f832922e18f994)
- 各指標の整理・改善: [@SATOYUSUKE](https://github.com/SATOYUSUKE)
