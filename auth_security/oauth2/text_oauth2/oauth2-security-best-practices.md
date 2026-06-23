# Безопасность OAuth2: лучшие практики

## 1. Защита от CSRF: параметр `state`

Всегда используйте случайный `state` при запросе авторизации. Проверяйте его в callback. Храните в session cookie или кратковременном хранилище.

## 2. Используйте PKCE для публичных клиентов

Если у вас SPA или мобильное приложение без секрета, обязательно используйте PKCE (Proof Key for Code Exchange). В Go это делается через `oauth2.Config` с дополнительной опцией.

```go
codeVerifier := oauth2.GenerateVerifier()
url := config.AuthCodeURL("state", oauth2.AccessTypeOffline,
	oauth2.SetAuthURLParam("code_challenge", oauth2.S256ChallengeFromVerifier(codeVerifier)),
	oauth2.SetAuthURLParam("code_challenge_method", "S256"))
// При обмене добавьте code_verifier
token, err := config.Exchange(ctx, code,
	oauth2.SetAuthURLParam("code_verifier", codeVerifier))
```
## 3. Валидация Redirect URL
Никогда не используйте открытые редиректы. `RedirectURL` должен быть фиксированным. Библиотека сама не позволяет передать другой URL, но вы должны убедиться, что callback не редиректит на внешние ресурсы.

## 4. Минимальные scope
Запрашивайте только те разрешения, которые нужны. Не просите `drive` если достаточно `email`.

## 5. Храните ClientSecret и токены безопасно
* ClientSecret – только на серверной стороне.
* Refresh-токены – храните в зашифрованном виде (БД, секреты окружения).
* Никогда не передавайте access-токены в URL (используйте заголовок Authorization).

## 6. Используйте HTTPS
Все взаимодействия с провайдером и вашим сервером должны идти по TLS.

## 7. Проверяйте подпись токенов (ID Token)
Если вы используете OpenID Connect, всегда проверяйте JWT ID-токен стандартными средствами (nonce, aud, issuer, signature) перед тем, как считать пользователя аутентифицированным.

## 8. Обработка ошибок
Не показывайте пользователю детальные ошибки от провайдера, логируйте их на сервере.