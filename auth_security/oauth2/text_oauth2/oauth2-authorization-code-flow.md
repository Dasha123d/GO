# Authorization Code Flow: полный цикл

## Структура обработчиков (net/http)

```go
var oauthStateString = "super-random-state"

func handleLogin(w http.ResponseWriter, r *http.Request) {
	url := googleOauthConfig.AuthCodeURL(oauthStateString)
	http.Redirect(w, r, url, http.StatusTemporaryRedirect)
}

func handleCallback(w http.ResponseWriter, r *http.Request) {
	// Проверяем state (защита от CSRF)
	if r.FormValue("state") != oauthStateString {
		http.Error(w, "Invalid state", http.StatusBadRequest)
		return
	}

	code := r.FormValue("code")
	token, err := googleOauthConfig.Exchange(context.Background(), code)
	if err != nil {
		http.Error(w, "Ошибка обмена кода: "+err.Error(), http.StatusInternalServerError)
		return
	}

	// Используем токен для запроса к API
	client := googleOauthConfig.Client(context.Background(), token)
	resp, err := client.Get("https://www.googleapis.com/oauth2/v2/userinfo")
	// ... читаем данные пользователя
}
```
## Важные моменты
1. State – обязателен для предотвращения CSRF. Генерируйте случайную строку для каждой сессии и храните (например, в cookie или сессии сервера).
2. Exchange – обменивает `authorization code` на `*oauth2.Token` (access + refresh токен).
3. После обмена храните токен в безопасном месте (сессия, БД).
4. Используйте `config.Client(ctx, token)` – он возвращает `*http.Client`, который автоматически добавляет access-токен в запросы и умеет обновлять его при необходимости.