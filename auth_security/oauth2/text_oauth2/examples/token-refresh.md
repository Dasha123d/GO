# Пример: Автоматическое обновление токена

Демонстрирует сохранение токена в файл и автоматическое обновление.

```go
package main

import (
	"context"
	"encoding/json"
	"log"
	"net/http"
	"os"
	"golang.org/x/oauth2"
)

func main() {
	config := &oauth2.Config{
		// ...
	}
	// Загружаем токен из файла
	token, err := loadToken("token.json")
	if err != nil {
		log.Fatal("Необходимо сначала авторизоваться и сохранить токен")
	}
	ts := config.TokenSource(context.Background(), token)
	reuseTS := oauth2.ReuseTokenSource(token, ts)
	client := oauth2.NewClient(context.Background(), reuseTS)

	// Клиент автоматически обновит токен, если он истёк
	resp, err := client.Get("https://api.example.com/data")
	// ...

	// После запроса новый токен можно сохранить
	newToken, _ := reuseTS.Token()
	saveToken("token.json", newToken)
}

func loadToken(path string) (*oauth2.Token, error) {
	f, err := os.Open(path)
	// ...
}
```