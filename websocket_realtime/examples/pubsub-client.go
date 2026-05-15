// pubsub-client.go
// Клиент, подписывающийся на канал через WebSocket (сервер должен поддерживать pub/sub).
// Для примера используется публичный сервер echo (wss://echo.websocket.org), но подписки эмулируются.
// В реальности замените URL на свой сервер с поддержкой подписок.
package main

import (
	"context"
	"fmt"
	"log"
	"time"

	"nhooyr.io/websocket"
	"nhooyr.io/websocket/wsjson"
)

func main() {
	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()

	url := "wss://echo.websocket.org" // Замените на свой URL
	conn, _, err := websocket.Dial(ctx, url, nil)
	if err != nil {
		log.Fatal("dial error:", err)
	}
	defer conn.Close(websocket.StatusNormalClosure, "client closing")

	// Отправляем сообщение подписки (структура зависит от сервера)
	subscribeMsg := map[string]string{"action": "subscribe", "channel": "news"}
	err = wsjson.Write(ctx, conn, subscribeMsg)
	if err != nil {
		log.Fatal("subscribe write error:", err)
	}

	// Читаем подтверждение и последующие сообщения
	for {
		var msg map[string]interface{}
		err = wsjson.Read(ctx, conn, &msg)
		if err != nil {
			log.Println("read error or timeout:", err)
			break
		}
		fmt.Printf("received: %v\n", msg)
		// В реальном клиенте здесь обработка сообщений канала
	}
}