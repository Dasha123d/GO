# Пакет `assert`: мягкие утверждения

## Основные функции

- **Equal** / **NotEqual**: `assert.Equal(t, expected, actual)`
- **Nil** / **NotNil**: `assert.Nil(t, obj)`
- **True** / **False**: `assert.True(t, condition)`
- **Error** / **NoError**: `assert.Error(t, err)`
- **Contains** / **NotContains**: `assert.Contains(t, "abc", "b")`
- **Len**: `assert.Len(t, slice, 3)`
- **Greater** / **Less**: `assert.Greater(t, a, b)`
- **WithinDuration**: `assert.WithinDuration(t, time.Now(), time.Now().Add(time.Second), 2*time.Second)`

## Работа с ошибками

```go
err := doSomething()
assert.Error(t, err)
assert.EqualError(t, err, "expected error message")
assert.ErrorIs(t, err, ErrNotFound)
```
## Сравнение структур
`assert.Equal` использует `reflect.DeepEqual`. Для частичного сравнения используйте `assert.EqualValues` или отдельные поля.

## Пользовательские сообщения
Все функции принимают дополнительные аргументы — формат и параметры:
```go
assert.Equal(t, 2, 1+1, "сумма должна быть %d", 2)
```

## Функции для коллекций
* `assert.ElementsMatch(t, []int{1,2,3}, []int{3,1,2})` — без учёта порядка.
* `assert.Subset(t, []int{1,2,3}, []int{1,3})`

## Проверка паник
```go
assert.Panics(t, func() { panic("oops") })
assert.NotPanics(t, func() { /* спокойно */ })
```
Пакет `assert` — основной инструмент для проверки условий без аварийного завершения теста.