// envconfig.go – загрузка конфигурации из переменных окружения
package main

import (
	"fmt"
	"log"

	"github.com/kelseyhightower/envconfig"
)

type Config struct {
	Port    int    `envconfig:"APP_PORT" default:"8080"`
	DBHost  string `envconfig:"DB_HOST" required:"true"`
	DBUser  string `envconfig:"DB_USER" default:"postgres"`
	DBPass  string `envconfig:"DB_PASS"`
}

func main() {
	var cfg Config
	if err := envconfig.Process("", &cfg); err != nil {
		log.Fatalf("Ошибка загрузки конфигурации из env: %v", err)
	}
	fmt.Printf("Port: %d\n", cfg.Port)
	fmt.Printf("DB Host: %s, User: %s\n", cfg.DBHost, cfg.DBUser)
}