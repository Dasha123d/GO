# Пример: Подключение к MySQL

Файл: `mysql-connect.go`

## Назначение
Подключение к MySQL через драйвер `go-sql-driver/mysql`, создание таблицы `users`, вставка и чтение записи. Показана работа с `parseTime` и настройка пула соединений.

## Зависимости
- `github.com/go-sql-driver/mysql`

Установите: `go get github.com/go-sql-driver/mysql`

## Конфигурация
Измените DSN в коде: `root:password@tcp(localhost:3306)/testdb?parseTime=true&loc=Local&charset=utf8mb4`.  
Создайте базу данных `testdb`, если её нет (`CREATE DATABASE testdb;`).

Убедитесь, что MySQL запущен и указанные учётные данные корректны.

## Запуск
```bash
go run mysql-connect.go
```

## Ожидаемый вывод
```text
Успешное подключение к MySQL!
Вставлена запись с id=1
Получена запись: name=Alice, created_at=2025-01-01T12:00:00+03:00
```