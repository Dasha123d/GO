# Fasthttp и Gin: сравнение и совместимость

## Fasthttp vs Gin/Gonic

- **Gin** построен на `net/http`. Удобная маршрутизация, множество middleware.
- **Fasthttp** — высокопроизводительный HTTP-сервер без стандартного API.
- **Fiber** — веб-фреймворк на основе fasthttp, вдохновлённый Express.js; по производительности сравним с fasthttp, но с удобным API как у Gin.

## Можно ли использовать Gin-подобное на fasthttp?

Да, через **Fiber** (`github.com/gofiber/fiber/v2`):

```go
import "github.com/gofiber/fiber/v2"

app := fiber.New()
app.Get("/", func(c *fiber.Ctx) error {
    return c.SendString("Hello, Fiber!")
})
app.Listen(":3000")
```
Fiber использует fasthttp внутри и предлагает почти такой же интерфейс, как Gin.

## Интеграция fasthttp с Gin
Нельзя напрямую встроить fasthttp в Gin, потому что Gin основан на `net/http`. Можно запустить fasthttp-сервер как отдельный прокси для быстрых эндпоинтов, а тяжёлые оставить на Gin.

## Миграция с Gin на Fiber
* `gin.Context` → `fiber.Ctx`
* `c.JSON(200, obj)` → `c.JSON(obj)`
* Middleware переписываются, но логика схожа.

## Когда использовать чистый fasthttp?
* Нужна максимальная производительность.
* Пишете собственный роутер или прокси.
* Хотите минимальные накладные расходы.

## Когда предпочесть Fiber?
* Хочется сохранить удобство разработки как на Gin/Echo.
* Нужны готовые middleware.
* Скорость всё ещё выше, чем у `net/http`-фреймворков.