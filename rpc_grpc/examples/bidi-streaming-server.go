// bidi-streaming-server.go
package main

import (
	"io"
	"log"
	"net"

	"google.golang.org/grpc"
	pb "rpc_grpc/examples/bidistream"
)

type server struct {
	pb.UnimplementedChatServer
}

func (s *server) Chat(stream pb.Chat_ChatServer) error {
	for {
		msg, err := stream.Recv()
		if err == io.EOF {
			return nil
		}
		if err != nil {
			return err
		}
		log.Printf("%s: %s", msg.User, msg.Text)
		// Эхо всем подключённым (в реальном чате – рассылка)
		if err := stream.Send(&pb.ChatMessage{User: "Server", Text: "echo: " + msg.Text}); err != nil {
			return err
		}
	}
}

func main() {
	lis, _ := net.Listen("tcp", ":50054")
	s := grpc.NewServer()
	pb.RegisterChatServer(s, &server{})
	log.Println("Bidi streaming chat server on :50054")
	log.Fatal(s.Serve(lis))
}