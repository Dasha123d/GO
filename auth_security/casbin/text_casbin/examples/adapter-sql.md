# Пример: Адаптер SQL (PostgreSQL)

Используем `gorm-adapter` для хранения политик в БД.

```go
// adapter-sql.go
package main

import (
	"fmt"
	"log"

	"github.com/casbin/casbin/v2"
	gormadapter "github.com/casbin/gorm-adapter/v3"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

func main() {
	dsn := "host=localhost user=postgres password=secret dbname=casbin port=5432 sslmode=disable"
	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatal(err)
	}

	adapter, err := gormadapter.NewAdapterByDB(db)
	if err != nil {
		log.Fatal(err)
	}

	e, err := casbin.NewEnforcer("model.conf", adapter)
	if err != nil {
		log.Fatal(err)
	}
	// Загружаем политики из БД
	e.LoadPolicy()

	// Добавляем правило и сохраняем
	e.AddPolicy("alice", "data1", "read")
	e.SavePolicy()

	// Проверяем
	ok, _ := e.Enforce("alice", "data1", "read")
	fmt.Println("Access:", ok) // true
}
```
Не забудьте создать базу данных `casbin` и модель `model.conf`.