# Быстрый старт: установка, провайдер и первый ресурс

## Установка

```bash
go get github.com/hashicorp/terraform-plugin-sdk/v2
```
## Базовая структура провайдера
```go
package main

import (
    "github.com/hashicorp/terraform-plugin-sdk/v2/helper/schema"
    "github.com/hashicorp/terraform-plugin-sdk/v2/plugin"
)

func main() {
    plugin.Serve(&plugin.ServeOpts{
        ProviderFunc: func() *schema.Provider {
            return &schema.Provider{
                Schema: map[string]*schema.Schema{
                    "region": {
                        Type:     schema.TypeString,
                        Optional: true,
                        Default:  "us-east-1",
                    },
                },
                ResourcesMap: map[string]*schema.Resource{
                    "example_server": resourceServer(),
                },
            }
        },
    })
}

func resourceServer() *schema.Resource {
    return &schema.Resource{
        Create: resourceServerCreate,
        Read:   resourceServerRead,
        Update: resourceServerUpdate,
        Delete: resourceServerDelete,
        Schema: map[string]*schema.Schema{
            "name": {
                Type:     schema.TypeString,
                Required: true,
                ForceNew: true,
            },
            "size": {
                Type:     schema.TypeInt,
                Optional: true,
                Default:  1,
            },
        },
    }
}

func resourceServerCreate(d *schema.ResourceData, m interface{}) error {
    name := d.Get("name").(string)
    // Вызов API для создания сервера
    d.SetId(name)
    return resourceServerRead(d, m)
}

func resourceServerRead(d *schema.ResourceData, m interface{}) error { return nil }
func resourceServerUpdate(d *schema.ResourceData, m interface{}) error { return nil }
func resourceServerDelete(d *schema.ResourceData, m interface{}) error {
    // Удаление сервера
    d.SetId("")
    return nil
}
```
## Запуск провайдера
Соберите бинарник и поместите в `~/.terraform.d/plugins/`. Затем в конфигурации Terraform:
```hcl
terraform {
  required_providers {
    example = {
      source = "example.com/my/example"
      version = "1.0.0"
    }
  }
}

provider "example" {
  region = "eu-central-1"
}

resource "example_server" "web" {
  name = "web-server"
  size = 2
}
```
После `terraform init && terraform apply` вызовутся CRUD-методы вашего ресурса.