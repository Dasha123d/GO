// sqlite-basic.go
// Пример работы с in-memory SQLite: создание таблицы, транзакция, запрос.
package main

import (
	"database/sql"
	"fmt"
	"log"

	_ "github.com/mattn/go-sqlite3"
)

func main() {
	// Используем in-memory базу данных
	db, err := sql.Open("sqlite3", ":memory:?_foreign_keys=on")
	if err != nil {
		log.Fatalf("Ошибка открытия SQLite: %v", err)
	}
	defer db.Close()

	// Создание таблицы
	_, err = db.Exec(`CREATE TABLE accounts (
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		owner TEXT NOT NULL,
		balance REAL NOT NULL
	)`)
	if err != nil {
		log.Fatalf("Ошибка создания таблицы: %v", err)
	}

	// Транзакция: перевод средств
	tx, err := db.Begin()
	if err != nil {
		log.Fatal(err)
	}
	defer func() {
		if err != nil {
			tx.Rollback()
			log.Println("Транзакция отменена")
		}
	}()

	// Вставка двух аккаунтов
	_, err = tx.Exec("INSERT INTO accounts (owner, balance) VALUES (?, ?)", "Alice", 1000)
	if err != nil {
		return
	}
	_, err = tx.Exec("INSERT INTO accounts (owner, balance) VALUES (?, ?)", "Bob", 500)
	if err != nil {
		return
	}

	// Перевод 200 от Alice к Bob
	_, err = tx.Exec("UPDATE accounts SET balance = balance - 200 WHERE owner = ?", "Alice")
	if err != nil {
		return
	}
	_, err = tx.Exec("UPDATE accounts SET balance = balance + 200 WHERE owner = ?", "Bob")
	if err != nil {
		return
	}

	err = tx.Commit()
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println("Транзакция успешно зафиксирована")

	// Проверка результатов
	rows, err := db.Query("SELECT owner, balance FROM accounts ORDER BY id")
	if err != nil {
		log.Fatal(err)
	}
	defer rows.Close()

	fmt.Println("Текущие счета:")
	for rows.Next() {
		var owner string
		var balance float64
		if err := rows.Scan(&owner, &balance); err != nil {
			log.Fatal(err)
		}
		fmt.Printf("  %s: %.2f\n", owner, balance)
	}
	if err = rows.Err(); err != nil {
		log.Fatal(err)
	}
}