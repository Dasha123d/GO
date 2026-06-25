# Пример: Базовый Query и Exec

```go
package example

import (
    "testing"
    "github.com/DATA-DOG/go-sqlmock"
    "github.com/stretchr/testify/assert"
)

func GetUser(db *sql.DB, id int) (string, error) {
    var name string
    err := db.QueryRow("SELECT name FROM users WHERE id = ?", id).Scan(&name)
    return name, err
}

func TestGetUser(t *testing.T) {
    db, mock, err := sqlmock.New()
    assert.NoError(t, err)
    defer db.Close()

    rows := sqlmock.NewRows([]string{"name"}).AddRow("Alice")
    mock.ExpectQuery("SELECT name FROM users WHERE id = ?").
        WithArgs(1).
        WillReturnRows(rows)

    name, err := GetUser(db, 1)
    assert.NoError(t, err)
    assert.Equal(t, "Alice", name)
    assert.NoError(t, mock.ExpectationsWereMet())
}
```