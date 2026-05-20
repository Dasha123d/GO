// bootstrap.go – типичный main() с начальной загрузкой
package main

import (
	"context"
	"database/sql"
	"log"
	"log/slog"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	_ "github.com/lib/pq"
)

type Config struct {
	DSN  string
	Addr string
}

func loadConfig() Config {
	// в реальности через Viper или envconfig
	return Config{
		DSN:  "postgres://user:pass@localhost/testdb?sslmode=disable",
		Addr: ":8080",
	}
}

func initLogger() *slog.Logger {
	return slog.New(slog.NewTextHandler(os.Stderr, &slog.HandlerOptions{Level: slog.LevelInfo}))
}

func initDB(dsn string) (*sql.DB, func(), error) {
	db, err := sql.Open("postgres", dsn)
	if err != nil {
		return nil, nil, err
	}
	if err = db.Ping(); err != nil {
		return nil, nil, err
	}
	cleanup := func() { db.Close() }
	return db, cleanup, nil
}

func main() {
	cfg := loadConfig()
	logger := initLogger()
	logger.Info("starting application", "addr", cfg.Addr)

	db, dbCleanup, err := initDB(cfg.DSN)
	if err != nil {
		logger.Error("database initialization failed", "error", err)
		os.Exit(1)
	}
	defer dbCleanup()

	// Простой HTTP-обработчик, использующий БД
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		var version string
		db.QueryRow("SELECT version()").Scan(&version)
		w.Write([]byte("Postgres version: " + version))
	})

	srv := &http.Server{Addr: cfg.Addr}
	go func() {
		if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			logger.Error("server error", "error", err)
		}
	}()

	quit := make(chan os.Signal, 1)
	signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
	<-quit
	logger.Info("shutting down...")
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	if err := srv.Shutdown(ctx); err != nil {
		log.Fatalf("shutdown error: %v", err)
	}
	logger.Info("server stopped")
}