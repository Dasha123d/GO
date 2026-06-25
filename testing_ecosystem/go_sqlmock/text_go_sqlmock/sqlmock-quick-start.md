# Быстрый старт: мокируем SQL‑запросы в тестах

## Установка

```bash
go get github.com/DATA-DOG/go-sqlmock
```
Первый мок
Предположим, у нас есть функция, которую нужно протестировать:
```go
func GetUserName(db *sql.DB, id int) (string, error) {
    var name string
    err := db.QueryRow("SELECT name FROM users WHERE id = ?", id).Scan(&name)
    return name, err
}
```
Тест с `sqlmock`:
```go
func TestGetUserName(t *testing.T) {
    db, mock, err := sqlmock.New()
    require.NoError(t, err)
    defer db.Close()

    rows := sqlmock.NewRows([]string{"name"}).AddRow("Alice")
    mock.ExpectQuery("SELECT name FROM users WHERE id = ?").
        WithArgs(1).
        WillReturnRows(rows)

    name, err := GetUserName(db, 1)
    assert.NoError(t, err)
    assert.Equal(t, "Alice", name)
    assert.NoError(t, mock.ExpectationsWereMet())
}
```
* `sqlmock.New()` создаёт `*sql.DB` и `Sqlmock`.
* `ExpectQuery` задаёт ожидаемый запрос.
* `WithArgs` проверяет аргументы.
* `WillReturnRows` возвращает фиктивные строки.
* `ExpectationsWereMet()` в конце теста проверяет, что все ожидания выполнены.

## Ожидания Exec
```go
mock.ExpectExec("INSERT INTO users").
    WithArgs("Bob").
    WillReturnResult(sqlmock.NewResult(1, 1))
```
Результат можно создать с LastInsertId и RowsAffected.

Теперь у вас есть полный цикл: настройка, вызов тестируемой функции и проверка.