# Контроллер и его настройка

## NewController vs NewControllerWithContext

Стандартный контроллер использует `*testing.T`:

```go
ctrl := gomock.NewController(t)
defer ctrl.Finish()
```
Для более тонкой настройки (например, изменить формат ошибок) можно использовать `gomock.WithContext`:
```go
ctrl := gomock.NewController(t, gomock.WithContext(ctx))
```
## Finish и Cleanup
* `ctrl.Finish()` — обязателен для проверки, что все ожидания выполнены.
* Или `t.Cleanup(ctrl.Finish)` для автоматической проверки.

## Настройка контроллера
* `gomock.WithContext(ctx)` — передаёт контекст для отмены.
* `gomock.WithStackTraces(false)` — отключает стек-трейс в сообщениях об ошибках (производительность).
* `gomock.WithOverridableExpectations()` — разрешает переопределять ожидания.

## Параллельные тесты
Контроллер потокобезопасен, но не рекомендуется использовать один контроллер для нескольких параллельных тестов. Лучше создавать отдельный на каждый тест.

## Утечки
Если `ctrl.Finish()` не вызван, тест может пройти, но с утечкой горутин. Всегда используйте defer `ctrl.Finish()`.