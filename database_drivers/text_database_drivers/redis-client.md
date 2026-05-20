# Клиент Redis в Go

Популярный клиент: `github.com/redis/go-redis/v9`.

## Подключение

```go
import "github.com/redis/go-redis/v9"

rdb := redis.NewClient(&redis.Options{
    Addr:     "localhost:6379",
    Password: "", // если пароль не задан
    DB:       0,
})
defer rdb.Close()

ctx := context.Background()
pong, err := rdb.Ping(ctx).Result()
fmt.Println(pong) // PONG
```

## Основные операции

### Строки
```go
err := rdb.Set(ctx, "key", "value", 10*time.Minute).Err()
val, err := rdb.Get(ctx, "key").Result()
fmt.Println(val)
```

### Хэши
```go
rdb.HSet(ctx, "user:1", "name", "Alice", "age", 30)
name, _ := rdb.HGet(ctx, "user:1", "name").Result()
```

### Списки, множества, сортированные множества
```go
rdb.LPush(ctx, "queue", "job1", "job2")
rdb.SAdd(ctx, "tags", "go", "redis")
rdb.ZAdd(ctx, "leaderboard", redis.Z{Score: 100, Member: "player1"})
```

### Пайплайны
Для отправки нескольких команд за один round-trip:
```go
pipe := rdb.Pipeline()
incr := pipe.Incr(ctx, "counter")
pipe.Expire(ctx, "counter", time.Hour)
_, err = pipe.Exec(ctx)
fmt.Println(incr.Val())
```

## Pub/Sub
```go
pubsub := rdb.Subscribe(ctx, "channel1")
defer pubsub.Close()
ch := pubsub.Channel()
for msg := range ch {
    fmt.Println(msg.Payload)
}
```

## Кластер и Sentinel
Для кластера:
```go
rdb := redis.NewClusterClient(&redis.ClusterOptions{
    Addrs: []string{":7000", ":7001", ":7002"},
})
```

Для Sentinel:
```go
rdb := redis.NewFailoverClient(&redis.FailoverOptions{
    MasterName: "mymaster",
    SentinelAddrs: []string{":26379"},
})
```

## Кэширование объектов
```go
type User struct {
    Name string `json:"name"`
    Age  int    `json:"age"`
}
user := User{"Alice", 30}
data, _ := json.Marshal(user)
rdb.Set(ctx, "user:alice", data, 0)

// получение
var u User
bytes, _ := rdb.Get(ctx, "user:alice").Bytes()
json.Unmarshal(bytes, &u)
```

## Лучшие практики
* Используйте контекст везде.
* Настройте таймауты через `redis.Options{ReadTimeout: ..., WriteTimeout: ...}`.
* Применяйте TTL для предотвращения бесконечного роста памяти.
* Для сериализации используйте `json` или `msgpack`.

