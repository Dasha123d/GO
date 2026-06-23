# Пример: Регистрация пользовательских энкодера/декодера

```go
package main

import (
    "fmt"
    "unsafe"
    "github.com/json-iterator/go"
)

type Color struct {
    R, G, B uint8
}

type colorCodec struct{}

func (c *colorCodec) Encode(ptr unsafe.Pointer, stream *jsoniter.Stream) {
    col := (*Color)(ptr)
    stream.WriteString(fmt.Sprintf("#%02x%02x%02x", col.R, col.G, col.B))
}

func (c *colorCodec) Decode(ptr unsafe.Pointer, iter *jsoniter.Iterator) {
    str := iter.ReadString()
    var r, g, b uint8
    fmt.Sscanf(str, "#%02x%02x%02x", &r, &g, &b)
    *(*Color)(ptr) = Color{r, g, b}
}

func init() {
    jsoniter.RegisterTypeEncoder("main.Color", &colorCodec{})
    jsoniter.RegisterTypeDecoder("main.Color", &colorCodec{})
}

func main() {
    type Item struct {
        Name  string `json:"name"`
        Color Color  `json:"color"`
    }
    item := Item{Name: "lamp", Color: Color{255, 128, 0}}
    data, _ := jsoniter.ConfigDefault.Marshal(item)
    fmt.Println(string(data)) // {"name":"lamp","color":"#ff8000"}

    var item2 Item
    jsoniter.ConfigDefault.Unmarshal(data, &item2)
    fmt.Printf("%+v\n", item2) // {Name:lamp Color:{255,128,0}}
}
```