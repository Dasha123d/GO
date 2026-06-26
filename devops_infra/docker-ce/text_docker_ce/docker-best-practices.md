# Лучшие практики Docker SDK for Go

## 1. Всегда используйте `WithAPIVersionNegotiation`

Без этого клиент может ломаться при разных версиях Docker.

## 2. Освобождайте ресурсы

- `defer cli.Close()`
- Читайте и закрывайте `io.ReadCloser` из ответов (`ImagePull`, `ContainerLogs`).

## 3. Передавайте контекст с таймаутом

```go
ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
defer cancel()
```
## 4. Обрабатывайте ошибки детально
Ошибки Docker API обёрнуты в errdefs:
```go
if errdefs.IsNotFound(err) { ... }
if errdefs.IsConflict(err) { ... }
```
## 5. Не дублируйте клиент
Создавайте один экземпляр `client.Client` на всё приложение.

## 6. Для CI/CD логируйте прогресс операций
Pull, push, build могут идти долго — показывайте прогресс.

## 7. Тестируйте с реальным Docker (или dind)
Используйте `testcontainers-go` или Docker-in-Docker.

## 8. Указывайте ресурсы контейнера
```go
hostConfig := &container.HostConfig{
    Resources: container.Resources{
        Memory:   64 * 1024 * 1024, // 64 MB
        NanoCPUs: 1000000000,       // 1 CPU
    },
}
```
## 9. Следите за версией API
Новые методы появляются в новых версиях, проверяйте совместимость.

## 10. Безопасность
Не передавайте `DOCKER_HOST` без TLS на продакшене. Используйте аутентификацию реестра через `configfile`.