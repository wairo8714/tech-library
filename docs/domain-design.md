# ドメイン設計

## 目的

実装前にアプリで扱うドメインと責務を整理する。
Book / Location / BookPlacement / Checkout の関係を明確にし、モデルの責務が混ざらないようにする。

## 現状の課題と方針

Book に location を持たせると、Book が「本そのもの」と「場所」の両方を表してしまう。

場所は本そのものの属性ではなく、施設・部屋・本棚などに変化しうる別の概念である。
そのため、場所は Location として表し、Book と Location の関係は BookPlacement として表す。

現在誰が本を所有しているかは Book には持たせず、Checkout が user_id と book_id を持つことで管理する。

## フローチャート図

```mermaid
flowchart TD
    subgraph Presentation["CLI"]
        CLI["app.rb"]
    end

    subgraph Application["Service"]
        BookService["BookService"]
        UserService["UserService"]
        CheckoutService["CheckoutService"]
    end

    subgraph Domain["Domain Model"]
        BookList["BookList"]
        Book["Book"]
        Location["Location"]
        BookPlacement["BookPlacement"]
        User["User"]
        Checkout["Checkout"]
    end

    subgraph Infrastructure["Infrastructure / Repository"]
        BooksRepository["BooksRepository"]
        LocationsRepository["LocationsRepository"]
        BookPlacementsRepository["BookPlacementsRepository"]
        UserRepository["UserRepository"]
        CheckoutRepository["CheckoutRepository"]
        SessionRepository["SessionRepository"]
    end

    subgraph DataStore["Data Store / JSON"]
        BooksJson["books.json"]
        LocationsJson["locations.json"]
        BookPlacementsJson["book_placements.json"]
        UsersJson["users.json"]
        CheckoutsJson["checkouts.json"]
        SessionJson["session.json"]
    end

    Presentation --> Application
    Application --> Domain
    Application --> Infrastructure
    Infrastructure --> DataStore
```

## E-R 図

```mermaid
erDiagram
    BOOK ||--o{ BOOK_PLACEMENT : placed_as
    LOCATION ||--o{ BOOK_PLACEMENT : has
    USER ||--o{ CHECKOUT : borrows
    BOOK ||--o{ CHECKOUT : checked_out_as

    BOOK {
        int id
        string title
        string[] authors
        string[] genres
    }

    LOCATION {
        int id
        string name
    }

    BOOK_PLACEMENT {
        int placement_id
        int book_id
        int location_id
    }

    USER {
        int id
        string name
    }

    CHECKOUT {
        int id
        int book_id
        int user_id
        date checkout_date
        date due_date
        date returned_at
    }
```

## 各モデルの責務

### BookList

Book の集合操作をまとめる。

持つもの:

- books

持たないもの:

- 保存形式
- 表示形式
- ログイン状態

### Book

本そのものの情報を表す。

持つもの:

- id
- title
- authors
- genres

持たないもの:

- 場所
- 現在の所有者
- 貸出状態
- 保存形式

### Location

場所を表す。

持つもの:

- id
- name

持たないもの:

- 本の情報
- 貸出状態
- 保存形式

### BookPlacement

Book と Location の関係を表す。

持つもの:

- placement_id
- book_id
- location_id

持たないもの:

- 本の情報
- 現在の所有者
- 貸出状態
- 保存形式

### User

利用者を表す。

持つもの:

- id
- name

持たないもの:

- ログイン状態
- 貸出中の本の一覧
- 保存形式

### Checkout

誰がどの本を借りているかを表す。

持つもの:

- id
- book_id
- user_id
- checkout_date
- due_date
- returned_at
