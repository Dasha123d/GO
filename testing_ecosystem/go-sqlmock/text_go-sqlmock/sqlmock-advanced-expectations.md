# Продвинутые ожидания: аргументы, ошибки, задержки

## Проверка аргументов

`WithArgs` сравнивает аргументы через `driver.Value`. Если нужен нестрогий матчер:

```go
mock.ExpectQuery("SELECT name FROM users WHERE id = ?").
    WithArgs(sqlmock.AnyArg()).
    WillReturnRows(rows)
```
Другие матчеры: `sqlmock.NotEmpty()`, `sqlmock.NamedValue("key", value)`, `sqlmock.QueryMatcher` для гибкого сравнения.

## Несколько возвратов результатов
Для вызовов, которые выполняются несколько раз в одном тесте:
```go
mock.ExpectQuery("SELECT id FROM orders").
    WillReturnRows(rows1).
    WillReturnRows(rows2) // второй вызов
```
## Ожидание ошибки
```go
mock.ExpectQuery("SELECT").
    WillReturnError(fmt.Errorf("database error"))
```
При вызове метод вернёт указанную ошибку.

## Задержка ответа
```go
mock.ExpectQuery("SELECT").
    WillDelayFor(100 * time.Millisecond).
    WillReturnRows(rows)
```
## Порядок ожиданий
По умолчанию ожидания срабатывают в порядке их объявления. Если включён режим `sqlmock.QueryMatcherRegexp` или кастомный матчер, можно проверять без привязки к порядку, но лучше явно задавать последовательность.

## Кастомные матчеры запросов
```go
db, mock, _ := sqlmock.New(sqlmock.QueryMatcherOption(sqlmock.QueryMatcherEqual))
db, mock, _ := sqlmock.New(sqlmock.QueryMatcherOption(sqlmock.QueryMatcherRegexp))
```
По умолчанию используется `QueryMatcherEqual` — точное совпадение строк. В production-коде запросы могут отличаться пробелами, тогда Regexp удобнее.