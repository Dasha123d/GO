// bidi-streaming-client.go
package main

import (
	"context"
	"log"
	"time"

	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
	pb "rpc_grpc/examples/bidistream"
)

func main() {
	conn, _ := grpc.Dial("localhost:50054", grpc.WithTransportCredentials(insecure.NewCredentials()))
	defer conn.Close()
	client := pb.NewChatClient(conn)

	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	stream, err := client.Chat(ctx)
	if err != nil {
		log.Fatal(err)
	}

	// горутина для получения сообщений
	go func() {
		for {
			msg, err := stream.Recv()
			if err != nil {
				return
			}
			log.Printf("[%s]: %s", msg.User, msg.Text)
		}
	}()

	// отправка сообщений
	messages := []*pb.ChatMessage{
		{User: "Alice", Text: "Hello"},
		{User: "Alice", Text: "How are you?"},
	}
	for _, m := range messages {
		if err := stream.Send(m); err != nil {
			log.Fatal(err)
		}
		time.Sleep(time.Second)
	}
	stream.CloseSend()

	// ждём немного, чтобы получить эхо
	time.Sleep(2 * time.Second)
}