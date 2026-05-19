# Пример: загрузка YAML-конфига через Viper

Файл: `viper-yaml.go`

## Назначение
Показывает, как загрузить конфигурационный файл `config.yaml` в структуру с помощью `spf13/viper`.

## Зависимости
- `github.com/spf13/viper`

Установите: `go get github.com/spf13/viper`

## Подготовка
Создайте рядом с программой файл `config.yaml`:
```yaml
server:
  port: 8080
database:
  host: localhost
  port: 5432
  user: admin
```
## Запуск
```bash
go run viper-yaml.go
```
Вывод: значения из файла.