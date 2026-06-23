# Интеграция OAuth2 с Gin

## Middleware для проверки аутентификации

Создадим middleware, который проверяет наличие токена в сессии и при необходимости обновляет его.

```go
func AuthRequired() gin.HandlerFunc {
	return func(c *gin.Context) {
		token, err := getTokenFromSession(c)
		if err != nil || token == nil {
			// Сохраняем исходный URL и редиректим на логин
			c.Set("return-to", c.Request.URL.String())
			c.Redirect(http.StatusTemporaryRedirect, "/login")
			c.Abort()
			return
		}

		// Создаём http-клиент с автообновлением
		ts := googleOauthConfig.TokenSource(c, token)
		client := oauth2.NewClient(c, ts)

		// Можно сохранить клиент в контексте
		c.Set("oauth-client", client)
		c.Set("token", token)
		c.Next()
	}
}
```
## Routes
```go
func setupRoutes(r *gin.Engine) {
	r.GET("/login", func(c *gin.Context) {
		state := generateRandomState()
		c.SetCookie("oauthstate", state, 3600, "/", "", false, true)
		url := googleOauthConfig.AuthCodeURL(state)
		c.Redirect(http.StatusTemporaryRedirect, url)
	})

	r.GET("/callback", func(c *gin.Context) {
		state, _ := c.Cookie("oauthstate")
		if c.Query("state") != state {
			c.AbortWithError(http.StatusBadRequest, errors.New("invalid state"))
			return
		}
		code := c.Query("code")
		token, err := googleOauthConfig.Exchange(c, code)
		if err != nil {
			c.AbortWithError(500, err)
			return
		}
		// Сохраняем токен в сессию (или БД)
		saveTokenToSession(c, token)
		// Редиректим на изначальный путь
		returnTo := c.GetString("return-to")
		if returnTo == "" {
			returnTo = "/"
		}
		c.Redirect(http.StatusFound, returnTo)
	})

	protected := r.Group("/app")
	protected.Use(AuthRequired())
	protected.GET("/profile", func(c *gin.Context) {
		client := c.MustGet("oauth-client").(*http.Client)
		resp, _ := client.Get("https://www.googleapis.com/oauth2/v2/userinfo")
		// ...
	})
}
```
## Сохранение токена в сессии
```go
func saveTokenToSession(c *gin.Context, token *oauth2.Token) {
	data, _ := json.Marshal(token)
	c.SetCookie("oauth_token", base64.StdEncoding.EncodeToString(data), 86400, "/", "", false, true)
}

func getTokenFromSession(c *gin.Context) (*oauth2.Token, error) {
	cookie, err := c.Cookie("oauth_token")
	if err != nil {
		return nil, err
	}
	data, err := base64.StdEncoding.DecodeString(cookie)
	if err != nil {
		return nil, err
	}
	var token oauth2.Token
	err = json.Unmarshal(data, &token)
	return &token, err
}
```
Важно: для production используйте защищённую сессию (например, gorilla/sessions с Redis), а не куки с токеном напрямую.