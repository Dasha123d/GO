# Подготовленные выражения (prepared statements)

## Ожидание Prepare

```go
mock.ExpectPrepare("SELECT name FROM users WHERE id = ?").
    ExpectQuery().
    WithArgs(1).
    WillReturnRows(rows)
```
В коде это соответствует:
```go
stmt, _ := db.Prepare("SELECT name FROM users WHERE id = ?")
stmt.Query(1)
```
## Множественные вызовы подготовленного запроса
```go
prep := mock.ExpectPrepare("SELECT name FROM users")
prep.ExpectQuery().WithArgs(1).WillReturnRows(rows1)
prep.ExpectQuery().WithArgs(2).WillReturnRows(rows2)
```
Важно вызывать ExpectPrepare один раз, затем цепочку ExpectQuery.

## Ошибка при Prepare
```go
mock.ExpectPrepare("SELECT").WillReturnError(errors.New("prepare error"))
```

## Закрытие подготовленного выражения
```go
prep.ExpectClose()
```
Проверяет, что `stmt.Close()` был вызван. Используется редко, но полезно для проверки управления ресурсами.