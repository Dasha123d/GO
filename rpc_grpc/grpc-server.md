# Реализация gRPC-сервера

После генерации кода мы должны реализовать интерфейс сервера.

## Реализация сервиса

```go
type greeterServer struct {
    pb.UnimplementedGreeterServer
}

func (s *greeterServer) SayHello(ctx context.Context, req *pb.HelloRequest) (*pb.HelloReply, error) {
    return &pb.HelloReply{Message: "Hello " + req.Name}, nil
}
```

## Запуск сервера

```go
lis, _ := net.Listen("tcp", ":50051")
s := grpc.NewServer()
pb.RegisterGreeterServer(s, &greeterServer{})
s.Serve(lis)
```

## Middleware (интерсепторы)
```go
func loggingInterceptor(ctx context.Context, req interface{}, info *grpc.UnaryServerInfo, handler grpc.UnaryHandler) (interface{}, error) {
    log.Printf("Method: %s", info.FullMethod)
    return handler(ctx, req)
}

s := grpc.NewServer(grpc.UnaryInterceptor(loggingInterceptor))
```

## Рефлексия
Для отладки через grpcurl включите рефлексию:
```go
import "google.golang.org/grpc/reflection"
reflection.Register(s)
```

## Graceful shutdown
```go
s.GracefulStop() // дождётся завершения текущих запросов
```
Примеры: `examples/simple-server.go`.