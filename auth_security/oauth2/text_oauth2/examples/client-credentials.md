# Пример: Client Credentials

Получение токена для серверного приложения без пользователя.

```go
package main

import (
	"context"
	"fmt"
	"os"
	"golang.org/x/oauth2/clientcredentials"
)

func main() {
	cfg := clientcredentials.Config{
		ClientID:     os.Getenv("CLIENT_ID"),
		ClientSecret: os.Getenv("CLIENT_SECRET"),
		TokenURL:     "https://oauth2.googleapis.com/token",
		Scopes:       []string{"https://www.googleapis.com/auth/cloud-platform"},
	}
	client := cfg.Client(context.Background())
	resp, err := client.Get("https://storage.googleapis.com/storage/v1/b")
	if err != nil {
		panic(err)
	}
	fmt.Println(resp.Status)
}
```