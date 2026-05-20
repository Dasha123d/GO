# Работа с файлами конфигурации

Файлы конфигурации — основной способ хранения настроек. Go поддерживает JSON, YAML, TOML через стандартную библиотеку `encoding/json` и сторонние пакеты.

## Использование Viper

`viper` — универсальное решение: читает файлы, переменные окружения, флаги, объединяет и отслеживает изменения.

```go
viper.SetConfigName("config")   // имя файла без расширения
viper.SetConfigType("yaml")     // или "json", "toml"
viper.AddConfigPath(".")        // пути поиска
err := viper.ReadInConfig()
```
Можно загрузить конфигурацию напрямую в структуру:
```go
type Config struct {
    Port    int    `mapstructure:"port"`
    DBHost  string `mapstructure:"db_host"`
}
var cfg Config
viper.Unmarshal(&cfg)
```

## Горячая перезагрузка
```go
viper.WatchConfig()
viper.OnConfigChange(func(e fsnotify.Event) {
    viper.Unmarshal(&cfg)
})
```

## Пример YAML-конфигурации
```yaml
server:
  port: 8080
database:
  host: localhost
  port: 5432
  user: admin
```
Смотрите `examples/viper-yaml.go`.

Альтернативы
* `encoding/json` + `os.ReadFile` — для простых нужд.
* `BurntSushi/toml` — если используется TOML.

Рекомендуется Viper как наиболее гибкий вариант.