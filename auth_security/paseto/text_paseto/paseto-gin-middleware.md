# Интеграция Paseto с Gin

## Middleware для проверки local токена

```go
func PasetoAuth(secretKey paseto.V4LocalKey) gin.HandlerFunc {
	return func(c *gin.Context) {
		authHeader := c.GetHeader("Authorization")
		if authHeader == "" || !strings.HasPrefix(authHeader, "Bearer ") {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "missing token"})
			return
		}
		tokenStr := strings.TrimPrefix(authHeader, "Bearer ")

		parsed, err := paseto.Parse(tokenStr, secretKey,
			paseto.WithIssuer("my-app"),
			paseto.WithLeeway(30*time.Second),
		)
		if err != nil {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "invalid token"})
			return
		}

		// Сохраняем claims в контексте
		c.Set("claims", parsed.Claims())
		c.Next()
	}
}
```
## Routes
```go
func main() {
	key, _ := paseto.NewV4LocalKeyFrom("k4.local-base64encoded-secret")

	r := gin.Default()
	api := r.Group("/api").Use(PasetoAuth(key))
	api.GET("/profile", func(c *gin.Context) {
		claims := c.MustGet("claims").(*paseto.Claims)
		sub, _ := claims.GetSubject()
		c.JSON(200, gin.H{"user": sub})
	})

	r.POST("/login", func(c *gin.Context) {
		// ... проверка логина
		claims := paseto.NewClaims()
		claims.SetSubject("user123")
		claims.SetExpiration(time.Now().Add(15 * time.Minute))
		claims.SetIssuer("my-app")
		token := paseto.NewToken(claims, nil)
		enc, _ := token.V4Encrypt(key)
		c.JSON(200, gin.H{"token": enc})
	})

	r.Run(":8080")
}
```
Для public токенов – аналогично, но при создании используется приватный ключ, а в middleware – публичный.