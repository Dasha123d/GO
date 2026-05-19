# Переменные окружения и .env

12-факторное приложение рекомендует хранить настройки в переменных окружения. Go предоставляет `os.Getenv`, но удобнее использовать библиотеки.

## envconfig

`github.com/kelseyhightower/envconfig` автоматически маппит переменные окружения в структуру по тегам.

```go
type Config struct {
    Port    int    `envconfig:"PORT" default:"8080"`
    DBHost  string `envconfig:"DB_HOST" required:"true"`
}
var cfg Config
envconfig.Process("", &cfg)
```
## godotenv
Для локальной разработки используют `.env`-файлы. Библиотека `github.com/joho/godotenv` загружает их в окружение.

```go
import "github.com/joho/godotenv"
godotenv.Load() // загружает .env в корне проекта
```
Затем значения доступны через `os.Getenv` или `envconfig`.

## Viper + env
Viper умеет автоматически связывать переменные окружения:
```go
viper.AutomaticEnv()
viper.BindEnv("port", "APP_PORT")
```
Это позволяет комбинировать файлы и env с приоритетом.

## Практический пример
См. `examples/envconfig.go`, где показано заполнение структуры из окружения.

## Security note
Не комитьте `.env`-файлы с секретами в репозиторий, добавьте в `.gitignore`.
