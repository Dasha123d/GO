# Пример: Middleware Casbin для Gin

Полный пример веб-сервера с аутентификацией (заглушка) и авторизацией через Casbin.

```go
// gin-casbin-middleware.go
package main

import (
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
	"github.com/casbin/casbin/v2"
)

func authMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		auth := c.GetHeader("Authorization")
		if !strings.HasPrefix(auth, "Bearer ") {
			c.AbortWithStatusJSON(401, gin.H{"error": "no token"})
			return
		}
		// в реальности проверяем JWT и извлекаем пользователя
		user := "alice" // заглушка
		c.Set("user", user)
		c.Next()
	}
}

func casbinMiddleware(e *casbin.Enforcer) gin.HandlerFunc {
	return func(c *gin.Context) {
		user := c.GetString("user")
		path := c.Request.URL.Path
		method := c.Request.Method

		ok, err := e.Enforce(user, path, method)
		if err != nil || !ok {
			c.AbortWithStatusJSON(403, gin.H{"error": "forbidden"})
			return
		}
		c.Next()
	}
}

func main() {
	// Модель и политика в коде для простоты
	model := `
[request_definition]
r = sub, obj, act
[policy_definition]
p = sub, obj, act
[matchers]
m = r.sub == p.sub && keyMatch(r.obj, p.obj) && r.act == p.act
[policy_effect]
e = some(where (p.eft == allow))
`
	adapter := casbin.NewAdapter([][]string{
		{"p", "alice", "/api/data", "GET"},
		{"p", "alice", "/api/data", "POST"},
	})
	e, _ := casbin.NewEnforcer(casbin.NewModel(model), adapter)

	r := gin.Default()
	r.Use(authMiddleware())

	api := r.Group("/api").Use(casbinMiddleware(e))
	api.GET("/data", func(c *gin.Context) {
		c.JSON(200, gin.H{"data": "read"})
	})
	api.POST("/data", func(c *gin.Context) {
		c.JSON(200, gin.H{"data": "created"})
	})

	r.Run(":8080")
}
```
## Check
```bash
curl -H "Authorization: Bearer fake" http://localhost:8080/api/data
```