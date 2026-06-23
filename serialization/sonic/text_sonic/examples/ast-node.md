# Пример: Манипуляция JSON через AST

Файл: `examples/ast-node.go`

```go
package main

import (
    "fmt"
    "github.com/bytedance/sonic/ast"
)

func main() {
    input := `{"store":{"book":[{"title":"Go in Action","price":29.99},{"title":"Go Concurrency","price":19.99}]}}`
    root, _ := ast.NewParser().Parse(input)
    
    // Изменяем цену первой книги
    root.Get("store").Get("book").Index(0).Set("price", ast.NewNumber("24.99"))
    
    // Сериализуем обратно
    modified, _ := root.MarshalJSON()
    fmt.Println(string(modified))
}
```