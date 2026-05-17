// client-streaming-server.go
package main

import (
	"io"
	"log"
	"net"

	"google.golang.org/grpc"
	pb "rpc_grpc/examples/clientstream"
)

type server struct {
	pb.UnimplementedAccumulatorServer
}

func (s *server) Accumulate(stream pb.Accumulator_AccumulateServer) error {
	var total int32
	for {
		val, err := stream.Recv()
		if err == io.EOF {
			return stream.SendAndClose(&pb.Sum{Total: total})
		}
		if err != nil {
			return err
		}
		total += val.Number
	}
}

func main() {
	lis, _ := net.Listen("tcp", ":50053")
	s := grpc.NewServer()
	pb.RegisterAccumulatorServer(s, &server{})
	log.Println("Client streaming server on :50053")
	log.Fatal(s.Serve(lis))
}