# Продвинутое использование Sonic: AST, потоковая обработка и кастомные сериализаторы

## Абстрактное синтаксическое дерево (AST)

Sonic предоставляет `ast.Node` для эффективного манипулирования JSON без полной десериализации в структуру.

```go
import "github.com/bytedance/sonic/ast"

data := []byte(`{"user":{"name":"Alice","roles":["admin","editor"]}}`)
root, err := ast.NewParser().Parse(string(data))
if err != nil {
    panic(err)
}
name := root.Get("user").Get("name").MustString()
roles := root.Get("user").Get("roles")
for i := 0; i < roles.Len(); i++ {
    fmt.Println(roles.Index(i).MustString())
}
// вывод: Alice, admin, editor
```
AST позволяет извлекать вложенные значения, модифицировать JSON и сериализовать обратно без полного демаршалинга, что экономит память и CPU.

## Потоковая обработка (Streaming)
Для больших JSON-документов используйте `sonic/decoder` и `sonic/encoder`:
```go
import (
    "strings"
    "github.com/bytedance/sonic/decoder"
    "github.com/bytedance/sonic/encoder"
)

func main() {
    input := `{"a":1}{"b":2}` // несколько JSON-объектов
    dec := decoder.NewStreamDecoder(strings.NewReader(input))
    for dec.More() {
        var m map[string]interface{}
        if err := dec.Decode(&m); err != nil {
            panic(err)
        }
        fmt.Println(m)
    }
}
```
## Кастомные Marshaler/Unmarshaler
Sonic поддерживает интерфейсы `json.Marshaler` и `json.Unmarshaler` как в стандартной библиотеке. А также собственные интерфейсы `sonic.Marshaler` и `sonic.Unmarshaler` для более тонкого контроля.
```go
type User struct {
    Name string
    Data customType
}

func (u User) MarshalJSON() ([]byte, error) {
    return sonic.Marshal(struct {
        Name string `json:"name"`
    }{u.Name})
}
```
## Интроспекция и Visitor
Можно обойти дерево AST с помощью `visitor`:
```go
import "github.com/bytedance/sonic/ast"
root, _ := ast.NewParser().Parse(`...`)
root.Visit(func(path ast.Path, node ast.Node) bool {
    fmt.Println("path:", path, "type:", node.Type())
    return true // продолжать
})
```
