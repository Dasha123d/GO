# Интеграция с GORM

## Настройка GORM с sqlmock

```go
import (
    "testing"
    "github.com/DATA-DOG/go-sqlmock"
    "gorm.io/driver/mysql"
    "gorm.io/gorm"
)

func SetupMockDB() (*gorm.DB, sqlmock.Sqlmock, *sql.DB) {
    sqlDB, mock, _ := sqlmock.New()
    dialector := mysql.New(mysql.Config{
        Conn:                      sqlDB,
        SkipInitializeWithVersion: true,
    })
    gormDB, _ := gorm.Open(dialector, &gorm.Config{})
    return gormDB, mock, sqlDB
}
```
## Тестирование запроса GORM
```go
func TestFindUser(t *testing.T) {
    gormDB, mock, sqlDB := SetupMockDB()
    defer sqlDB.Close()

    rows := sqlmock.NewRows([]string{"id", "name"}).AddRow(1, "Alice")
    // Важно: GORM добавляет кавычки, нужно использовать regexp или адаптировать запрос
    mock.ExpectQuery("SELECT \\* FROM `users` WHERE `users`.`id` = \\? ORDER BY `users`.`id` LIMIT \\d+").
        WithArgs(1).
        WillReturnRows(rows)

    var user User
    result := gormDB.First(&user, 1)
    assert.NoError(t, result.Error)
    assert.Equal(t, "Alice", user.Name)
}
```
Особенности:
* GORM генерирует SQL с кавычками и LIMIT, точное соответствие строки затруднительно.
* Рекомендуется использовать `sqlmock.QueryMatcherOption(sqlmock.QueryMatcherRegexp)` для гибкости.
* Можно создать хелпер, принимающий упрощённый шаблон.

## Хелпер для GORM‑совместимого матчера
```go
func NewGormMock() (*gorm.DB, sqlmock.Sqlmock, *sql.DB) {
    sqlDB, mock, _ := sqlmock.New(
        sqlmock.QueryMatcherOption(sqlmock.QueryMatcherRegexp),
    )
    dialector := mysql.New(mysql.Config{
        Conn:                      sqlDB,
        SkipInitializeWithVersion: true,
    })
    gormDB, _ := gorm.Open(dialector, &gorm.Config{})
    return gormDB, mock, sqlDB
}
```
Теперь можно писать ожидания в виде регулярных выражений:
```go
mock.ExpectQuery("SELECT .+ FROM `users` WHERE .+ LIMIT .+").
    WillReturnRows(rows)
```