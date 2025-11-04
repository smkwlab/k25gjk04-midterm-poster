# ビルド高速化ガイド

'`a0poster.tex` のビルド時間を短縮する方法を説明します。

## 📊 ビルド時間の比較

| モード | パス数 | SyncTeX | 時間 | 用途 |
|--------|--------|---------|------|------|
| **編集用（推奨）** | 1 | 無         | **~5秒** | 保存のたびの確認 |
 | 最終調整・提出前 |

---

## 🚀 クイックスタート

### 編集中（高速ビルド）
```bash
DRAFT_MODE=1 latexmk a0poster.tex
```
- **約5秒**で完了
- 相互参照は更新されない（目次や引用番号がある場合は注意）
- PDF ↔ ソース間のジャンプ機能なし

### 提出前（完全ビルド）
```bash
latexmk a0poster.tex
```
- 約15秒で完了
- すべての参照が正しく更新される
- SyncTeX 有効（PDF ↔ ソース間ジャンプ可能）

---

## 🔧 設定の詳細

### `.latexmkrc` の仕組み

`DRAFT_MODE` の有無で動作を切り替えます：

```perl
if ($ENV{'DRAFT_MODE'}) {
    # 編集用: 1パス、SyncTeX無効
    $lualatex = 'lualatex -halt-on-error -interaction=nonstopmode';
    $max_repeat = 1;
} else {
    # 提出用: 2パス、SyncTeX有効
    $lualatex = 'lualatex -halt-on-error -interaction=nonstopmode -synctex=1';
}
```

---

## 📖 SyncTeX とは？

**SyncTeX** = PDF ↔ TeX ソースコード間の双方向ジャンプ機能

### できること
- **PDF → ソース**: PDF ビューアで箇所をクリック → エディタの該当行へジャンプ
- **ソース → PDF**: エディタで `Ctrl+Alt+J` (macOS: `Cmd+Option+J`) → PDF の該当位置へジャンプ

### コスト
- 生成に **約4〜5秒かかる**
- --------は不要なことが多い

### 使い分け
- ✅ 編集中: **無効**（速度優先）
- ✅ 最終調整・レビュー時: **有効**（便利さ優先）

---

## ⚡ さらなる高速化（オプション）

### カスタムフォーマットファイル（myformat.fmt）

bash -lc 'rm -f a0poster.{aux,log,fdb_latexmk,fls,pdf}; /usr/bin/time -v latexmk -pdf -pdflatex="lualatex -halt-on-error -interaction=nonstopmode -recorder" a0poster.5秒 → 4.7秒）

#### 作成方法
```bash
export LANG=C LC_ALL=C
lualatex -ini -interaction=nonstopmode -jobname="myformat" myformat.ini
```

#### 使用方法
`.latexmkrc` の最終行のコメントを外す：
```perl
$lualatex =~ s/lualatex/lualatex -fmt=myformat/;
```

#### 注意事項
- luatexja のみプリロード（tikzposter はフォーマットに含められない）
- 効果は限定的（~6%の改善）
- パッケージ更新時は再生成が必要

---

## 🛠️ トラブルシューティング

### エラー: "This package requires Lua(HB)(La)TeX"
**原因**: pdfTeX で実行されている

**解決策**:
```bash
# プロジェクト直'EOF'>
cd /workspaces/k25gjk04-midterm-poster
latexmk a0poster.tex
```

### ロケールエラーが出る場合
```bash
export LANG=C LC_ALL=C
latexmk a0poster.tex
```

### 
1. **編集中は DRAFT_MODE を使う**
   ```bash
   DRAFT_MODE=1 latexmk a0poster.tex
   ```

bash -lc 'rm -f a0poster.{aux,log,fdb_latexmk,fls,pdf}; /usr/bin/time -v latexmk -pdf -pdflatex="lualatex -halt-on-error -interaction=nonstopmode -recorder" a0poster.tex' **
   ```bash
   latexmk -C
   latexmk a0poster.tex
   ```

