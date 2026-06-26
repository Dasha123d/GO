# Лучшие практики Terraform Plugin SDK

## 1. Используйте `context.Context`

Передавайте `context.Background()` в API-вызовы, но можете использовать контекст из `ConfigureContextFunc`.

## 2. Обрабатывайте ошибки и «не найдено»

При ошибке 404 в Read возвращайте `nil` и вызывайте `d.SetId("")`.

## 3. Минимизируйте ForceNew

Только действительно неизменяемые поля должны вызывать пересоздание.

## 4. Задавайте `Importer`

Даже если импорт не поддерживается, добавьте простой `ImportStatePassthroughContext`.

## 5. Не паникуйте

Возвращайте ошибки (`error`), а не паникуйте.

## 6. Используйте `Timeout` и `WaitForState`

Для долгих операций:

```go
resource.RetryContext(ctx, d.Timeout(schema.TimeoutCreate), func() *resource.RetryError { ... })
```
## 7. Тестируйте с `Terraform Plugin SDK` acceptance tests
Запускайте в CI против тестового окружения с реальными API.

## 8. Документируйте провайдер
Создайте `docs/` и используйте `terraform-plugin-docs`.

## 9. Следите за версией SDK
Plugin SDK v2 — legacy, сейчас актуален `terraform-plugin-framework`. Планируйте миграцию.

## 10. Изолируйте состояние
Не храните конфиденциальные данные в состоянии без `Sensitive: true`.