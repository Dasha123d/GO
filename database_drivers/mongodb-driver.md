# Драйвер MongoDB

Официальный драйвер: `go.mongodb.org/mongo-driver/mongo`.

## Подключение

```go
import (
    "context"
    "go.mongodb.org/mongo-driver/mongo"
    "go.mongodb.org/mongo-driver/mongo/options"
)

client, err := mongo.Connect(context.TODO(), options.Client().ApplyURI("mongodb://localhost:27017"))
if err != nil {
    log.Fatal(err)
}
defer client.Disconnect(context.TODO())

// проверка соединения
err = client.Ping(context.TODO(), nil)
```

## Базы данных и коллекции
```go
coll := client.Database("testdb").Collection("users")
```

## BSON и документы
Драйвер использует BSON для представления документов. Можно использовать `bson.D` (упорядоченный), `bson.M` (map), или структуры с тегами `bson:"..."`.

```go
type User struct {
    ID   primitive.ObjectID `bson:"_id,omitempty"`
    Name string             `bson:"name"`
    Age  int                `bson:"age"`
}
```

## CRUD операции
### Вставка
```go
user := User{Name: "Alice", Age: 30}
result, err := coll.InsertOne(context.TODO(), user)
if err != nil { ... }
fmt.Println("inserted ID:", result.InsertedID)
```

### Поиск одного
```go
var found User
err = coll.FindOne(context.TODO(), bson.M{"name": "Alice"}).Decode(&found)
```

### Поиск нескольких
```go
cursor, err := coll.Find(context.TODO(), bson.M{"age": bson.M{"$gt": 25}})
var users []User
err = cursor.All(context.TODO(), &users)
```

### Обновление
```go
filter := bson.M{"name": "Alice"}
update := bson.M{"$set": bson.M{"age": 31}}
_, err = coll.UpdateOne(context.TODO(), filter, update)
```

### Удаление
```go
_, err = coll.DeleteOne(context.TODO(), bson.M{"name": "Alice"})
```

### Индексы
```go
indexModel := mongo.IndexModel{
    Keys: bson.D{{"name", 1}},
    Options: options.Index().SetUnique(true),
}
_, err = coll.Indexes().CreateOne(context.TODO(), indexModel)
```

### Агрегации
```go
pipeline := mongo.Pipeline{
    {{"$match", bson.D{{"age", bson.D{{"$gte", 25}}}}}},
    {{"$group", bson.D{{"_id", "$name"}, {"count", bson.D{{"$sum", 1}}}}}},
}
cursor, err = coll.Aggregate(context.TODO(), pipeline)
```

## Лучшие практики
* Используйте контекст с таймаутами.
* Закрывайте курсоры: `defer cursor.Close(context.TODO())`.
* Для production настройте пул соединений через `options.Client().SetMaxPoolSize()`.
* Применяйте `primitive.ObjectID` для идентификаторов.