---

## 📝 VS Code での使用

### LaTeX Workshop の設定

bash -lc 'rm -f a0poster.{aux,log,fdb_latexmk,fls,pdf}; /usr/bin/time -v latexmk -pdf -pdflatex="lualatex -halt-on-error -interaction=nonstopmode -recorder" a0poster.

```json
{
  "latex-workshop.latex.tools": [
    {
      "name": "latexmk (draft)",
      "command": "latexmk",
      "args": ["-pdf", "-interaction=nonstopmode", "-file-line-error"],
      "env": {
        "DRAFT_MODE": "1"
      }
    },
    {
      "name": "latexmk (full)",
      "command": "latexmk",
      "args": ["-pdf", "-interaction=nonstopmode", "-file-line-error"]
    }
  ]
}
```

---

## 📌 まとめ

### 日常の編集作業
```bash
DRAFT_MODE=1 latexmk a0poster.tex  # 約5秒
```

### 提出前・最終確認
```bash
latexmk a0poster.tex  # 約15秒（SyncTeX有効）
```

**時間短縮の内訳**:
- 1パス化: **-67%** （15秒 → 5秒）
- SyncTeX無効: **-31%** （15秒 → 10秒）
 → 4.7秒、オプション）

---

**問い合わせ**: ビルドに問題がある場合は、ログファ `a0poster.log` を確認してください。

---

## 🖥️ VS Code での使い

### 自動ビルド設定（既に有効）

bash -lc 'rm -f a0poster.{aux,log,fdb_latexmk,fls,pdf}; /usr/bin/time -v latexmk -pdf -pdflatex="lualatex -halt-on-error -interaction=nonstopmode -recorder" a0poster.tex'
- `.vscode/settings.json` に2つのレシピを用意
- **デフォルト**: 高速ビルド（編集用）
- **手動選択**: 完全ビルド（提出用）

### ビルドレシピの選択

#### 方法1: コマンドパレットから
1. `Ctrl+Shift+P` (macOS: `Cmd+Shift+P`)
2. "LaTeX Workshop: Build with recipe" を選択
3. レシピを選択：
   - 📝 **compile (fast - for editing)** → 約5秒（編集中）
   - 🎯 **compile (full - for submission)** → 約10秒（提出前）

#### 方法2: ショートカット
- `Ctrl+Alt+B` (macOS: `Cmd+Option+B`) → レシピ選択画面

### 保存時の動作

 (`Ctrl+S` / `Cmd+S`) すると：
- 自動的に**最後に使ったレシピ**でビルド
- 初回は "compile (fast - for editing)" がデフォルト
- PDF が自動更新される

### おすすめワークフロー

**日常の編集作業**:
1. ファイルを編集
2. `Ctrl+S` で保存 → 高速ビルド（約5秒）
3. PDF で結果確認
4. 繰り返し

**提出前の最終確認**:
1. `Ctrl+Shift+P` → "LaTeX Workshop: Build with recipe"
2. "compile (full - for submission)" を選択
3. 完全版（約10秒、SyncTeX有効）でビルド
4. PDF を最終チェック

### トラブルシューティング

**ビルドが始まらない場合**:
- VS Code をリロード: `Ctrl+Shift+P` → "Reload Window"

**:
- `.vscode/settings.json` が正しく読み込まれているか確認
- LaTeX Workshop 拡張機能がインストールされているか確認

bash -**:'rm -f a0poster.{aux,log,fdb_latexmk,fls,pdf}; /usr/bin/time -v latexmk -pdf -pdflatex="lualatex -halt-on-error -interaction=nonstopmode -recorder" a0poster.tex'
- OUTPUT パネル → "LaTeX Workshop" タブでログ確
- クリーンビルド: `Ctrl+Shift+P` → "LaTeX Workshop: Clean up auxiliary files"

---

**設定ファイル**: `.vscode/settings.json`  
**バックアップ**: `.vscode/settings.json.bak`（元の設定）
