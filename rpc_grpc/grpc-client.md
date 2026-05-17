# Реализация gRPC-клиента

Клиент использует сгенерированный `NewGreeterClient`.

## Создание подключения

```go
conn, err := grpc.Dial("localhost:50051", grpc.WithInsecure()) // для тестов
// для production используйте grpc.WithTransportCredentials(...)
defer conn.Close()
client := pb.NewGreeterClient(conn)
```

## Вызов унарного метода
```go
ctx, cancel := context.WithTimeout(context.Background(), time.Second)
defer cancel()
resp, err := client.SayHello(ctx, &pb.HelloRequest{Name: "World"})
```

## Интерсепторы
```go
conn, err := grpc.Dial(addr,
    grpc.WithUnaryInterceptor(clientInterceptor),
)
```

## Балансировка нагрузки
С помощью `grpc.WithDefaultServiceConfig` или внешнего resolver'а.

## Аутентификация
Поддерживаются TLS, токены через `grpc.WithPerRPCCredentials`.

## Лучшие практики
* Всегда используйте контекст с таймаутом.
* Управляйте переподключением с помощью `grpc.WithBlock()` или `waitForReady`.
* На production используйте TLS.
* Примеры: `examples/simple-client.go`.