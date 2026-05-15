// reconnection.go
// Клиент, автоматически переподключающийся к WebSocket-серверу при обрыве.
package main

import (
	"context"
	"log"
	"time"

	"nhooyr.io/websocket"
)

func main() {
	url := "ws://localhost:8080/ws" // замените на ваш сервер
	ctx := context.Background()

	initialBackoff := 1 * time.Second
	maxBackoff := 30 * time.Second
	backoff := initialBackoff

	for {
		conn, _, err := websocket.Dial(ctx, url, nil)
		if err != nil {
			log.Printf("dial error: %v; retrying in %v", err, backoff)
			time.Sleep(backoff)
			backoff *= 2
			if backoff > maxBackoff {
				backoff = maxBackoff
			}
			continue
		}
		log.Println("connected")
		backoff = initialBackoff // сброс при успешном подключении

		// цикл чтения
		err = readLoop(ctx, conn)
		log.Printf("disconnected: %v", err)
		conn.Close(websocket.StatusNormalClosure, "reconnecting")
	}
}

func readLoop(ctx context.Context, conn *websocket.Conn) error {
	for {
		_, msg, err := conn.Read(ctx)
		if err != nil {
			return err
		}
		log.Printf("received: %s", msg)
		// можно добавить обработку
	}
}