// postgres-connect.go
// Пример подключения к PostgreSQL с использованием pgx (как database/sql драйвер)
package main

import (
	"context"
	"database/sql"
	"fmt"
	"log"
	"time"

	_ "github.com/jackc/pgx/v5/stdlib"
)

func main() {
	// DSN для подключения к локальному PostgreSQL.
	// Замените параметры на свои.
	dsn := "postgres://postgres:password@localhost:5432/testdb?sslmode=disable"

	db, err := sql.Open("pgx", dsn)
	if err != nil {
		log.Fatalf("Не удалось открыть БД: %v", err)
	}
	defer db.Close()

	// Настройка пула соединений
	db.SetMaxOpenConns(10)
	db.SetMaxIdleConns(5)
	db.SetConnMaxLifetime(5 * time.Minute)

	// Проверка соединения с контекстом и таймаутом
	ctx, cancel := context.WithTimeout(context.Background(), 2*time.Second)
	defer cancel()

	if err = db.PingContext(ctx); err != nil {
		log.Fatalf("БД недоступна: %v", err)
	}
	fmt.Println("Успешное подключение к PostgreSQL!")

	// Создаём тестовую таблицу (если не существует)
	_, err = db.ExecContext(ctx, `CREATE TABLE IF NOT EXISTS test_table (
		id SERIAL PRIMARY KEY,
		message TEXT NOT NULL,
		created_at TIMESTAMPTZ DEFAULT NOW()
	)`)
	if err != nil {
		log.Fatalf("Ошибка создания таблицы: %v", err)
	}

	// Вставка записи
	var insertedID int
	err = db.QueryRowContext(ctx,
		"INSERT INTO test_table (message) VALUES ($1) RETURNING id",
		"Привет, Go!",
	).Scan(&insertedID)
	if err != nil {
		log.Fatalf("Ошибка вставки: %v", err)
	}
	fmt.Printf("Добавлена запись с id=%d\n", insertedID)

	// Чтение записи
	var msg string
	var createdAt time.Time
	err = db.QueryRowContext(ctx,
		"SELECT message, created_at FROM test_table WHERE id=$1", insertedID,
	).Scan(&msg, &createdAt)
	if err != nil {
		log.Fatalf("Ошибка чтения: %v", err)
	}
	fmt.Printf("Получена запись: message=%q, created_at=%s\n", msg, createdAt.Format(time.RFC3339))
}