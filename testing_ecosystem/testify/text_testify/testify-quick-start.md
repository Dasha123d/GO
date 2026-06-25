# Быстрый старт: установка и первое утверждение

## Установка

```bash
go get github.com/stretchr/testify
```
## Первый тест с `assert`
```go
package yours_test

import (
    "testing"
    "github.com/stretchr/testify/assert"
)

func TestSomething(t *testing.T) {
    result := 2 + 2
    assert.Equal(t, 4, result, "2+2 должно быть 4")
}
```
Если условие не выполняется, тест проваливается с читаемым сообщением.

## `require` для немедленной остановки
```go
func TestDivision(t *testing.T) {
    db, err := SetupDB()
    require.NoError(t, err) // если ошибка, тест сразу завершается
    defer db.Close()

    assert.NotNil(t, db)
}
```
* `assert` – тест продолжается после ошибки.
* `require` – тест немедленно прерывается.

## Моки (изолированное тестирование)
```go
type MyMock struct {
    mock.Mock
}
func (m *MyMock) DoSomething(input string) bool {
    args := m.Called(input)
    return args.Bool(0)
}

func TestWithMock(t *testing.T) {
    m := new(MyMock)
    m.On("DoSomething", "test").Return(true)

    ok := m.DoSomething("test")
    assert.True(t, ok)
    m.AssertExpectations(t)
}
```

## Suites (группы тестов с Setup/Teardown)
```go
type MySuite struct {
    suite.Suite
    db *sql.DB
}
func (s *MySuite) SetupSuite() { s.db = SetupDB() }
func (s *MySuite) TestQuery() { assert.NotNil(s.T(), s.db) }
func TestMySuite(t *testing.T) { suite.Run(t, new(MySuite)) }
```