# Транзакции

## Использование транзакции

```go
tx, err := db.BeginTx(ctx, nil)
if err != nil {
    log.Fatal(err)
}
defer tx.Rollback()

user := &models.User{Name: "Alice"}
err = user.Insert(ctx, tx, boil.Infer())
if err != nil {
    return err
}

order := &models.Order{UserID: user.ID, Amount: 100}
err = order.Insert(ctx, tx, boil.Infer())
if err != nil {
    return err
}

err = tx.Commit()
```
## Хелпер boil.WithTx
```go
err = boil.WithTx(ctx, db, func(ctx context.Context, tx *sql.Tx) error {
    user.Insert(ctx, tx, boil.Infer())
    // ...
    return nil
})
```
## Передача контекста
Контекст с транзакцией можно извлечь через `boil.ContextWithTx(ctx, tx)` и получить через `boil.TxFromContext(ctx)`.

## Savepoints
Поддерживаются через сырой `tx.Exec("SAVEPOINT sp1")`, встроенного API нет. Обычно используют `WithTx` для атомарности.