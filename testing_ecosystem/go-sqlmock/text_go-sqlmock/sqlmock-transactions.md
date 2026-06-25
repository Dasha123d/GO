# Транзакции: мокируем BEGIN, COMMIT, ROLLBACK

## Ожидание транзакции

```go
mock.ExpectBegin()
mock.ExpectExec("INSERT INTO users").WillReturnResult(sqlmock.NewResult(1, 1))
mock.ExpectCommit()
```
Затем в тестируемом коде:
```go
tx, _ := db.Begin()
tx.Exec("INSERT INTO users ...")
tx.Commit()
```
## Ожидание отката
```go
mock.ExpectBegin()
mock.ExpectExec("INSERT").WillReturnError(errors.New("fail"))
mock.ExpectRollback()
```
Проверяет, что при ошибке транзакция откатывается.

## Вложенные транзакции (savepoints)
`go-sqlmock` не поддерживает вложенные транзакции напрямую. Для тестирования кода с `SAVEPOINT` можно использовать ExpectExec с соответствующим SQL.

## Проверка завершения
```go
assert.NoError(t, mock.ExpectationsWereMet())
```
Убеждается, что все ожидаемые `Begin`, `Commit`, `Rollback` были вызваны.