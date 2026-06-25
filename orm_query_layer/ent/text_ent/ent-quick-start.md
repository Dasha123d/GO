# Быстрый старт: установка, схема и первый клиент

## Установка

```bash
go get entgo.io/ent/cmd/ent
```
Добавьте `ent` в `go.mod` и установите инструмент кодогенерации.

## Создание схемы
Создайте файл `ent/schema/user.go`:
```go
package schema

import (
    "entgo.io/ent"
    "entgo.io/ent/schema/field"
)

type User struct {
    ent.Schema
}

func (User) Fields() []ent.Field {
    return []ent.Field{
        field.Int("age").Positive(),
        field.String("name").Default("unknown"),
    }
}
```
Запустите генерацию клиента:
```bash
go generate ./ent
```
Будет создан клиент с полным API в пакете `ent`.

## Подключение к базе и первый CRUD
```go
import (
    "context"
    "log"
    "<project>/ent"
    _ "github.com/lib/pq"
)

func main() {
    client, err := ent.Open("postgres", "host=localhost port=5432 user=test dbname=test sslmode=disable")
    if err != nil {
        log.Fatal(err)
    }
    defer client.Close()
    ctx := context.Background()
    // Автоматическая миграция (для разработки)
    if err := client.Schema.Create(ctx); err != nil {
        log.Fatal(err)
    }
    // Create
    user, _ := client.User.Create().SetAge(30).SetName("Alice").Save(ctx)
    // Read
    u, _ := client.User.Get(ctx, user.ID)
    // Update
    client.User.UpdateOneID(u.ID).SetAge(31).Exec(ctx)
    // Delete
    client.User.DeleteOne(u).Exec(ctx)
}
```
Всё готово: клиент, миграция, операции.