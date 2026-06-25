# Транзакции

## Выполнение в транзакции

```go
err := client.WithTx(ctx, func(tx *ent.Tx) error {
    u, err := tx.User.Create().SetName("Alice").Save(ctx)
    if err != nil {
        return err
    }
    _, err = tx.Pet.Create().SetName("Rex").SetOwner(u).Save(ctx)
    return err
})
```
Откат происходит автоматически при возврате ошибки.

## Ручной контроль
```go
tx, _ := client.Tx(ctx)
defer tx.Rollback()
u, _ := tx.User.Create().SetName("Bob").Save(ctx)
tx.Commit()
```
## Вложенные транзакции (savepoints)
```go
tx, _ := client.Tx(ctx)
sp, _ := tx.BeginTx(ctx, nil) // savepoint
sp.User.Create()...
sp.Rollback()
tx.Commit()
```
## Распространение транзакции через контекст
ent позволяет получить текущую транзакцию из контекста через `ent.TxFromContext(ctx)`.