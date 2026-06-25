# Схемы и кодогенерация

## Поля

```go
func (User) Fields() []ent.Field {
    return []ent.Field{
        field.String("email").Unique(),
        field.Bool("active").Default(true),
        field.Time("created_at").Default(time.Now),
        field.JSON("props", map[string]interface{}{}).Optional(),
    }
}
```
Доступные типы: `String`, `Int`, `Float`, `Bool`, `Time`, `Enum`, `JSON`.

## Индексы
```go
func (User) Indexes() []ent.Index {
    return []ent.Index{
        index.Fields("email").Unique(),
        index.Fields("name", "age"),
    }
}
```
## Edges (связи) – пример
```go
func (User) Edges() []ent.Edge {
    return []ent.Edge{
        edge.To("cars", Car.Type),
        edge.From("groups", Group.Type).Ref("users"),
    }
}
```

## Аннотации и хуки
```go
func (User) Annotations() []schema.Annotation {
    return []schema.Annotation{
        ent.FieldComment("created_at", "Время создания пользователя"),
    }
}
```
Можно вешать хуки мутации (OnCreate, OnUpdate) на уровне схемы.
## Генерация
```bash
ent generate ./ent/schema
```
Выполняется из корня модуля. Можно добавить `//go:generate ent generate ./ent/schema`.

## Интеграция с миграциями
Для прода используйте `atlas` (официальный инструмент миграций ent), а не `Schema.Create`.