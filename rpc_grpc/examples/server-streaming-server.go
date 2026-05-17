// server-streaming-server.go
package main

import (
	"log"
	"net"
	"strconv"
	"time"

	"google.golang.org/grpc"
	pb "rpc_grpc/examples/serverstream"
)

type server struct {
	pb.UnimplementedDataStreamServer
}

func (s *server) StreamData(req *pb.DataRequest, stream pb.DataStream_StreamDataServer) error {
	for i := int32(0); i < req.Count; i++ {
		resp := &pb.DataResponse{
			Index:   i,
			Message: "data " + strconv.Itoa(int(i)),
		}
		if err := stream.Send(resp); err != nil {
			return err
		}
		time.Sleep(200 * time.Millisecond) // симуляция работы
	}
	return nil
}

func main() {
	lis, err := net.Listen("tcp", ":50052")
	if err != nil {
		log.Fatal(err)
	}
	s := grpc.NewServer()
	pb.RegisterDataStreamServer(s, &server{})
	log.Println("Server streaming server on :50052")
	log.Fatal(s.Serve(lis))
}