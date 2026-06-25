# Генерация моков: CLI, go:generate, expecter

## Ручной запуск

```bash
mockery --name UserRepository --dir ./service --output ./mocks
```
Сгенерирует мок для интерфейса `UserRepository` из `./service` в папку `./mocks`.

## Использование go:generate
Добавьте в файл с интерфейсом:
```go
//go:generate mockery --name UserRepository --output ../mocks
type UserRepository interface { ... }
```

Теперь `go generate ./..`. автоматически обновит мок.

Expecter (паттерн expect)
При включённом `with-expecter: true` генерируются методы-обёртки, заменяющие `On(...).Return(...)` на более читаемые:
```go
mockRepo := mocks.NewUserRepository(t)
mockRepo.EXPECT().FindByID(1).Return(&User{Name: "Alice"}, nil)
```
* Вызывается `NewUserRepository(t)` — мок привязывается к `*testing.T`.
* `EXPECT()` возвращает объект, регистрирующий ожидания.
* Цепочка `FindByID(1).Return(...)` регистрирует вызов.
* В конце теста автоматически проверяются невыполненные ожидания (через `t.Cleanup`).

## Сравнение стилей
Традиционный testify:
```go
mockRepo.On("FindByID", 1).Return(&User{}, nil)
mockRepo.AssertExpectations(t)
```
## Expecter (mockery v3):
```go
mockRepo.EXPECT().FindByID(1).Return(&User{}, nil)
// авто-assert через Cleanup
```
Expecter безопаснее: при падении теста немедленно показывает, какой вызов не был выполнен, и автоматически проверяет ожидания.