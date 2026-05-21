package main

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"time"

	"go.uber.org/fx"
	"go.uber.org/fx/fxevent"
)

// Database — пример ресурса с подключением
type Database struct {
	Name string
}

// NewDatabase — конструктор БД
func NewDatabase() *Database {
	log.Println("🔧 Creating database connection")
	return &Database{Name: "app_db"}
}

// Connect — имитация подключения
func (db *Database) Connect(ctx context.Context) error {
	log.Printf("🔗 Connecting to %s...", db.Name)
	select {
	case <-time.After(100 * time.Millisecond):
		log.Println("✅ Connected")
		return nil
	case <-ctx.Done():
		return ctx.Err()
	}
}

// Close — имитация закрытия
func (db *Database) Close() error {
	log.Printf("🔌 Closing connection to %s", db.Name)
	return nil
}

// Server — HTTP-сервер
type Server struct {
	*http.Server
}

// NewServer — конструктор сервера
func NewServer(db *Database) *Server {
	mux := http.NewServeMux()
	mux.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, `{"status":"ok","db":"%s"}`, db.Name)
	})
	return &Server{&http.Server{Addr: ":8080", Handler: mux}}
}

// registerDatabase — регистрация хуков для БД
func registerDatabase(lc fx.Lifecycle, db *Database) {
	lc.Append(fx.Hook{
		OnStart: func(ctx context.Context) error {
			return db.Connect(ctx)
		},
		OnStop: func(ctx context.Context) error {
			return db.Close()
		},
	})
}

// registerServer — регистрация хуков для сервера
func registerServer(lc fx.Lifecycle, srv *Server) {
	lc.Append(fx.Hook{
		OnStart: func(ctx context.Context) error {
			log.Println("🌐 Starting HTTP server on :8080")
			go func() {
				if err := srv.ListenAndServe(); err != http.ErrServerClosed {
					log.Printf("❌ Server error: %v", err)
				}
			}()
			return nil
		},
		OnStop: func(ctx context.Context) error {
			log.Println("🛑 Shutting down HTTP server...")
			return srv.Shutdown(ctx)
		},
	})
}

// healthCheck — инвокер для проверки здоровья
func healthCheck(db *Database) {
	log.Printf("🩺 Health check: DB=%s", db.Name)
}

func main() {
	app := fx.New(
		// Логирование
		fx.WithLogger(func() fxevent.Logger {
			return &fxevent.ConsoleLogger{}
		}),

		// Таймауты
		fx.StartTimeout(30*time.Second),
		fx.StopTimeout(30*time.Second),

		// Предоставление зависимостей
		fx.Provide(
			NewDatabase,
			NewServer,
		),

		// Регистрация хуков жизненного цикла
		fx.Invoke(
			registerDatabase,
			registerServer,
			healthCheck,
		),
	)

	// Запуск приложения
	// Для тестов можно использовать: app := fx.New(...); app.Start(ctx); app.Stop(ctx)
	app.Run()
}
