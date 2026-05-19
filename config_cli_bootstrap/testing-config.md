# Тестирование конфигурации и bootstrap

Тесты должны проверять корректность загрузки конфигурации и логику инициализации.

## Тестирование загрузки конфигурации

Помещайте функции загрузки в отдельный пакет и тестируйте их с разными входными данными (файлами, переменными окружения).

```go
func TestLoadConfigFromFile(t *testing.T) {
    tmpFile, _ := ioutil.TempFile("", "config.yaml")
    defer os.Remove(tmpFile.Name())
    ioutil.WriteFile(tmpFile.Name(), []byte(`port: 9090`), 0644)

    cfg, err := LoadConfig(tmpFile.Name())
    assert.NoError(t, err)
    assert.Equal(t, 9090, cfg.Port)
}
```
## Тестирование с env
Можно временно устанавливать переменные окружения в тесте:
```go
os.Setenv("MYAPP_PORT", "8080")
defer os.Unsetenv("MYAPP_PORT")
```
## Интеграционные тесты bootstrap
Запускайте реальный процесс инициализации, подставляя тестовые параметры (например, in-memory SQLite). Проверяйте, что приложение стартует без ошибок.

## Рекомендации
* Валидация конфигурации должна тестироваться отдельно (см. `examples/config-validation.go`).
* Используйте build tags, чтобы не запускать тяжёлые тесты всегда.