package main

import (
	"context"
	"fmt"
	"log"

	"go.uber.org/fx"
	"go.uber.org/fx/fxevent"
)

// === Базовые зависимости ===

// Config — конфигурация приложения
type Config struct {
	Env     string
	DBUrl   string
	Port    int
}

// NewConfig — конструктор конфигурации
func NewConfig() *Config {
	return &Config{
		Env:   "development",
		DBUrl: "postgres://localhost/app",
		Port:  8080,
	}
}

// Logger — простой логгер
type Logger struct {
	Prefix string
}

// NewLogger — конструктор логгера
func NewLogger(cfg *Config) *Logger {
	return &Logger{Prefix: fmt.Sprintf("[%s]", cfg.Env)}
}

// Log — метод логирования
func (l *Logger) Log(msg string) {
	fmt.Printf("%s %s\n", l.Prefix, msg)
}

// === Группировка результатов ===

// Handler — интерфейс обработчика
type Handler interface {
	Route() string
	Handle(ctx context.Context) error
}

// UserHandler — пример хендлера
type UserHandler struct{ log *Logger }

func NewUserHandler(log *Logger) *UserHandler {
	return &UserHandler{log: log}
}

func (h *UserHandler) Route() string { return "/users" }
func (h *UserHandler) Handle(ctx context.Context) error {
	h.log.Log("Handling /users")
	return nil
}

// PostHandler — другой хендлер
type PostHandler struct{ log *Logger }

func NewPostHandler(log *Logger) *PostHandler {
	return &PostHandler{log: log}
}

func (h *PostHandler) Route() string { return "/posts" }
func (h *PostHandler) Handle(ctx context.Context) error {
	h.log.Log("Handling /posts")
	return nil
}

// HandlerResult — группировка хендлеров
type HandlerResult struct {
	fx.Out
	Users Handler `group:"server_handlers"`
	Posts Handler `group:"server_handlers"`
}

// NewHandlers — конструктор, возвращающий группу
func NewHandlers(log *Logger) HandlerResult {
	return HandlerResult{
		Users: NewUserHandler(log),
		Posts: NewPostHandler(log),
	}
}

// HandlerParams — сборка группы
type HandlerParams struct {
	fx.In
	Handlers []Handler `group:"server_handlers"`
}

// RegisterHandlers — инвокер, использующий группу
func RegisterHandlers(params HandlerParams, log *Logger) {
	log.Log(fmt.Sprintf("📦 Registered %d handlers", len(params.Handlers)))
	for _, h := range params.Handlers {
		log.Log(fmt.Sprintf("  - %s", h.Route()))
	}
}

// === Именованные зависимости ===

// DBResult — именованные подключения к БД
type DBResult struct {
	fx.Out
	Primary *Config `name:"primary_db"`
	Replica *Config `name:"replica_db"`
}

// NewNamedDBs — конструктор именованных БД
func NewNamedDBs(cfg *Config) DBResult {
	return DBResult{
		Primary: &Config{Env: cfg.Env + "-primary", DBUrl: cfg.DBUrl + "_primary"},
		Replica: &Config{Env: cfg.Env + "-replica", DBUrl: cfg.DBUrl + "_replica"},
	},
}

// UseNamedDBs — инвокер с именованными зависимостями
type NamedDBParams struct {
	fx.In
	Primary *Config `name:"primary_db"`
	Replica *Config `name:"replica_db"`
}

func UseNamedDBs(params NamedDBParams, log *Logger) {
	log.Log("🗄️ Using named databases")
	log.Log(fmt.Sprintf("  Primary: %s", params.Primary.DBUrl))
	log.Log(fmt.Sprintf("  Replica: %s", params.Replica.DBUrl))
}

// === Опциональные зависимости ===

// Metrics — опциональная метрика
type Metrics struct{ enabled bool }

// NewMetrics — может не создаваться
func NewMetrics(cfg *Config) *Metrics {
	if cfg.Env == "production" {
		return &Metrics{enabled: true}
	}
	return nil // Не предоставляем в development
}

// UseMetrics — инвокер с опциональной зависимостью
type MetricsParams struct {
	fx.In
	Metrics *Metrics `optional:"true"`
}

func UseMetrics(params MetricsParams, log *Logger) {
	if params.Metrics != nil && params.Metrics.enabled {
		log.Log("📊 Metrics enabled")
	} else {
		log.Log("📊 Metrics disabled (optional)")
	}
}

// === main ===

func main() {
	app := fx.New(
		// Логирование
		fx.WithLogger(func() fxevent.Logger {
			return &fxevent.ConsoleLogger{}
		}),

		// Базовые зависимости
		fx.Provide(
			NewConfig,
			NewLogger,
		),

		// Группировка хендлеров
		fx.Provide(NewHandlers),
		fx.Invoke(RegisterHandlers),

		// Именованные зависимости
		fx.Provide(NewNamedDBs),
		fx.Invoke(UseNamedDBs),

		// Опциональная зависимость
		fx.Provide(NewMetrics),
		fx.Invoke(UseMetrics),

		// Декоратор: добавляем префикс к логгеру
		fx.Decorate(func(log *Logger) *Logger {
			log.Prefix = log.Prefix + "[decorated]"
			return log
		}),
	)

	app.Run()
}