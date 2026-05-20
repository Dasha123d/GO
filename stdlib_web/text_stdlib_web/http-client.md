# HTTP-клиент: GET, POST, настройки

Пакет `net/http` предлагает несколько уровней абстракции для выполнения HTTP-запросов.

## Базовые функции

Для простых запросов можно использовать функции `Get`, `Post` и `PostForm`[reference:6].

```go
resp, err := http.Get("http://example.com/")
if err != nil {
    // handle error
}
defer resp.Body.Close()
body, err := io.ReadAll(resp.Body)
```
* Важно: клиент должен всегда закрывать тело ответа после завершения работы с ним.

## Кастомный клиент
Для контроля над заголовками, политикой редиректов и таймаутами создаётся экземпляр `http.Client`
```go
client := &http.Client{
    CheckRedirect: redirectPolicyFunc,
    Timeout:       10 * time.Second,
}
resp, err := client.Get("http://example.com")
```

## Кастомный транспорт
Для тонкой настройки параметров соединения (TLS, прокси, пул соединений) используется `http.Transport`
```go
tr := &http.Transport{
    MaxIdleConns:       10,
    IdleConnTimeout:    30 * time.Second,
    DisableCompression: true,
}
client := &http.Client{Transport: tr}
resp, err := client.Get("https://example.com")
```
## Важные замечания
Клиенты (`*http.Client`) и транспорты (`*http.Transport`) безопасны для одновременного использования из нескольких горутин.

Для повышения эффективности их следует создавать один раз и переиспользовать.

Смотрите полный пример в `examples/http-client.go`.