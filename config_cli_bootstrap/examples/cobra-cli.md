# Пример: CLI с командами на Cobra

Файл: `cobra-cli.go`

## Назначение
Минимальный CLI с использованием `spf13/cobra`: определяются флаги `--port` и `--config`.

## Зависимости
- `github.com/spf13/cobra`

## Запуск
```bash
go run cobra-cli.go --port 9090 -c prod.yaml
```
Вывод:
```text
Запуск с портом 9090 и конфигом prod.yaml
```