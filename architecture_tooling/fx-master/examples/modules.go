package main

import (
	"context"
	"fmt"
	"log"

	"go.uber.org/fx"
	"go.uber.org/fx/fxevent"
	"go.uber.org/fx/fxtest"
)

// === Общие зависимости ===

// AppConfig — глобальная конфигурация
type AppConfig struct {
	AppName string
	Debug   bool
}

// NewAppConfig — конструктор
func NewAppConfig() *AppConfig {
	return &AppConfig{AppName: "fx-demo", Debug: true}
}

// === Модуль: Logger ===

// LoggerModule — модуль логгера
func LoggerModule() fx.Option {
	return fx.Module("logger",
		fx.Provide(func(cfg *AppConfig) *Logger {
			prefix := "[INFO]"
			if cfg.Debug {
				prefix = "[DEBUG]"
			}
			return &Logger{Prefix: prefix}
		}),
	)
}

// Logger — простой логгер
type Logger struct{ Prefix string }

func (l *Logger) Info(msg string) { fmt.Printf("%s %s\n", l.Prefix, msg) }
func (l *Logger) Debug(msg string) {
	if l.Prefix == "[DEBUG]" {
		fmt.Printf("%s %s\n", l.Prefix, msg)
	}
}

// === Модуль: Database (с приватной зависимостью) ===

// dbKey — приватный тип для ключа
type dbKey struct{}

// DatabaseModule — модуль БД
func DatabaseModule() fx.Option {
	return fx.Module("database",
		// Приватная зависимость: ключ подключения
		fx.Provide(
			fx.Annotate(
				func() string { return "secret-db-key" },
				fx.Private,
			),
		),
		// Публичная зависимость: сама БД
		fx.Provide(func(cfg *AppConfig, key string) *Database {
			return &Database{
				Name:  cfg.AppName + "_db",
				Key:   key,
				Debug: cfg.Debug,
			}
		}),
		// Хук инициализации
		fx.Invoke(func(lc fx.Lifecycle, db *Database, log *Logger) {
			lc.Append(fx.Hook{
				OnStart: func(ctx context.Context) error {
					log.Debug(fmt.Sprintf("🔗 Connecting to %s...", db.Name))
					return db.Connect(ctx)
				},
				OnStop: func(ctx context.Context) error {
					log.Debug(fmt.Sprintf("🔌 Disconnecting %s", db.Name))
					return db.Close()
				},
			})
		}),
	)
}

// Database — пример БД
type Database struct {
	Name  string
	Key   string
	Debug bool
}

func (db *Database) Connect(ctx context.Context) error {
	if db.Debug {
		log.Printf("✅ %s connected with key %s", db.Name, db.Key)
	}
	return nil
}

func (db *Database) Close() error {
	log.Printf("✅ %s closed", db.Name)
	return nil
}

// === Модуль: API Server ===

// ServerParams — зависимости сервера
type ServerParams struct {
	fx.In
	Config *AppConfig
	DB     *Database
	Log    *Logger
}

// ServerResult — экспортируемые зависимости сервера
type ServerResult struct {
	fx.Out
	Server *Server
}

// ServerModule — модуль HTTP-сервера
func ServerModule() fx.Option {
	return fx.Module("server",
		fx.Provide(func(p ServerParams) ServerResult {
			return ServerResult{
				Server: &Server{
					Port: 8080,
					DB:   p.DB,
					Log:  p.Log,
				},
			}
		}),
		fx.Invoke(func(lc fx.Lifecycle, srv *Server) {
			lc.Append(fx.Hook{
				OnStart: func(ctx context.Context) error {
					srv.Log.Info(fmt.Sprintf("🌐 Server starting on :%d", srv.Port))
					return srv.Start(ctx)
				},
				OnStop: func(ctx context.Context) error {
					srv.Log.Info("🛑 Server stopping")
					return srv.Stop(ctx)
				},
			})
		}),
	)
}

// Server — HTTP-сервер
type Server struct {
	Port int
	DB   *Database
	Log  *Logger
}

func (s *Server) Start(ctx context.Context) error {
	s.Log.Info("Server started (mock)")
	return nil
}

func (s *Server) Stop(ctx context.Context) error {
	s.Log.Info("Server stopped (mock)")
	return nil
}

// === Root module ===

// AppModule — корневой модуль приложения
func AppModule() fx.Option {
	return fx.Options(
		fx.Provide(NewAppConfig),
		LoggerModule(),
		DatabaseModule(),
		ServerModule(),
		fx.Invoke(func(log *Logger, srv *Server) {
			log.Info(fmt.Sprintf("🚀 %s ready", srv.DB.Name))
		}),
	)
}

// === main ===

func main() {
	// Для продакшена:
	// fx.New(AppModule()).Run()

	// Для демонстрации с тестовым режимом:
	app := fxtest.New(
		nil, // *testing.T — в реальном коде передайте t
		AppModule(),
		fx.WithLogger(func() fxevent.Logger {
			return &fxevent.ConsoleLogger{}
		}),
	)

	// Имитация запуска/остановки
	_ = app.RequireStart()
	fmt.Println("✅ Application started (test mode)")
	_ = app.RequireStop()
	fmt.Println("✅ Application stopped (test mode)")
}
