# Схема провайдера и Data Sources

## Конфигурация провайдера

```go
return &schema.Provider{
    Schema: map[string]*schema.Schema{
        "endpoint": {
            Type:     schema.TypeString,
            Required: true,
            DefaultFunc: schema.EnvDefaultFunc("EXAMPLE_ENDPOINT", nil),
        },
        "token": {
            Type:      schema.TypeString,
            Sensitive: true,
            Required:  true,
        },
    },
}
```
Провайдер может настраиваться через переменные окружения с помощью `EnvDefaultFunc`.

## Data Source (источник данных)
```go
func dataSourceServer() *schema.Resource {
    return &schema.Resource{
        Read: dataSourceServerRead,
        Schema: map[string]*schema.Schema{
            "name": {
                Type:     schema.TypeString,
                Required: true,
            },
            "status": {
                Type:     schema.TypeString,
                Computed: true,
            },
        },
    }
}

func dataSourceServerRead(d *schema.ResourceData, m interface{}) error {
    name := d.Get("name").(string)
    // Запрос к API
    status := "running"
    d.Set("status", status)
    d.SetId(name)
    return nil
}
```
Регистрация
```go
Provider{
    DataSourcesMap: map[string]*schema.Resource{
        "example_server": dataSourceServer(),
    },
}
```
## Типы полей
* `TypeString`, `TypeInt`, `TypeBool`, `TypeFloat`
* `TypeList`, `TypeSet` (уникальные элементы), `TypeMap`
* `Required` / `Optional` / `Computed`
* `ForceNew` (при изменении — пересоздание)
* `Sensitive` (маскируется в выводе)
* `ValidateFunc` — для кастомной валидации