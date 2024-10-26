package server

import (
	"context"
	"fmt"

	"github.com/k8s-network-policies/model"
	"github.com/k8s-network-policies/pkg/user"
	"gorm.io/gorm"
)

type UserServiceServer struct {
	DB *gorm.DB
	user.UnimplementedUserServiceServer
}

func NewServer(db *gorm.DB) *UserServiceServer {
	return &UserServiceServer{DB: db}
}

func (s *UserServiceServer) GetUserById(ctx context.Context, req *user.UserRequest) (*user.UserResponse, error) {
	var userDB model.User
	if err := s.DB.First(&userDB, req.Id).Error; err != nil {
		return nil, fmt.Errorf("user not found")
	}

	protoUser := model.UserToProtoUser(userDB)

	return &user.UserResponse{
		User: protoUser,
	}, nil
}

func (s *UserServiceServer) CreateUser(ctx context.Context, req *user.CreateUserRequest) (*user.CreateUserResponse, error) {
	userDB := model.User{
		Name:  req.Name,
		Email: req.Email,
	}

	if err := s.DB.Create(&userDB).Error; err != nil {
		return nil, fmt.Errorf("failed to create user: %v", err)
	}

	return &user.CreateUserResponse{
		Id:      uint32(userDB.ID),
		Message: "User created successfully",
	}, nil
}
