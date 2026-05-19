# Custom Middleware

Пример написания собственных промежуточных обработчиков (middleware).

## Описание
Middleware — это функция, которая выполняется до или после основного хендлера.

## Примеры в коде
1. `RequestIDMiddleware` — генерирует ID запроса и добавляет в заголовок ответа.
2. `TimingMiddleware` — замеряет время выполнения запроса и логирует его.

## Синтаксис
Middleware должна соответствовать типу `echo.MiddlewareFunc`:
```go
func(next echo.HandlerFunc) echo.HandlerFunc