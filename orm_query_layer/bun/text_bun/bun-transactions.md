# Транзакции

## Выполнение в транзакции

```go
err := db.RunInTx(ctx, nil, func(ctx context.Context, tx bun.Tx) error {
    user := &User{Name: "Alice"}
    _, err := tx.NewInsert().Model(user).Exec(ctx)
    if err != nil {
        return err
    }
    order := &Order{UserID: user.ID, Amount: 100}
    _, err = tx.NewInsert().Model(order).Exec(ctx)
    return err
})
```
Если функция возвращает ошибку, транзакция откатывается, иначе — фиксируется.

## Ручное управление
```go
tx, _ := db.BeginTx(ctx, nil)
defer tx.Rollback()

// операции...
if err == nil {
    tx.Commit()
}
```

## Изоляция
```go
tx, _ := db.BeginTx(ctx, &sql.TxOptions{Isolation: sql.LevelSerializable})
```
## Вложенные транзакции (savepoints)
```go
tx.Begin()
// ...
tx.Savepoint("sp1")
// ...
tx.RollbackTo("sp1")
tx.Commit()
```
## Передача контекста
Транзакция хранится в контексте при использовании `RunInTx`. Можно получить её обратно через bun.`TxFromContext(ctx)`.