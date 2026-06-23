# Модели и политики: синтаксис и возможности

## Секции модели

- **request_definition** – структура запроса: `r = sub, obj, act` (субъект, объект, действие).
- **policy_definition** – структура правила политики: `p = sub, obj, act` (можно `eft` – allow/deny).
- **role_definition** – для RBAC: `g = _, _` (связь пользователь-роль).
- **matchers** – условие, когда правило применяется.
- **policy_effect** – как комбинируются результаты: `some(where (p.eft == allow))` (достаточно одного allow).

## Matchers

Пишутся на языке, похожем на выражения. Поддерживают:
- Сравнения: `==`, `!=`, `>`, `<`
- Логические операторы: `&&`, `||`, `!`
- Встроенные функции: `keyMatch`, `regexMatch`, `ipMatch`
- Пользовательские функции (регистрируются через `enforcer.AddFunction()`)

Пример модели с матчингом URL:
```ini
[matchers]
m = r.sub == p.sub && keyMatch(r.obj, p.obj) && r.act == p.act
```
`keyMatch` поддерживает шаблоны: `/foo/*`, `/foo/:resource`.

## Политики
Могут загружаться из файлов (CSV) или адаптеров (БД). Формат CSV повторяет строки `policy_definition`.
```csv
p, admin, /*, read
p, admin, /*, write
p, user, /profile, read
```
## Эффекты
* `some(where (p.eft == allow))` – доступ разрешён, если хоть одно правило allow.
* `!some(where (p.eft == deny))` – доступ разрешён, если нет deny-правил (явное отрицание).
* Можно комбинировать приоритеты: `priority(p.eft) || deny`.

## Роли (RBAC)
```ini
[role_definition]
g = _, _

[matchers]
m = g(r.sub, p.sub) && r.obj == p.obj && r.act == p.act
```
### Политика ролей:
```csv
g, alice, admin
g, bob, user
```
Теперь `alice` наследует права роли `admin`.