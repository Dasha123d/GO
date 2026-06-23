# Быстрый старт: установка и замена encoding/json

## Установка

```bash
go get github.com/json-iterator/go
```
## Замена в один импорт
```go
import jsoniter "github.com/json-iterator/go"

var json = jsoniter.ConfigCompatibleWithStandardLibrary

func main() {
    data, _ := json.Marshal(map[string]string{"hello": "world"})
    fmt.Println(string(data))
}
```
Вы можете заменить `encoding/json` на `jsoniter` глобально, просто поменяв импорт и использовав переменную `json` (или переименовав импорт в `json`).

## Стандартный API
```go
// Маршалинг
type User struct {
    Name string `json:"name"`
    Age  int    `json:"age"`
}
u := User{"Alice", 25}
data, err := json.Marshal(u)

// Анмаршалинг
var u2 User
err = json.Unmarshal(data, &u2)
```
API полностью совместим с `encoding/json`: те же теги, те же функции.