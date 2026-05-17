# Protocol Buffers и генерация кода

Protocol Buffers (protobuf) — язык описания данных и бинарный формат сериализации от Google.

## Синтаксис proto3

- `syntax = "proto3";` — обязательная строка.
- `package mypackage;` — пространство имён.
- `option go_package = "path/to/package";` — путь Go-пакета.
- Поля: `type name = number;`
- Поддерживаются: `double`, `float`, `int32`, `int64`, `uint32`, `uint64`, `bool`, `string`, `bytes`, перечисления, вложенные сообщения.
- `repeated` — массив.
- `map<key, value>` — словарь.
- `oneof` — не более одного поля из группы.

Пример:

```proto
message User {
  string id = 1;
  string name = 2;
  int32 age = 3;
  repeated string emails = 4;
}
```

## Сервисы и методы
```proto
service UserService {
  rpc GetUser (GetUserRequest) returns (User);
  rpc ListUsers (ListUsersRequest) returns (stream User); // server streaming
}
```
## Генерация Go-кода
После `protoc` получаем:
* `*.pb.go` — структуры сообщений, методы сериализации.
* `*_grpc.pb.go` — интерфейсы сервера и клиента, функции регистрации.

## Рекомендации
* Используйте `proto3` для новых проектов.
* Всегда задавайте `go_package`.
* Номера полей 1-15 кодируются эффективнее.
* Не удаляйте поля, помечайте как reserved.