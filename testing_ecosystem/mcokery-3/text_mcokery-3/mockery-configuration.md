# Конфигурация mockery через .mockery.yaml

## Файл конфигурации

Создайте `.mockery.yaml` в корне проекта:

```yaml
all: false
recursive: true
output: ./internal/mocks
outpkg: mocks
case: underscore
with-expecter: true
testonly: false
keeptree: true
packages:
  github.com/myorg/myproject/service:
    config:
      dir: ./internal/mocks/service
      outpkg: mocks
    interfaces:
      UserRepository:
        config:
          with-expecter: true
      OrderService:
```
## Ключевые параметры
* all – генерировать моки для всех интерфейсов во всех пакетах.
* recursive – рекурсивно обходить поддиректории.
* output / outpkg – куда класть сгенерированные файлы и имя пакета.
* case – стиль имени файла: `underscore` или `camel`.
* with-expecter – добавляет методы-ассерты (рекомендуется).
* testonly – если `true`, добавляет `//go:build test` (файлы не попадут в production-сборку).
* keeptree – сохранять иерархию исходных пакетов в выходной директории.
* packages – детальная настройка для конкретных пакетов и интерфейсов.

## Запуск с конфигом
Просто `mockery` (без аргументов) — подхватит `.mockery.yaml`. Можно переопределить флагами:
```bash
mockery --all --output ./gen/mocks
```
## Пример: генерация только нужных интерфейсов
```yaml
packages:
  github.com/myorg/myapp/repo:
    interfaces:
      UserRepo:
      OrderRepo:
```
Будут сгенерированы моки только для `UserRepo` и `OrderRepo`.