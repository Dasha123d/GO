# Пример: унарный gRPC-сервер

Файл: `simple-server.go`

## Назначение
Реализует сервер со службой `Greeter`, возвращающий приветствие. Используется прото-файл `simple.proto`.

## Зависимости
- `google.golang.org/grpc`
- `google.golang.org/protobuf`

Сгенерируйте код:
```bash
protoc --go_out=. --go-grpc_out=. simple.proto
```

## Запуск
```bash
go run simple-server.go
```
Сервер слушает порт `:50051`. Проверить можно с помощью `grpcurl` или клиента `simple-client.go`.
