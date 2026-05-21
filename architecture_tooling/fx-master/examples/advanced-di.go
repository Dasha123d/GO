package main

import (
	"fmt"
	"log"

	"go.uber.org/fx"
)

// Handler — интерфейс для обработчиков маршрутов
type Handler interface {
	Path() string
}

// UserHandler
type UserHandler struct{}

func (h *UserHandler) Path() string { return "/users" }

// PostHandler
type PostHandler struct{}

func (h *PostHandler) Path() string { return "/posts" }

// Router собирает все обработчики
type Router struct {
	Handlers []Handler
}

// === ГРУППИРОВКА ЗАВИСИМОСТЕЙ ===

// HandlersModule — модуль, предоставляющий группу хендлеров
var HandlersModule = fx.Module("handlers",
	// fx.Annotate позволяет указать, что результат конструктора
	// должен попасть в группу "handlers"
	fx.Provide(
		fx.Annotate(
			NewUserHandler,
			fx.As(new(Handler)),               // Приводим к интерфейсу
			fx.ResultTags(`group:"handlers"`), // Тег группы
		),
		fx.Annotate(
			NewPostHandler,
			fx.As(new(Handler)),
			fx.ResultTags(`group:"handlers"`),
		),
	),
)

func NewUserHandler() *UserHandler { return &UserHandler{} }
func NewPostHandler() *PostHandler { return &PostHandler{} }

// === СБОРКА ГРУППЫ ===

// NewRouter принимает срез всех хендлеров из группы
// Fx автоматически соберет все элементы группы в срез
func NewRouter(handlers []Handler) *Router {
	log.Printf("📦 Collected %d handlers", len(handlers))
	return &Router{Handlers: handlers}
}

func main() {
	app := fx.New(
		HandlersModule, // Подключаем модуль с хендлерами
		fx.Provide(NewRouter),
		fx.Invoke(func(r *Router) {
			fmt.Println("🌐 Registered routes:")
			for _, h := range r.Handlers {
				fmt.Printf("  - %s\n", h.Path())
			}
		}),
	)
	app.Run()
}
