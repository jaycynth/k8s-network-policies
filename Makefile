PROJECT_NAME := k8s-network-policies
PROJECT_ROOT := ./ 
PKG := github.com/jaycynth/$(PROJECT_NAME)
API_IN_PATH := proto
API_OUT_PATH := pkg

setup_dev:
	@cd deployments/compose &&\
	docker-compose up -d

teardown_dev:
	@cd deployments/compose &&\
	docker-compose down


protoc_user:
	@protoc -I=$(API_IN_PATH) --go_out=$(API_OUT_PATH)/user --go_opt=paths=source_relative --go_opt=paths=source_relative --go-grpc_out=$(API_OUT_PATH)/user --go-grpc_opt=paths=source_relative user.proto
	@protoc -I=$(API_IN_PATH)  --grpc-gateway_out=logtostderr=true,paths=source_relative:$(API_OUT_PATH)/user  user.proto
	

protoc_all: protoc_user
