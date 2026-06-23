# Пример: базовый Enforcer с ACL

Файлы модели и политики можно создать отдельно, но здесь встроенный код для демонстрации.

```go
// basic-enforcer.go
package main

import (
	"fmt"
	"github.com/casbin/casbin/v2"
)

func main() {
	// Модель в строке (можно и файл)
	modelText := `
[request_definition]
r = sub, obj, act
[policy_definition]
p = sub, obj, act
[matchers]
m = r.sub == p.sub && r.obj == p.obj && r.act == p.act
[policy_effect]
e = some(where (p.eft == allow))
`
	// Политика в памяти
	adapter := casbin.NewAdapter(
		[][]string{
			{"p", "alice", "data1", "read"},
			{"p", "bob", "data2", "write"},
		},
	)
	e, _ := casbin.NewEnforcer(casbin.NewModel(modelText), adapter)

	fmt.Println(e.Enforce("alice", "data1", "read"))  // true
	fmt.Println(e.Enforce("bob", "data1", "write"))   // false
}
```