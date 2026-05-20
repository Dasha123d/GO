# Пример: Базовые операции с SQLite

Файл: `sqlite-basic.go`

## Назначение
Демонстрация работы с SQLite in-memory: создание таблицы, выполнение транзакции (перевод средств между счетами) и чтение результатов.

## Зависимости
- `github.com/mattn/go-sqlite3` (требуется CGO и компилятор C)

Установите: `go get github.com/mattn/go-sqlite3`  
Убедитесь, что у вас установлен GCC (Linux: `build-essential`, Windows: mingw-w64, macOS: Xcode CLT).

## Запуск
```bash
go run sqlite-basic.go
```

## Ожидаемый вывод
```text
Транзакция успешно зафиксирована
Текущие счета:
  Alice: 800.00
  Bob: 700.00
```