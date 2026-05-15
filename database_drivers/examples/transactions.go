// transactions.go
// Пример транзакции в database/sql: перевод средств с откатом при ошибке.
// Предполагается запуск с PostgreSQL, но код совместим с SQLite (измените драйвер и DSN).
package main

import (
	"context"
	"database/sql"
	"fmt"
	"log"
	"time"

	_ "github.com/jackc/pgx/v5/stdlib" // или _ "github.com/mattn/go-sqlite3"
)

func main() {
	// Для SQLite замените на "sqlite3" и ":memory:"
	dsn := "postgres://postgres:password@localhost:5432/testdb?sslmode=disable"
	driver := "pgx"

	db, err := sql.Open(driver, dsn)
	if err != nil {
		log.Fatalf("Ошибка открытия БД: %v", err)
	}
	defer db.Close()

	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	if err = db.PingContext(ctx); err != nil {
		log.Fatalf("БД недоступна: %v", err)
	}

	// Подготовка: создадим таблицу счетов и наполним данными
	_, err = db.ExecContext(ctx, `
		CREATE TABLE IF NOT EXISTS accounts (
			id SERIAL PRIMARY KEY,
			owner TEXT NOT NULL,
			balance NUMERIC(12,2) NOT NULL
		);
		TRUNCATE accounts;
		INSERT INTO accounts (owner, balance) VALUES ('Alice', 1000), ('Bob', 500);
	`)
	if err != nil {
		log.Fatalf("Ошибка инициализации: %v", err)
	}
	fmt.Println("Начальные балансы: Alice=1000.00, Bob=500.00")

	// Транзакция перевода 200 от Alice к Bob
	err = transferFunds(ctx, db, "Alice", "Bob", 200)
	if err != nil {
		log.Fatalf("Перевод не удался: %v", err)
	}

	// Вывод результата
	printBalances(ctx, db)
}

func transferFunds(ctx context.Context, db *sql.DB, from, to string, amount float64) error {
	tx, err := db.BeginTx(ctx, nil)
	if err != nil {
		return fmt.Errorf("начало транзакции: %w", err)
	}
	defer tx.Rollback()

	// Проверяем баланс отправителя
	var balance float64
	err = tx.QueryRowContext(ctx, "SELECT balance FROM accounts WHERE owner = $1 FOR UPDATE", from).Scan(&balance)
	if err != nil {
		return fmt.Errorf("ошибка получения баланса: %w", err)
	}
	if balance < amount {
		return fmt.Errorf("недостаточно средств: баланс %.2f, требуется %.2f", balance, amount)
	}

	// Списываем с отправителя
	_, err = tx.ExecContext(ctx, "UPDATE accounts SET balance = balance - $1 WHERE owner = $2", amount, from)
	if err != nil {
		return fmt.Errorf("списание средств: %w", err)
	}

	// Зачисляем получателю
	_, err = tx.ExecContext(ctx, "UPDATE accounts SET balance = balance + $1 WHERE owner = $2", amount, to)
	if err != nil {
		return fmt.Errorf("зачисление средств: %w", err)
	}

	err = tx.Commit()
	if err != nil {
		return fmt.Errorf("коммит транзакции: %w", err)
	}
	fmt.Printf("Переведено %.2f от %s к %s\n", amount, from, to)
	return nil
}

func printBalances(ctx context.Context, db *sql.DB) {
	rows, err := db.QueryContext(ctx, "SELECT owner, balance FROM accounts ORDER BY owner")
	if err != nil {
		log.Fatalf("Запрос балансов: %v", err)
	}
	defer rows.Close()
	fmt.Println("Итоговые балансы:")
	for rows.Next() {
		var owner string
		var bal float64
		if err := rows.Scan(&owner, &bal); err != nil {
			log.Fatal(err)
		}
		fmt.Printf("  %s: %.2f\n", owner, bal)
	}
}