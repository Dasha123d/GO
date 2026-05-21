package main

import (
	"context"
	"fmt"
	"log"

	"go.uber.org/fx"
	"go.uber.org/fx/fxevent"
)

// Greeter — простая зависимость для демонстрации
type Greeter struct {
	Prefix string
}

// NewGreeter — конструктор, который будет зарегистрирован в контейнере
func NewGreeter() *Greeter {
	return &Greeter{Prefix: "Hello"}
}

// Greet — метод, использующий зависимость
func (g *Greeter) Greet(name string) string {
	return fmt.Sprintf("%s, %s!", g.Prefix, name)
}

// onStart — функция, которая будет вызвана при старте приложения
func onStart(lc fx.Lifecycle, greeter *Greeter) {
	lc.Append(fx.Hook{
		OnStart: func(ctx context.Context) error {
			log.Println("🚀 App starting:", greeter.Greet("Fx"))
			return nil
		},
		OnStop: func(ctx context.Context) error {
			log.Println("🛑 App stopping")
			return nil
		},
	})
}

// main — точка входа в приложение
func main() {
	app := fx.New(
		// Логирование событий для отладки
		fx.WithLogger(func() fxevent.Logger {
			return &fxevent.ConsoleLogger{}
		}),

		// Регистрация конструктора
		fx.Provide(NewGreeter),

		// Регистрация инвокера с использованием зависимости
		fx.Invoke(onStart),

		// Инвокер, который просто использует зависимость
		fx.Invoke(func(g *Greeter) {
			fmt.Println("📦 Dependency resolved:", g.Greet("World"))
		}),
	)

	// Запуск приложения (блокирует выполнение)
	app.Run()
}
