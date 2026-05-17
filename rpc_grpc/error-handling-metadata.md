# Обработка ошибок и метаданные

## Статус-коды gRPC

Используйте `google.golang.org/grpc/status` и `google.golang.org/grpc/codes`.

```go
import "google.golang.org/grpc/status"
import "google.golang.org/grpc/codes"

func (s *server) GetUser(ctx context.Context, req *pb.GetUserRequest) (*pb.User, error) {
    if req.Id == "" {
        return nil, status.Error(codes.InvalidArgument, "id must not be empty")
    }
    // ...
}
```

## Rich error details
Можно добавить дополнительные метаданные через `status.WithDetails` и `proto.Message`.

```go
st, _ := status.New(codes.NotFound, "user not found").WithDetails(&pb.ErrorInfo{Reason: "db_error"})
return nil, st.Err()
```
Клиент извлекает:
```go
st := status.Convert(err)
for _, detail := range st.Details() {
    switch t := detail.(type) {
    case *pb.ErrorInfo:
        // обработка
    }
}
```

## Метаданные (headers/trailers)
Аналог HTTP-заголовков, передаваемых в каждом вызове.

### Отправка с сервера
```go
header := metadata.Pairs("key", "value")
grpc.SetHeader(ctx, header)
// или в trailer: grpc.SetTrailer(ctx, metadata.Pairs(...))
```

### Получение клиентом
```go
var header, trailer metadata.MD
resp, err := client.SayHello(ctx, req, grpc.Header(&header), grpc.Trailer(&trailer))
```

### Передача клиентом
```go
md := metadata.Pairs("authorization", "bearer token")
ctx := metadata.NewOutgoingContext(ctx, md)
resp, err := client.SayHello(ctx, req)
```
## Интерсепторы для метаданных
Часто используют для логирования, трассировки, аутентификации.