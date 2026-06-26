# Жизненный цикл ресурса: CRUD, импорт и диффы

## CRUD-функции

```go
func resourceServerCreate(d *schema.ResourceData, m interface{}) error {
    // m — клиент API, полученный из provider configure
    client := m.(*apiClient)
    server, err := client.CreateServer(d.Get("name").(string))
    if err != nil {
        return err
    }
    d.SetId(server.ID)
    return resourceServerRead(d, m)
}

func resourceServerRead(d *schema.ResourceData, m interface{}) error {
    client := m.(*apiClient)
    server, err := client.GetServer(d.Id())
    if err != nil {
        if isNotFound(err) {
            d.SetId("")
            return nil
        }
        return err
    }
    d.Set("name", server.Name)
    d.Set("size", server.Size)
    return nil
}

func resourceServerUpdate(d *schema.ResourceData, m interface{}) error {
    if d.HasChange("size") {
        // обновить размер
    }
    return resourceServerRead(d, m)
}

func resourceServerDelete(d *schema.ResourceData, m interface{}) error {
    client := m.(*apiClient)
    return client.DeleteServer(d.Id())
}
```
## Импорт ресурса
```go
Importer: &schema.ResourceImporter{
    StateContext: schema.ImportStatePassthroughContext,
},
```
Позволяет `terraform import example_server.web server-id`.

## CustomizeDiff
Для сложной логики изменений:
```go
CustomizeDiff: customdiff.All(
    customdiff.ForceNewIfChange("disk_size", func(ctx context.Context, d *schema.ResourceDiff, meta interface{}) bool {
        return d.Get("disk_size").(int) > 100
    }),
),
```
## State Migrations
При изменении схемы ресурса можно писать миграции состояния:
```go
SchemaVersion: 1,
StateUpgraders: []schema.StateUpgrader{
    {
        Type:    resourceServerV0().CoreConfigSchema().ImpliedType(),
        Upgrade: func(ctx context.Context, rawState map[string]interface{}, meta interface{}) (map[string]interface{}, error) {
            rawState["new_field"] = "default"
            return rawState, nil
        },
        Version: 0,
    },
},
```