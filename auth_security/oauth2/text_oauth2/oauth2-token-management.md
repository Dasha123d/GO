# Управление токенами: сохранение, обновление, кеширование

## Автоматическое обновление через TokenSource

Библиотека сама умеет обновлять токен, если использовать `oauth2.Config.Client()` или вручную создать `oauth2.ReuseTokenSource`:

```go
func getClient(token *oauth2.Token) *http.Client {
	ts := googleOauthConfig.TokenSource(context.Background(), token)
	// Оборачиваем в ReuseTokenSource для кеширования
	reuseTS := oauth2.ReuseTokenSource(token, ts)
	return oauth2.NewClient(context.Background(), reuseTS)
}
```
Теперь при каждом запросе клиент будет проверять, не истёк ли токен, и обновлять его с помощью refresh-токена.

## Сохранение и восстановление токена
После первого обмена сохраните `*oauth2.Token` в закодированном виде (JSON). При старте приложения загружайте его и передавайте в `TokenSource`.
```go
// Сохранить
data, _ := json.Marshal(token)
os.WriteFile("token.json", data, 0600)

// Загрузить
data, _ := os.ReadFile("token.json")
var token oauth2.Token
json.Unmarshal(data, &token)

// Использовать с автообновлением
client := getClient(&token)
```
## Пользовательская стратегия хранения
Если нужно хранить в БД – реализуйте свой `TokenSource`, который при обновлении сохраняет новый токен.
```go
type DBTokenSource struct {
	config    *oauth2.Config
	token     *oauth2.Token
	userID    string
}

func (d *DBTokenSource) Token() (*oauth2.Token, error) {
	token, err := d.config.TokenSource(context.Background(), d.token).Token()
	if err != nil {
		return nil, err
	}
	// Сохраняем новый токен в БД
	saveTokenToDB(d.userID, token)
	d.token = token
	return token, nil
}
```