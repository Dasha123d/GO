# Создание моков: mockgen и go:generate

## Способы генерации

### 1. Из исходного файла

```bash
mockgen -source=user.go -destination=mocks/user_mock.go -package=mocks
```

## 2. Из пакета (интерфейсы)
```go
mockgen -package=mocks github.com/me/app/user Repository,Service
```

## 3. Через go:generate
В файле с интерфейсом добавьте:
```go
//go:generate mockgen -source=$GOFILE -destination=../mocks/${GOFILE}_mock.go -package=mocks
```
Затем `go generate ./....`

## Флаги mockgen
* `-source` — исходный файл.
* `-destination` — выходной файл.
* `-package` — имя пакета для сгенерированного кода.
* `-imports` — дополнительные импорты.
* `-aux_files` — дополнительные файлы для сложных зависимостей.
* `-write_package_comment=false` — отключает комментарий о кодогенерации.

## Шаблон имени пакета
Рекомендуется использовать пакет `mocks`, либо класть мок в подпакет `mock_<package>`.

## Обновление моков
Не редактируйте сгенерированный код вручную. При изменении интерфейса перезапустите `go generate`. В CI проверяйте актуальность:
```bash
go generate ./...
git diff --exit-code
```