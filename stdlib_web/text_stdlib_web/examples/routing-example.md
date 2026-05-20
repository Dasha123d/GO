# Пример: Маршрутизация и параметры

Файл: `routing-example.go`

## Назначение
Демонстрирует работу нового `ServeMux` в Go 1.22+: указание HTTP-методов и извлечение параметров пути.

## Запуск
```bash
go run routing-example.go
```
Проверка:
```bash
curl http://localhost:8080/items/5
# Item ID: 5

curl -X POST http://localhost:8080/items
# Item created
```