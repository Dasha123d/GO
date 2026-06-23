# Продвинутое использование: extensions, ленивый парсинг, Any

## Регистрация пользовательских энкодеров/декодеров

jsoniter позволяет регистрировать функции для произвольных типов без изменения самого типа:

```go
import "github.com/json-iterator/go/extra"

// регистрация codec для time.Time
extra.RegisterTimeAsInt64Codec()

// или свой энкодер/декодер
jsoniter.RegisterTypeEncoder("mypackage.CustomType", &customEncoder{})
jsoniter.RegisterTypeDecoder("mypackage.CustomType", &customDecoder{})
```
Пример кастомного энкодера:
```go
type LatLng struct{ Lat, Lng float64 }

type latLngCodec struct{}

func (c *latLngCodec) Encode(ptr unsafe.Pointer, stream *jsoniter.Stream) {
    ll := (*LatLng)(ptr)
    stream.WriteArrayStart()
    stream.WriteFloat64(ll.Lat)
    stream.WriteMore()
    stream.WriteFloat64(ll.Lng)
    stream.WriteArrayEnd()
}
jsoniter.RegisterTypeEncoder("main.LatLng", &latLngCodec{})
```
## Ленивый парсинг (Any)
```go
import "github.com/json-iterator/go"

any := jsoniter.Get([]byte(`{"user":{"name":"Alice","age":25}}`))
name := any.Get("user").Get("name").ToString()
age := any.Get("user").Get("age").ToInt()
```
`Get` возвращает `Any` – ленивый интерфейс, позволяющий обходить JSON без полной десериализации в структуру.

## Итератор по массиву
```go
any := jsoniter.Get([]byte(`[1,2,3]`))
for i := 0; i < any.Size(); i++ {
    fmt.Println(any.Get(i).ToInt())
}
```
## Расширения из `extra`
Пакет `extra` предоставляет готовые регистрации:
* `extra.RegisterTimeAsInt64Codec()` – time.Time как Unix timestamp.
* `extra.RegisterFuzzyDecoders()` – нечёткий парсинг (строку в число, и т.п.).
* `extra.SetNamingStrategy(extra.LowerCaseWithUnderscores)` – snake_case без изменения структур.
```go
import "github.com/json-iterator/go/extra"
extra.SetNamingStrategy(extra.LowerCaseWithUnderscores)
```
После этого поле `UserName` будет сериализоваться как `user_name`.