# Тестирование провайдера

## Acceptance Tests

```go
import (
    "testing"
    "github.com/hashicorp/terraform-plugin-sdk/v2/helper/resource"
)

func TestAccServer_basic(t *testing.T) {
    resource.Test(t, resource.TestCase{
        PreCheck:     func() { testAccPreCheck(t) },
        Providers:    testAccProviders,
        Steps: []resource.TestStep{
            {
                Config: testAccServerConfig("web", 1),
                Check: resource.ComposeTestCheckFunc(
                    resource.TestCheckResourceAttr("example_server.test", "name", "web"),
                    resource.TestCheckResourceAttr("example_server.test", "size", "1"),
                ),
            },
            {
                Config: testAccServerConfig("web", 2),
                Check: resource.ComposeTestCheckFunc(
                    resource.TestCheckResourceAttr("example_server.test", "size", "2"),
                ),
            },
        },
    })
}

func testAccServerConfig(name string, size int) string {
    return fmt.Sprintf(`
provider "example" {
  endpoint = "localhost"
}
resource "example_server" "test" {
  name = "%s"
  size = %d
}
`, name, size)
}
```
## Mock-клиент для unit-тестов
```go
func TestResourceServerCreate(t *testing.T) {
    d := schema.TestResourceDataRaw(t, resourceServer().Schema, map[string]interface{}{
        "name": "test-server",
    })
    client := &MockClient{}
    diags := resourceServerCreate(d, client)
    if diags.HasError() {
        t.Fatal(diags[0].Summary)
    }
}
```
Используйте `schema.TestResourceDataRaw` для тестирования CRUD-функций без запуска Terraform.