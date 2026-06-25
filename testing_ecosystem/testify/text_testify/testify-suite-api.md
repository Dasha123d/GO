# Пакет `suite`: группы тестов и фикстуры

## Определение набора

```go
type MySuite struct {
    suite.Suite
    db *sql.DB
}
```
## Методы жизненного цикла
* `SetupSuite()` – вызывается один раз перед всеми тестами в наборе.
* `TearDownSuite()` – один раз после всех тестов.
* `SetupTest()` – перед каждым тестом.
* `TearDownTest()` – после каждого теста.
```go
func (s *MySuite) SetupSuite() {
    s.db = connectDB()
}
func (s *MySuite) TearDownSuite() {
    s.db.Close()
}
func (s *MySuite) SetupTest() {
    s.db.Exec("TRUNCATE users")
}
```
## Тестовые методы
Любой метод, начинающийся с `Test`, вызывается как отдельный тест:
```go
func (s *MySuite) TestCreateUser() {
    // s.T() — текущий *testing.T
    assert.NoError(s.T(), CreateUser(s.db, "Alice"))
}
```
## Запуск
```go
func TestMySuite(t *testing.T) {
    suite.Run(t, new(MySuite))
}
```
## Особенности
* Гарантируется изоляция: для каждого теста создаётся новый экземпляр `MySuite` (если не используются общие поля, но методы Setup/Teardown помогают).
* Можно определить `BeforeTest(suiteName, testName)` и `AfterTest(...)` для общей логики.

## Assertions внутри suite
Доступны через `s.Assert()` и `s.Require()`:
```go
s.Require().NoError(err)
s.Assert().Equal("Alice", name)
```