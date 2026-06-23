
# Пример: RBAC с иерархией ролей

```go
// rbac-with-roles.go
package main

import (
	"fmt"
	"github.com/casbin/casbin/v2"
)

func main() {
	model := `
[request_definition]
r = sub, obj, act

[policy_definition]
p = sub, obj, act

[role_definition]
g = _, _

[matchers]
m = g(r.sub, p.sub) && r.obj == p.obj && r.act == p.act

[policy_effect]
e = some(where (p.eft == allow))
`
	adapter := casbin.NewAdapter([][]string{
		// разрешения ролей
		{"p", "admin", "/admin", "GET"},
		{"p", "admin", "/admin", "POST"},
		{"p", "editor", "/posts", "GET"},
		{"p", "editor", "/posts", "POST"},
		// ролевая иерархия
		{"g", "alice", "admin"},
		{"g", "bob", "editor"},
		{"g", "admin", "editor"}, // admin наследует права editor
	})

	e, _ := casbin.NewEnforcer(casbin.NewModel(model), adapter)

	// Alice как admin может всё
	fmt.Println(e.Enforce("alice", "/admin", "GET"))  // true
	fmt.Println(e.Enforce("alice", "/posts", "POST")) // true (через наследование)

	// Bob только editor
	fmt.Println(e.Enforce("bob", "/admin", "GET"))   // false
	fmt.Println(e.Enforce("bob", "/posts", "POST"))  // true
}
```