// client-streaming-client.go
package main

import (
	"context"
	"log"
	"time"

	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
	pb "rpc_grpc/examples/clientstream"
)

func main() {
	conn, _ := grpc.Dial("localhost:50053", grpc.WithTransportCredentials(insecure.NewCredentials()))
	defer conn.Close()
	client := pb.NewAccumulatorClient(conn)

	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	stream, err := client.Accumulate(ctx)
	if err != nil {
		log.Fatal(err)
	}
	for _, n := range []int32{1, 2, 3, 4} {
		if err := stream.Send(&pb.Value{Number: n}); err != nil {
			log.Fatal(err)
		}
	}
	resp, err := stream.CloseAndRecv()
	if err != nil {
		log.Fatal(err)
	}
	log.Printf("Sum: %d", resp.Total)
}