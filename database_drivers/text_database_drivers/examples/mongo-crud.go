// mongo-crud.go
// Пример CRUD операций с MongoDB: вставка, поиск, обновление, удаление.
package main

import (
	"context"
	"fmt"
	"log"
	"time"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

type User struct {
	ID   primitive.ObjectID `bson:"_id,omitempty"`
	Name string             `bson:"name"`
	Age  int                `bson:"age"`
}

func main() {
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	// Подключение к MongoDB (по умолчанию локально)
	client, err := mongo.Connect(ctx, options.Client().ApplyURI("mongodb://localhost:27017"))
	if err != nil {
		log.Fatalf("Ошибка подключения: %v", err)
	}
	defer client.Disconnect(ctx)

	// Проверка соединения
	if err = client.Ping(ctx, nil); err != nil {
		log.Fatalf("MongoDB недоступен: %v", err)
	}
	fmt.Println("Подключено к MongoDB")

	coll := client.Database("testdb").Collection("users")

	// Очистка коллекции перед примером
	_ = coll.Drop(ctx)

	// 1. Вставка документа
	user := User{Name: "Alice", Age: 30}
	result, err := coll.InsertOne(ctx, user)
	if err != nil {
		log.Fatalf("Ошибка вставки: %v", err)
	}
	insertedID := result.InsertedID.(primitive.ObjectID)
	fmt.Printf("Вставлен документ с ID: %s\n", insertedID.Hex())

	// 2. Поиск документа
	var found User
	err = coll.FindOne(ctx, bson.M{"_id": insertedID}).Decode(&found)
	if err != nil {
		log.Fatalf("Ошибка поиска: %v", err)
	}
	fmt.Printf("Найден пользователь: %+v\n", found)

	// 3. Обновление
	update := bson.M{"$set": bson.M{"age": 31}}
	updateResult, err := coll.UpdateOne(ctx, bson.M{"_id": insertedID}, update)
	if err != nil {
		log.Fatalf("Ошибка обновления: %v", err)
	}
	fmt.Printf("Обновлено документов: %d\n", updateResult.ModifiedCount)

	// Проверка обновления
	_ = coll.FindOne(ctx, bson.M{"_id": insertedID}).Decode(&found)
	fmt.Printf("После обновления: возраст=%d\n", found.Age)

	// 4. Удаление
	deleteResult, err := coll.DeleteOne(ctx, bson.M{"_id": insertedID})
	if err != nil {
		log.Fatalf("Ошибка удаления: %v", err)
	}
	fmt.Printf("Удалено документов: %d\n", deleteResult.DeletedCount)

	// Проверка, что документ удалён
	err = coll.FindOne(ctx, bson.M{"_id": insertedID}).Decode(&found)
	if err == mongo.ErrNoDocuments {
		fmt.Println("Документ успешно удалён (не найден)")
	} else if err != nil {
		log.Fatalf("Неожиданная ошибка: %v", err)
	}
}