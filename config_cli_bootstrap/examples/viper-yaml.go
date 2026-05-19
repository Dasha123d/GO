// viper-yaml.go – загрузка конфигурации из YAML с помощью Viper
package main

import (
	"fmt"
	"log"

	"github.com/spf13/viper"
)

type Config struct {
	Server struct {
		Port int `mapstructure:"port"`
	} `mapstructure:"server"`
	Database struct {
		Host string `mapstructure:"host"`
		Port int    `mapstructure:"port"`
		User string `mapstructure:"user"`
	} `mapstructure:"database"`
}

func main() {
	viper.SetConfigName("config")
	viper.SetConfigType("yaml")
	viper.AddConfigPath(".")
	if err := viper.ReadInConfig(); err != nil {
		log.Fatalf("Ошибка чтения конфигурации: %v", err)
	}

	var cfg Config
	if err := viper.Unmarshal(&cfg); err != nil {
		log.Fatalf("Ошибка разбора: %v", err)
	}

	fmt.Printf("Порт: %d\n", cfg.Server.Port)
	fmt.Printf("DB: %s:%d, user=%s\n", cfg.Database.Host, cfg.Database.Port, cfg.Database.User)
}