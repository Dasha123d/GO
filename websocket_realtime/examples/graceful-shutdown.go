// graceful-shutdown.go
// Сервер gorilla/websocket, который при получении SIGTERM или SIGINT корректно закрывает все соединения.
package main

import (
	"context"
	"log"
	"net/http"
	"os"
	"os/signal"
	"sync"
	"syscall"
	"time"

	"github.com/gorilla/websocket"
)

var upgrader = websocket.Upgrader{}

type connWrapper struct {
	conn *websocket.Conn
	done chan struct{}
}

var (
	activeConns   = make(map[*connWrapper]struct{})
	activeConnsMu sync.Mutex
)

func wsHandler(w http.ResponseWriter, r *http.Request) {
	conn, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Println("upgrade error:", err)
		return
	}
	cw := &connWrapper{conn: conn, done: make(chan struct{})}
	activeConnsMu.Lock()
	activeConns[cw] = struct{}{}
	activeConnsMu.Unlock()

	go func() {
		defer func() {
			activeConnsMu.Lock()
			delete(activeConns, cw)
			activeConnsMu.Unlock()
			conn.Close()
			close(cw.done)
		}()
		for {
			_, _, err := conn.ReadMessage()
			if err != nil {
				break
			}
			// обработка сообщений
		}
	}()
}

func main() {
	srv := &http.Server{Addr: ":8080"}
	http.HandleFunc("/ws", wsHandler)

	// Запуск сервера
	go func() {
		log.Println("Server started on :8080")
		if err := srv.ListenAndServe(); err != http.ErrServerClosed {
			log.Fatal(err)
		}
	}()

	// Ожидание сигнала
	quit := make(chan os.Signal, 1)
	signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
	<-quit
	log.Println("Shutting down server...")

	// Graceful shutdown HTTP-сервера
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	srv.Shutdown(ctx)

	// Закрытие активных WS-соединений
	activeConnsMu.Lock()
	for cw := range activeConns {
		cw.conn.WriteMessage(websocket.CloseMessage, websocket.FormatCloseMessage(websocket.CloseGoingAway, "server shutdown"))
		cw.conn.Close()
	}
	activeConnsMu.Unlock()

	log.Println("Server exited")
}