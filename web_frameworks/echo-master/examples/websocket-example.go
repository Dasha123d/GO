package main

import (
	"fmt"
	"net/http"

	"github.com/gorilla/websocket"
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
)

var upgrader = websocket.Upgrader{
	CheckOrigin: func(r *http.Request) bool {
		return true // Разрешаем все источники для примера
	},
}

func main() {
	e := echo.New()
	e.Use(middleware.Logger())
	e.Use(middleware.Recover())

	e.GET("/ws", func(c echo.Context) error {
		// Апгрейд HTTP соединения до WebSocket
		conn, err := upgrader.Upgrade(c.Response(), c.Request(), nil)
		if err != nil {
			return err
		}
		defer conn.Close()

		for {
			// Чтение сообщения
			_, msg, err := conn.ReadMessage()
			if err != nil {
				break
			}
			fmt.Printf("Получено: %s\n", msg)

			// Отправка ответа (Эхо)
			err = conn.WriteMessage(websocket.TextMessage, []byte("Эхо: "+string(msg)))
			if err != nil {
				break
			}
		}
		return nil
	})

	e.Logger.Fatal(e.Start(":8080"))
}
