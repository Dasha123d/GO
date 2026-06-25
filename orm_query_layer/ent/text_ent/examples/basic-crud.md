# Пример: Полный CRUD

Файл: `examples/basic-crud.go`

```go
package main

import (
    "context"
    "log"
    "<project>/ent"
    _ "github.com/lib/pq"
)

func main() {
    client, _ := ent.Open("postgres", "host=localhost ...")
    defer client.Close()
    ctx := context.Background()
    client.Schema.Create(ctx)

    u, _ := client.User.Create().SetName("Alice").SetAge(30).Save(ctx)
    u, _ = client.User.Get(ctx, u.ID)
    client.User.UpdateOne(u).SetAge(31).Exec(ctx)
    client.User.DeleteOne(u).Exec(ctx)
}
```
