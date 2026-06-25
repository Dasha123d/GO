# Пакет `mock`: создание заглушек

## Определение мока

```go
type MyServiceMock struct {
    mock.Mock
}
func (m *MyServiceMock) Get(id int) (string, error) {
    args := m.Called(id)
    return args.String(0), args.Error(1)
}
```
* `mock.Mock` — встраиваемый объект, предоставляющий On/Return.
* `m.Called` регистрирует вызов и возвращает аргументы, заданные через On.

## Настройка ожиданий
```go
svc := new(MyServiceMock)
// Ожидаем вызов Get(1) и возвращаем "Alice", nil
svc.On("Get", 1).Return("Alice", nil)
// Ожидаем Get(2) с ошибкой
svc.On("Get", 2).Return("", errors.New("not found"))
```
Можно задавать несколько возвратов для последовательных вызовов: `.Return("first", nil).Return("second", nil)`.

## Матчеры аргументов
* `mock.Anything` – любой аргумент.
* `mock.AnythingOfType("string")` – аргумент конкретного типа.
* `mock.MatchedBy(func(i int) bool { return i > 0 })` – пользовательское условие.
```go
svc.On("Get", mock.AnythingOfType("int")).Return("ok", nil)
```

## Проверка вызовов
```go
svc.AssertExpectations(t)           // все зарегистрированные вызовы выполнены
svc.AssertCalled(t, "Get", 1)       // вызов был
svc.AssertNotCalled(t, "Get", 99)   // вызова не было
```
## Паттерны
* `.Once()` – ожидается ровно один раз.
* `.Times(n)` – ровно n раз.
* `.Maybe()` – может не вызываться (не обязательно).

```go
svc.On("Log", mock.Anything).Maybe()
```
## Порядок вызовов
Используйте `InOrder` из пакета `mock`:
```go
mock.InOrder(
    svc.On("Open"),
    svc.On("Read").Return("data"),
    svc.On("Close"),
)
```
## Возврат функций
Вместо фиксированного значения можно вернуть функцию:
```go
svc.On("Get", mock.Anything).Return(func(id int) string {
    return fmt.Sprintf("user_%d", id)
}, nil)
```