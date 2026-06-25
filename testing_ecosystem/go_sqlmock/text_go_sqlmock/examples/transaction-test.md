# Пример: Тестирование транзакций

```go
package example

import (
    "database/sql"
    "errors"
    "testing"
    "github.com/DATA-DOG/go-sqlmock"
)

func InsertUser(tx *sql.Tx, name string) (int64, error) {
    res, err := tx.Exec("INSERT INTO users (name) VALUES (?)", name)
    if err != nil {
        return 0, err
    }
    return res.LastInsertId()
}

func TestInsertUserCommit(t *testing.T) {
    db, mock, _ := sqlmock.New()
    defer db.Close()

    mock.ExpectBegin()
    mock.ExpectExec("INSERT INTO users \\(name\\) VALUES \\(\\?\\)").
        WithArgs("Bob").
        WillReturnResult(sqlmock.NewResult(2, 1))
    mock.ExpectCommit()

    tx, _ := db.Begin()
    id, err := InsertUser(tx, "Bob")
    if err != nil {
        tx.Rollback()
        t.Fatal(err)
    }
    tx.Commit()
    if id != 2 {
        t.Errorf("expected id 2, got %d", id)
    }
    if err := mock.ExpectationsWereMet(); err != nil {
        t.Error(err)
    }
}

func TestInsertUserRollback(t *testing.T) {
    db, mock, _ := sqlmock.New()
    defer db.Close()

    mock.ExpectBegin()
    mock.ExpectExec("INSERT INTO users").
        WithArgs("Bob").
        WillReturnError(errors.New("db error"))
    mock.ExpectRollback()

    tx, _ := db.Begin()
    _, err := InsertUser(tx, "Bob")
    if err == nil {
        tx.Commit()
        t.Fatal("expected error")
    }
    tx.Rollback()
    if err := mock.ExpectationsWereMet(); err != nil {
        t.Error(err)
    }
}
```