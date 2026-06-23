# Быстрый старт: установка и первый обмен

## Установка

```bash
go get golang.org/x/oauth2
```
### Первый шаг – конфигурация и получение URL
```go
package main

import (
	"fmt"
	"log"
	"golang.org/x/oauth2"
	"golang.org/x/oauth2/google"
)

var googleOauthConfig = &oauth2.Config{
	RedirectURL:  "http://localhost:8080/callback",
	ClientID:     "ВАШ_CLIENT_ID",
	ClientSecret: "ВАШ_CLIENT_SECRET",
	Scopes:       []string{"https://www.googleapis.com/auth/userinfo.email"},
	Endpoint:     google.Endpoint,
}

func main() {
	url := googleOauthConfig.AuthCodeURL("random-state-string")
	fmt.Println("Перейдите по ссылке для авторизации:", url)
}
```
* ClientID/ClientSecret – получите в консоли Google Cloud (или другого провайдера).
* RedirectURL – должен совпадать с настройками приложения у провайдера.
* Endpoint – можно использовать готовые константы (`google.Endpoint`, `github.Endpoint`, `facebook.Endpoint`) или задать свои.
* AuthCodeURL(state) – генерирует URL для перенаправления пользователя на страницу входа.

После того, как пользователь разрешил доступ, он будет перенаправлен на `RedirectURL` с параметром `code`. Дальше – обмен кода на токен.