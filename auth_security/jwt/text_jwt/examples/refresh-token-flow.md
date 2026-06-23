# Пример: полный flow refresh-токенов

Файл: `examples/refresh-token-flow.go`

Демонстрация эндпоинтов `/login` (выдаёт пару), `/refresh` (ротация), `GET /data` (защищённый).

```go
package main

import (
	"crypto/rand"
	"encoding/hex"
	"fmt"
	"net/http"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
)

var (
	accessKey  = []byte("access-secret")
	refreshKey = []byte("refresh-secret")
	// простой in-memory список отозванных refresh jti
	revoked = map[string]bool{}
)

type UserClaims struct {
	jwt.RegisteredClaims
	Email string `json:"email"`
}

func generateAccess(email, sub string) (string, error) {
	claims := UserClaims{
		RegisteredClaims: jwt.RegisteredClaims{
			Subject:   sub,
			ExpiresAt: jwt.NewNumericDate(time.Now().Add(15 * time.Minute)),
			IssuedAt:  jwt.NewNumericDate(time.Now()),
		},
		Email: email,
	}
	t := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	return t.SignedString(accessKey)
}

func generateRefresh(sub string) (string, string, error) {
	jti := make([]byte, 16)
	rand.Read(jti)
	jtiStr := hex.EncodeToString(jti)
	claims := jwt.RegisteredClaims{
		Subject:   sub,
		ExpiresAt: jwt.NewNumericDate(time.Now().Add(7 * 24 * time.Hour)),
		ID:        jtiStr,
	}
	t := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	signed, err := t.SignedString(refreshKey)
	return signed, jtiStr, err
}

func main() {
	r := gin.Default()

	r.POST("/login", func(c *gin.Context) {
		// упрощённо: без проверки пароля
		userID := "user-001"
		email := "user@example.com"
		access, _ := generateAccess(email, userID)
		refresh, jti, _ := generateRefresh(userID)
		c.JSON(http.StatusOK, gin.H{
			"access_token":  access,
			"refresh_token": refresh,
			"refresh_jti":   jti,
		})
	})

	r.POST("/refresh", func(c *gin.Context) {
		auth := c.GetHeader("Authorization")
		if !strings.HasPrefix(auth, "Bearer ") {
			c.AbortWithStatus(401)
			return
		}
		tokenStr := strings.TrimPrefix(auth, "Bearer ")
		claims := &jwt.RegisteredClaims{}
		token, err := jwt.ParseWithClaims(tokenStr, claims, func(t *jwt.Token) (interface{}, error) {
			return refreshKey, nil
		})
		if err != nil || !token.Valid {
			c.AbortWithStatusJSON(401, gin.H{"error": "невалидный refresh"})
			return
		}
		if revoked[claims.ID] {
			c.AbortWithStatusJSON(401, gin.H{"error": "токен отозван"})
			return
		}
		// Отзываем старый
		revoked[claims.ID] = true

		// Генерируем новую пару
		access, _ := generateAccess("user@example.com", claims.Subject)
		refresh, jti, _ := generateRefresh(claims.Subject)
		c.JSON(http.StatusOK, gin.H{
			"access_token":  access,
			"refresh_token": refresh,
			"refresh_jti":   jti,
		})
	})

	protected := r.Group("/data")
	protected.Use(func(c *gin.Context) {
		auth := c.GetHeader("Authorization")
		if !strings.HasPrefix(auth, "Bearer ") {
			c.AbortWithStatus(401)
			return
		}
		tokenStr := strings.TrimPrefix(auth, "Bearer ")
		claims := &UserClaims{}
		token, err := jwt.ParseWithClaims(tokenStr, claims, func(t *jwt.Token) (interface{}, error) {
			return accessKey, nil
		})
		if err != nil || !token.Valid {
			c.AbortWithStatus(401)
			return
		}
		c.Set("email", claims.Email)
		c.Next()
	})
	protected.GET("/", func(c *gin.Context) {
		c.JSON(200, gin.H{"data": "secret data"})
	})

	r.Run(":8080")
}
```
### Проверка flow:
```bash
# 1. Логин
curl -X POST http://localhost:8080/login

# 2. Использовать access
curl -H "Authorization: Bearer <access_token>" http://localhost:8080/data

# 3. Обновить
curl -X POST -H "Authorization: Bearer <refresh_token>" http://localhost:8080/refresh
```