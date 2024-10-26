package main

import (
	"log"
	"net"

	"github.com/k8s-network-policies/model"
	"github.com/k8s-network-policies/pkg/user"
	"github.com/k8s-network-policies/server"
	"google.golang.org/grpc"
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
)

func main() {
	// Connect to MySQL
	dsn := "user:password@tcp(mysql-service:3306)/testdb?charset=utf8mb4&parseTime=True&loc=Local"
	db, err := gorm.Open(mysql.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatalf("failed to connect database: %v", err)
	}

	// Auto migrate the database schema
	if err := model.Migrate(db); err != nil {
		log.Fatalf("failed to migrate database: %v", err)
	}

	// Set up gRPC server
	lis, err := net.Listen("tcp", ":50051")
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}

	grpcServer := grpc.NewServer()

	userService := server.NewServer(db)

	user.RegisterUserServiceServer(grpcServer, userService)

	log.Println("gRPC server is running on port 50051...")
	if err := grpcServer.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
