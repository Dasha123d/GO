# Client Credentials Flow (server-to-server)

Используется, когда приложение запрашивает доступ от своего имени, без участия пользователя.

```go
func main() {
	config := &oauth2.Config{
		ClientID:     os.Getenv("CLIENT_ID"),
		ClientSecret: os.Getenv("CLIENT_SECRET"),
		Endpoint:     google.Endpoint,
		Scopes:       []string{"https://www.googleapis.com/auth/cloud-platform"},
	}

	ctx := context.Background()
	// Получаем токен
	token, err := config.PasswordCredentialsToken(ctx, "", "") // не используется
	// Или используем golang.org/x/oauth2/clientcredentials
}
```
Для Client Credentials удобнее пакет `golang.org/x/oauth2/clientcredentials`:
```go
import "golang.org/x/oauth2/clientcredentials"

cfg := clientcredentials.Config{
	ClientID:     os.Getenv("CLIENT_ID"),
	ClientSecret: os.Getenv("CLIENT_SECRET"),
	TokenURL:     google.Endpoint.TokenURL,
	Scopes:       []string{"https://www.googleapis.com/auth/cloud-platform"},
}

client := cfg.Client(context.Background())
resp, err := client.Get("https://www.googleapis.com/...")
```
Токен автоматически получается и обновляется при необходимости.