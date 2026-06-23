# Пример: JWT middleware для Gin

Файл: `examples/gin-jwt-middleware.go`

Реализация middleware, извлекающего и проверяющего токен из заголовка `Authorization: Bearer <token>`. Кладет claims в контекст Gin.

```go
package main

import (
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
)

var jwtKey = []byte("my-secret")

// Claims структура
type Claims struct {
	jwt.RegisteredClaims
	Username string `json:"username"`
}

// AuthMiddleware проверяет JWT
func AuthMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		authHeader := c.GetHeader("Authorization")
		if authHeader == "" || !strings.HasPrefix(authHeader, "Bearer ") {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "нет токена"})
			return
		}
		tokenStr := strings.TrimPrefix(authHeader, "Bearer ")

		claims := &Claims{}
		token, err := jwt.ParseWithClaims(tokenStr, claims, func(t *jwt.Token) (interface{}, error) {
			return jwtKey, nil
		})
		if err != nil || !token.Valid {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "невалидный токен"})
			return
		}
		// Кладем claims в контекст
		c.Set("claims", claims)
		c.Next()
	}
}

func main() {
	r := gin.Default()

	r.POST("/login", func(c *gin.Context) {
		// Здесь проверка логина/пароля
		claims := Claims{
			RegisteredClaims: jwt.RegisteredClaims{
				Subject: "123",
			},
			Username: "john",
		}
		token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
		signed, _ := token.SignedString(jwtKey)
		c.JSON(http.StatusOK, gin.H{"token": signed})
	})

	protected := r.Group("/api").Use(AuthMiddleware())
	protected.GET("/profile", func(c *gin.Context) {
		cl, _ := c.Get("claims")
		claims := cl.(*Claims)
		c.JSON(http.StatusOK, gin.H{"user": claims.Username})
	})

	r.Run(":8080")
}
```
### Запуск:
```bash
go run examples/gin-jwt-middleware.go
```
### Проверка
```bash
curl -X POST http://localhost:8080/login  # получить токен
curl -H "Authorization: Bearer <token>" http://localhost:8080/api/profile
```