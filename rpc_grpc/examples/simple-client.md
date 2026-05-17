# Пример: унарный gRPC-клиент

Файл: `simple-client.go`

## Назначение
Подключается к серверу `Greeter` и вызывает `SayHello`. Требуется сгенерированный код из `simple.proto`.

## Запуск
```bash
go run simple-client.go
```
Выведет: Response: `Hello World`

## Примечание
Перед запуском убедитесь, что сервер (`simple-server.go`) запущен.