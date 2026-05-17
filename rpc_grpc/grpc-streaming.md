# Потоковая передача (streaming)

gRPC поддерживает три типа стриминга помимо унарного:

## Server streaming

Сервер отправляет последовательность сообщений, клиент читает поток.

```proto
rpc ListFeatures(Rectangle) returns (stream Feature);
```
Сервер: отправляет через `stream.Send(...)`. Клиент: вызывает `Recv()` до `io.EOF`.

## Client streaming
Клиент отправляет поток, сервер получает и отвечает одним сообщением.
```proto
rpc RecordRoute(stream Point) returns (RouteSummary);
```
Клиент: многократный `Send()`, затем `CloseAndRecv()`. Сервер: читает через `Recv()`.

## Bidirectional streaming
Обе стороны независимо отправляют и читают.
```proto
rpc Chat(stream ChatMessage) returns (stream ChatMessage);
```
Используются две горутины: чтение и запись. Потоки независимы.

## Обработка ошибок в потоках
* Возврат ошибки из обработчика сервера завершит поток.
* Клиент получает ошибку через `RecvMsg` или `CloseAndRecv`.

## Практические рекомендации
* Не забывайте вызывать `stream.Send()` и `stream.Recv()` из безопасных горутин.
* Используйте буферизацию для производительности.
* Устанавливайте дедлайны через контекст.
* Примеры: `server-streaming-*`, `client-streaming-*`, `bidi-streaming-*`.