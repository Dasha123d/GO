// redis-cache.go
// Пример кэширования JSON-объекта в Redis с TTL.
package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"time"

	"github.com/redis/go-redis/v9"
)

type Product struct {
	ID    int     `json:"id"`
	Name  string  `json:"name"`
	Price float64 `json:"price"`
}

func main() {
	ctx := context.Background()

	// Подключение к Redis
	rdb := redis.NewClient(&redis.Options{
		Addr:     "localhost:6379",
		Password: "", // без пароля
		DB:       0,
	})
	defer rdb.Close()

	// Проверка соединения
	if _, err := rdb.Ping(ctx).Result(); err != nil {
		log.Fatalf("Redis недоступен: %v", err)
	}
	fmt.Println("Подключено к Redis")

	// Продукт для кэширования
	product := Product{
		ID:    101,
		Name:  "Ноутбук",
		Price: 999.99,
	}

	// Сериализация в JSON
	data, err := json.Marshal(product)
	if err != nil {
		log.Fatalf("Ошибка маршалинга: %v", err)
	}

	// Сохранение с временем жизни 30 секунд
	key := "product:101"
	err = rdb.Set(ctx, key, data, 30*time.Second).Err()
	if err != nil {
		log.Fatalf("Ошибка записи в Redis: %v", err)
	}
	fmt.Println("Объект сохранён в кэш с TTL 30s")

	// Чтение из кэша
	cached, err := rdb.Get(ctx, key).Bytes()
	if err == redis.Nil {
		fmt.Println("Ключ не найден (TTL истёк?)")
		return
	} else if err != nil {
		log.Fatalf("Ошибка чтения: %v", err)
	}

	var cachedProduct Product
	if err = json.Unmarshal(cached, &cachedProduct); err != nil {
		log.Fatalf("Ошибка демаршалинга: %v", err)
	}
	fmt.Printf("Из кэша: %+v\n", cachedProduct)

	// Проверка TTL
	ttl, _ := rdb.TTL(ctx, key).Result()
	fmt.Printf("Оставшееся время жизни ключа: %s\n", ttl)
}