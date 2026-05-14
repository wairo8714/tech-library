# 蔵書管理CLIアプリ 仕様書

## 目的

社内参考書の所在、重複購入、検索、貸出状況を管理できるCLIアプリを作る。

## 解決したい課題

- 社内に置いてある本を重複購入してしまう
- 本の所在分からない(どこにあるのか・貸出中なのか)

## 利用者

- 社員

## 制約

- Rubyで実装する
- CLIアプリとして実装する
- データはJSONファイルで管理する

## 使用するJSONファイル

| ファイル | 用途 |
| --- | --- |
| `books.json` | 書籍情報を管理する |
| `users.json` | 利用者情報を管理する |
| `checkouts.json` | 貸出情報を管理する |
| `session.json` | ログイン中の利用者情報を管理する |

## データモデル

### Book

本そのものを管理する。

| 項目 | 型 | 説明 |
| --- | --- | --- |
| `id` | `int` | 書籍ID 主キー |
| `title` | `string` | タイトル |
| `authors` | `array[string]` | 作者 |
| `genres` | `array[string]` | ジャンル |
| `location` | `string` | 保管場所 |

#### 備考

- 貸出中かどうかは `books.json` に保存しない
- 貸出状況は `checkouts.json` を参照して判定する

### User

利用者を管理する。

| 項目 | 型 | 説明 |
| --- | --- | --- |
| `id` | `int` | 社員ID。主キー |
| `name` | `string` | 社員名 |

### Checkout

誰がどの本を借りたのかを管理する。

| 項目 | 型 | 説明 |
| --- | --- | --- |
| `id` | `int` | 貸出No.。主キー |
| `book_id` | `int` | 書籍ID。外部キー |
| `user_id` | `int` | 社員ID。外部キー |
| `checkout_date` | `Date` | 貸出日 |
| `due_date` | `Date` | 返却予定日 |
| `returned_at` | `Date or null` | 返却日 |

#### 備考

- `returned_at` が `null` の場合は未返却とする
- `returned_at` に日付が入っている場合は返却済みとする

## CLIコマンド

### サインアップ

```sh
ruby app.rb signup "山田太郎"
```

| 引数 | 内容 |
| --- | --- |
| `ARGV[0]` | `signup` |
| `ARGV[1]` | `name` |

#### 処理内容

- 名前を受け取る
- 社員IDを自動採番する(E000..999)
- `users.json` に保存する

#### 備考

- 名前の重複は許可する
- 社員IDで一意に管理する

### ログイン

```sh
ruby app.rb login 1
```

| 引数 | 内容 |
| --- | --- |
| `ARGV[0]` | `login` |
| `ARGV[1]` | `employee_id` |

#### 処理内容

- 社員IDが存在するか確認する
- 存在すれば `session.json` にログイン情報を保存する
- ログイン後、ログインが必要なコマンドを使用できるようにする

### ログアウト

```sh
ruby app.rb logout
```

| 引数 | 内容 |
| --- | --- |
| `ARGV[0]` | `logout` |

#### 処理内容

- `session.json` を削除、または中身を空にする

#### 備考

- 自動ログアウト機能は余力があれば実装する

### 登録

```sh
ruby app.rb add "リーダブルコード" "Dustin Boswell,Trevor Foucher" "Programming,CodeQuality" "アネックス"
```

| 引数 | 内容 |
| --- | --- |
| `ARGV[0]` | `add` |
| `ARGV[1]` | `title` |
| `ARGV[2]` | `authors` |
| `ARGV[3]` | `genres` |
| `ARGV[4]` | `location` |

#### 処理内容

- 本を新規登録する
- 書籍IDを自動採番する
- 作者・ジャンルはカンマ区切りで受け取り、配列として保存する

### 検索

```sh
ruby app.rb search ruby
ruby app.rb search ruby rails
```

| 引数 | 内容 |
| --- | --- |
| `ARGV[0]` | `search` |
| `ARGV[1..n]` | `search_criteria` |

#### 処理内容

- タイトル、作者、ジャンル、保管場所を対象に検索する
- 複数条件が指定された場合はAND検索とする
- 検索結果には貸出状況も表示する

#### 貸出状況の判定

- `checkouts.json` を参照する
- 該当する `book_id` かつ `returned_at` が `null` の貸出があれば貸出中とする
- 上記に該当する貸出がなければ貸出可能とする

### 本の詳細表示

```sh
ruby app.rb book 1
```

| 引数 | 内容 |
| --- | --- |
| `ARGV[0]` | `book` |
| `ARGV[1]` | `book_id` |

#### 処理内容

- 指定された本の詳細を表示する
- 貸出状況も表示する

#### 表示例

```text
ID: 1
Title: リーダブルコード
Authors: Dustin Boswell, Trevor Foucher
Genres: Programming, Code Quality
Location: 棚A
Status: 貸出中
Due date: 2026-05-30
Borrower: 山田太郎
```

### 貸出

```sh
ruby app.rb checkout 1 2026-05-14
```

| 引数 | 内容 |
| --- | --- |
| `ARGV[0]` | `checkout` |
| `ARGV[1]` | `book_id` |
| `ARGV[2]` | `checkout_date` |

#### 処理内容

- ログイン済みユーザーを貸出者として扱う
- 指定された本が存在するか確認する
- 貸出中でないか確認する
- 貸出可能であれば `checkouts.json` に貸出情報を追加する
- `due_date` を設定する

#### 貸出中の場合

- `AlreadyCheckout` エラーを出力する
- `due_date` を表示する
- 返却予定日を過ぎている場合は警告を表示する

#### 警告例

```text
AlreadyCheckout: この本は貸出中です。
Due date: 2026-05-10
Warning: 返却期限を超過しています。利用者にご確認ください。
```

### 自分の貸出一覧

```sh
ruby app.rb loans
```

| 引数 | 内容 |
| --- | --- |
| `ARGV[0]` | `loans` |

#### 処理内容

- ログイン中ユーザーの未返却貸出一覧を表示する
- 返却時に必要な `checkout_id` も表示する

#### 表示項目

- 貸出No.
- 書籍ID
- タイトル
- 貸出日
- 返却予定日

### 返却

```sh
ruby app.rb return 3
```

| 引数 | 内容 |
| --- | --- |
| `ARGV[0]` | `return` |
| `ARGV[1]` | `checkout_id` |

#### 処理内容

- 指定された貸出No.が存在するか確認する
- ログイン中ユーザー本人の貸出か確認する
- 未返却であることを確認する
- `returned_at` に返却日を入れる

#### 備考

- `checkout_id` は `loans` コマンドで確認する

### 履歴

```sh
ruby app.rb history
```

| 引数 | 内容 |
| --- | --- |
| `ARGV[0]` | `history` |

#### 処理内容

- ログイン中ユーザーの貸出履歴を表示する
- 返却済み・未返却の両方を表示する

#### 表示項目

- 貸出No.
- 書籍ID
- タイトル
- 貸出日
- 返却予定日
- 返却日

## ログイン要否

### ログインが必要なコマンド

- `add`
- `checkout`
- `return`
- `loans`
- `history`

### ログイン不要のコマンド

- `signup`
- `login`
- `logout`
- `search`
- `book`

## 貸出状態の考え方

`books.json` には貸出状態を保存しない。

貸出中かどうかは、毎回 `checkouts.json` を参照して判定する。

判定条件:

- `book_id` が一致する
- かつ `returned_at` が `null`

この条件に一致する `Checkout` が存在する場合、その本は貸出中とする。

## 余力があれば

- 自動ログアウト
- 管理者権限
- 貸出期限超過者への通知
