# Интеграция Casbin с Gin

## Middleware авторизации

Создадим middleware, который проверяет доступ на основе роли пользователя из JWT (или сессии). Предположим, что пользователь сохранён в контексте.

```go
func CasbinMiddleware(e *casbin.Enforcer) gin.HandlerFunc {
    return func(c *gin.Context) {
        // получаем пользователя из контекста (установлен после аутентификации)
        user, exists := c.Get("user")
        if !exists {
            c.AbortWithStatusJSON(401, gin.H{"error": "user not authenticated"})
            return
        }
        username := user.(string)

        // путь и метод как объект и действие
        obj := c.Request.URL.Path
        act := c.Request.Method

        ok, err := e.Enforce(username, obj, act)
        if err != nil {
            c.AbortWithStatusJSON(500, gin.H{"error": "internal error"})
            return
        }
        if !ok {
            c.AbortWithStatusJSON(403, gin.H{"error": "forbidden"})
            return
        }
        c.Next()
    }
}
```
## Использование
```go
func main() {
    r := gin.Default()
    e, _ := casbin.NewEnforcer("model.conf", "policy.csv")

    // аутентификация (упрощённо)
    r.POST("/login", func(c *gin.Context) {
        // ... проверка, сохраняем "alice"
        c.Set("user", "alice")
        c.JSON(200, gin.H{"msg": "logged in"})
    })

    // защищённая группа
    api := r.Group("/api")
    api.Use(CasbinMiddleware(e))
    api.GET("/data", func(c *gin.Context) {
        c.JSON(200, gin.H{"data": "secret"})
    })
    api.POST("/data", func(c *gin.Context) {
        c.JSON(200, gin.H{"data": "created"})
    })
    r.Run(":8080")
}
```
### Модель, например, RBAC:
```ini
[request_definition]
r = sub, obj, act

[policy_definition]
p = sub, obj, act

[role_definition]
g = _, _

[matchers]
m = g(r.sub, p.sub) && keyMatch(r.obj, p.obj) && r.act == p.act
```
### Политика:
```csv
p, admin, /api/*, GET
p, admin, /api/*, POST
g, alice, admin
```
Теперь `alice` имеет доступ к `/api/*`.