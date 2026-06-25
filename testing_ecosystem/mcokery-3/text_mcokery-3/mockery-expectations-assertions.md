# Ожидания и утверждения в моках mockery

## Регистрация ожиданий

### Строгие параметры

```go
mockRepo.EXPECT().FindByID(1).Return(&User{Name: "Alice"}, nil)
mockRepo.EXPECT().Save(mock.AnythingOfType("*User")).Return(nil)
```
## Множественные вызовы
```go
mockRepo.EXPECT().FindByID(1).Return(&User{}, nil).Times(2)
mockRepo.EXPECT().FindByID(2).Return(nil, errors.New("not found")).Once()
```

## Условные возвраты
```go
mockRepo.EXPECT().DoSomething(mock.Anything).Return(func(id int) error {
    if id == 0 {
        return errors.New("invalid")
    }
    return nil
})
```

## Проверка вызовов
* AssertExpectations – вручную, если не используется expecter с `t`.
* AssertCalled / AssertNotCalled – проверить конкретные вызовы.
```go
mockRepo.AssertCalled(t, "FindByID", 1)
mockRepo.AssertNotCalled(t, "Save")
```
## Таймауты и последовательности
Можно задавать порядок вызовов:
```go
mockRepo.EXPECT().BeginTx().Return(nil).Once()
mockRepo.EXPECT().Commit().Return(nil).Once().After("BeginTx")
```
Или использовать `InOrder` из testify.

## Утверждение количества вызовов
* `Times(n)` – ожидается ровно n вызовов.
* `Once()` – ровно один.
* `Twice()` – ровно два.
* `Maybe()` – может быть вызван, не обязателен.

## Сброс ожиданий
Если нужно переопределить мок внутри одного теста, создавайте новый экземпляр. Mockery-моки не поддерживают сброс «на лету».