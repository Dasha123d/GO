// config-validation.go – валидация конфигурации после загрузки
package main

import (
	"errors"
	"fmt"
	"os"
)

type Config struct {
	Port    int
	DBHost  string
	Workers int
}

func validate(cfg Config) error {
	if cfg.Port <= 0 || cfg.Port > 65535 {
		return fmt.Errorf("некорректный порт: %d", cfg.Port)
	}
	if cfg.DBHost == "" {
		return errors.New("DBHost не может быть пустым")
	}
	if cfg.Workers < 1 {
		return fmt.Errorf("workers должен быть >= 1, получено %d", cfg.Workers)
	}
	return nil
}

func main() {
	// Предположим, конфигурация загружена из любого источника
	cfg := Config{
		Port:    8080,
		DBHost:  "localhost",
		Workers: 0, // ошибка
	}

	if err := validate(cfg); err != nil {
		fmt.Fprintf(os.Stderr, "Ошибка валидации конфигурации: %v\n", err)
		os.Exit(1)
	}
	fmt.Println("Конфигурация корректна")
}