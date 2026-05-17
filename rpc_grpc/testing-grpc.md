# Тестирование gRPC-сервисов

## Юнит-тесты с bufconn

`bufconn` позволяет создать in-memory gRPC соединение без сети.

```go
import "google.golang.org/grpc/test/bufconn"

const bufSize = 1024 * 1024
var lis *bufconn.Listener

func init() {
    lis = bufconn.Listen(bufSize)
    s := grpc.NewServer()
    pb.RegisterGreeterServer(s, &server{})
    go s.Serve(lis)
}

func bufDialer(context.Context, string) (net.Conn, error) {
    return lis.Dial()
}

func TestSayHello(t *testing.T) {
    ctx := context.Background()
    conn, err := grpc.DialContext(ctx, "bufnet", grpc.WithContextDialer(bufDialer), grpc.WithInsecure())
    // ...
}
```

## Мокирование через интерфейсы
Сгенерированный клиентский интерфейс можно замокать с помощью gomock или вручную, если тестируете код, использующий клиент.

## Интеграционные тесты
Можно поднимать реальный сервер на случайном порту `(net.Listen("tcp", "localhost:0"))`.

## Тестирование стримов
Используйте каналы и горутины, проверяйте отправленные и полученные сообщения.

## Примеры
В `examples/` даны только готовые серверы и клиенты; для тестов следует применять bufconn.