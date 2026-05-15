// mysql-connect.go
// Пример подключения к MySQL с go-sql-driver/mysql, создание таблицы и запись/чтение.
package main

import (
	"database/sql"
	"fmt"
	"log"
	"time"

	_ "github.com/go-sql-driver/mysql"
)

func main() {
	// DSN: пользователь:пароль@tcp(хост:порт)/имя_бд?parseTime=true
	dsn := "root:password@tcp(localhost:3306)/testdb?parseTime=true&loc=Local&charset=utf8mb4"

	db, err := sql.Open("mysql", dsn)
	if err != nil {
		log.Fatalf("Ошибка открытия БД: %v", err)
	}
	defer db.Close()

	// Настройка пула
	db.SetMaxOpenConns(10)
	db.SetMaxIdleConns(5)
	db.SetConnMaxLifetime(5 * time.Minute)

	// Проверка подключения
	if err = db.Ping(); err != nil {
		log.Fatalf("БД недоступна: %v", err)
	}
	fmt.Println("Успешное подключение к MySQL!")

	// Создание таблицы
	_, err = db.Exec(`CREATE TABLE IF NOT EXISTS users (
		id INT AUTO_INCREMENT PRIMARY KEY,
		name VARCHAR(100) NOT NULL,
		created_at DATETIME DEFAULT CURRENT_TIMESTAMP
	)`)
	if err != nil {
		log.Fatalf("Ошибка создания таблицы: %v", err)
	}

	// Вставка
	result, err := db.Exec("INSERT INTO users (name) VALUES (?)", "Alice")
	if err != nil {
		log.Fatalf("Ошибка вставки: %v", err)
	}
	id, _ := result.LastInsertId()
	fmt.Printf("Вставлена запись с id=%d\n", id)

	// Чтение
	var name string
	var createdAt time.Time
	err = db.QueryRow("SELECT name, created_at FROM users WHERE id = ?", id).Scan(&name, &createdAt)
	if err != nil {
		log.Fatalf("Ошибка чтения: %v", err)
	}
	fmt.Printf("Получена запись: name=%s, created_at=%s\n", name, createdAt.Format(time.RFC3339))
}