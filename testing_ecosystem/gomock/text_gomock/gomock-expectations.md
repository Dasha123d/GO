# Регистрация ожиданий в gomock

## Простой вызов

```go
mockRepo.EXPECT().FindByID(1).Return(&User{Name: "Alice"}, nil)
```
## Матчеры аргументов
* `gomock.Eq(1)` — точное соответствие (по умолчанию).
* `gomock.Any()` — любой аргумент.
* `gomock.Nil()` — nil.
* `gomock.Not(gomock.Eq(0))` — не равно.
* `gomock.AssignableToTypeOf(&User{})` — соответствие типа.
```go
mockRepo.EXPECT().Save(gomock.AssignableToTypeOf(&User{}), nil)
```
Можно создать свой матчер через `gomock.Cond()`.

## Количество вызовов
* `Times(n)` — ровно n раз.
* `MinTimes(n)` / `MaxTimes(n)` — минимум/максимум.
* `AnyTimes()` — любое количество раз (включая 0).
```go
mockRepo.EXPECT().Log(gomock.Any()).AnyTimes()
```
## Порядок вызовов
```go
gomock.InOrder(
    mockRepo.EXPECT().Open(),
    mockRepo.EXPECT().Read().Return(data),
    mockRepo.EXPECT().Close(),
)
```

## Возврат ошибок или паник
```go
mockRepo.EXPECT().FindByID(0).Return(nil, errors.New("not found"))
mockRepo.EXPECT().Dangerous().DoAndReturn(func() { panic("crash") })
```

## Динамический возврат через DoAndReturn
```go
mockRepo.EXPECT().Get(gomock.Any()).DoAndReturn(func(id int) (*User, error) {
    if id > 0 {
        return &User{Name: "user"}, nil
    }
    return nil, errors.New("invalid")
})
```
## After для последовательности
```go
call1 := mockRepo.EXPECT().Step1()
call2 := mockRepo.EXPECT().Step2().After(call1)
```