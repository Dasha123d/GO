# Быстрый старт: установка, генерация и первый код

## Установка

```bash
go install github.com/volatiletech/sqlboiler/v4@latest
go install github.com/volatiletech/sqlboiler/v4/drivers/sqlboiler-psql@latest
```
## Конфигурация
Создайте `sqlboiler.toml` в корне проекта:
```go
[psql]
dbname = "mydb"
host   = "localhost"
port   = 5432
user   = "test"
pass   = "test"
sslmode = "disable"
blacklist = ["migrations"]
```

## Генерация моделей
```bash
sqlboiler psql
```

SQLBoiler прочитает схему БД и сгенерирует пакет `models` со всеми таблицами.

## Первый код
```go
package main

import (
    "context"
    "database/sql"
    "log"

    "github.com/volatiletech/sqlboiler/v4/boil"
    _ "github.com/lib/pq"
    "myapp/models"
)

func main() {
    db, err := sql.Open("postgres", "host=localhost dbname=mydb sslmode=disable")
    if err != nil {
        log.Fatal(err)
    }
    boil.SetDB(db)

    ctx := context.Background()

    // Create
    user := &models.User{Name: "Alice", Age: 30}
    err = user.Insert(ctx, db, boil.Infer())

    // Read
    found, err := models.FindUser(ctx, db, user.ID)

    // Update
    user.Name = "Alice Updated"
    rowsAff, err := user.Update(ctx, db, boil.Infer())

    // Delete
    rowsAff, err = user.Delete(ctx, db)
}
```
Готово: модели привязаны к реальной схеме, типы строгие, никакой магии.