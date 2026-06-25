# Пакет `require`: жёсткие утверждения

## Отличие от `assert`

Если утверждение из `require` проваливается, тест немедленно останавливается (`t.FailNow()`). Это полезно, когда дальнейшие проверки бессмысленны (например, объект nil).

## API идентичен `assert`

Все функции из `assert` доступны в `require`:

```go
require.NoError(t, err)      // если ошибка — тест стоп
require.NotNil(t, db)        // если db == nil — стоп
require.Equal(t, 1, id)
```
## Практика использования
* Перед тестированием логики, зависящей от успешной настройки, используйте `require`.
* Внутри проверок самого поведения — `assert`.
```go
func TestUser(t *testing.T) {
    user, err := FetchUser(1)
    require.NoError(t, err)
    require.NotNil(t, user)

    assert.Equal(t, "Alice", user.Name)
    assert.True(t, user.Active)
}
```
Здесь первая часть — «настройка» с `require`, вторая — «поведение» с `assert`.

## Цепочки вызовов
`require` возвращает `*require.Assertions`, позволяя цепочки:
```go
require.New(t).Equal(1, id).True(ok)
```