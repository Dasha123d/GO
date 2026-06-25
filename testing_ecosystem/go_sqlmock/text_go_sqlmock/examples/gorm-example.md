# Пример: Мокирование GORM
```go
package example

import (
    "testing"
    "github.com/DATA-DOG/go-sqlmock"
    "gorm.io/driver/mysql"
    "gorm.io/gorm"
)

type User struct {
    ID   int    `gorm:"primaryKey"`
    Name string
}

func TestGormFind(t *testing.T) {
    sqlDB, mock, _ := sqlmock.New(sqlmock.QueryMatcherOption(sqlmock.QueryMatcherRegexp))
    defer sqlDB.Close()

    dialector := mysql.New(mysql.Config{
        Conn: sqlDB, SkipInitializeWithVersion: true,
    })
    gormDB, _ := gorm.Open(dialector, &gorm.Config{})

    rows := sqlmock.NewRows([]string{"id", "name"}).AddRow(1, "Alice")
    mock.ExpectQuery("SELECT \\* FROM `users` WHERE `users`.`id` = \\? ORDER BY `users`.`id` LIMIT \\d+").
        WithArgs(1).
        WillReturnRows(rows)

    var user User
    result := gormDB.First(&user, 1)
    if result.Error != nil {
        t.Fatal(result.Error)
    }
    if user.Name != "Alice" {
        t.Errorf("expected Alice, got %s", user.Name)
    }
    if err := mock.ExpectationsWereMet(); err != nil {
        t.Error(err)
    }
}
```
