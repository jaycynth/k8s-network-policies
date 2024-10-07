package model

import (
	"github.com/k8s-network-policies/pkg/user"
	"gorm.io/gorm"
)

type User struct {
	ID    uint   `gorm:"primaryKey"`
	Name  string `json:"name"`
	Email string `json:"email"`
}

func (User) TableName() string {
	return "users"
}

func Migrate(db *gorm.DB) error {
	return db.AutoMigrate(&User{})
}

func UserToProtoUser(u User) *user.User {
	return &user.User{
		Id:    uint32(u.ID),
		Name:  u.Name,
		Email: u.Email,
	}
}
