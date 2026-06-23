# Быстрый старт: установка и первая проверка доступа

## Установка

```bash
go get github.com/casbin/casbin/v
```
## Модель и политика
Casbin разделяет логику авторизации на модель (как принимать решение) и политику (какие правила).
Они описываются в отдельных файлах.

model.conf (ACL-модель):
```ini
[request_definition]
r = sub, obj, act

[policy_definition]
p = sub, obj, act

[matchers]
m = r.sub == p.sub && r.obj == p.obj && r.act == p.act

[policy_effect]
e = some(where (p.eft == allow))
```
policy.csv (правила):
```csv
p, alice, data1, read
p, bob, data2, write
```
## Первая проверка
```go
package main

import (
	"fmt"
	"github.com/casbin/casbin/v2"
)

func main() {
	e, err := casbin.NewEnforcer("model.conf", "policy.csv")
	if err != nil {
		panic(err)
	}

	// alice может читать data1?
	ok, _ := e.Enforce("alice", "data1", "read")
	fmt.Println("alice / data1 / read:", ok) // true

	ok, _ = e.Enforce("bob", "data1", "write")
	fmt.Println("bob / data1 / write:", ok) // false
}
```
Вы уже получили работающую авторизацию на основе ACL. Модель и политику можно менять без перекомпиляции.