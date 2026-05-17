# Основы gRPC

gRPC строится вокруг трёх сущностей: служб (services), методов и сообщений, описанных в `.proto`-файле.

## Пример proto-файла

```proto
syntax = "proto3";
package hello;

service Greeter {
  rpc SayHello (HelloRequest) returns (HelloReply);
}

message HelloRequest {
  string name = 1;
}

message HelloReply {
  string message = 1;
}
```
* `service` определяет набор RPC-методов.
* Каждый метод принимает одно сообщение и возвращает одно сообщение (унарный вызов).
* Поля сообщений имеют уникальные номера, используемые при сериализации.

## Жизненный цикл вызова
1. Клиент вызывает сгенерированный метод-заглушку.
2. gRPC сериализует запрос в Protobuf и отправляет по HTTP/2.
3. Сервер десериализует, вызывает обработчик, сериализует ответ.
4. Клиент получает ответ.

Благодаря HTTP/2 можно мультиплексировать много запросов в одном TCP-соединении.

## Установка инструментов
```bash
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
```
Также потребуется компилятор protoc (скачать с GitHub).

## Генерация кода
```bash
protoc --go_out=. --go-grpc_out=. hello.proto
```
Будут созданы `hello.pb.go` (сообщения) и `hello_grpc.pb.go` (клиент/сервер).

Теперь можно реализовать сервер и клиент.