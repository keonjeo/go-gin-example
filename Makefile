.PHONY: build clean tool lint help fmt run air test dep build docker_build docker_run docker_log
# NAME = $(notdir $(shell pwd))

all: run

tool:
	go vet ./...; true
	gofmt -w .
lint:
	@echo "checking..."
	golint ./...
clean:
	@echo "cleaning..."
	rm -rf go-gin-example
	go clean -i .
fmt:
	@echo "formatting..."
	@gofmt -w ./../go-gin-example
air:
	@echo "running by ..."
	make fmt && source ./env_local.sh && air
run:
	@echo "running..."
	make fmt && source ./env_local.sh && go run *.go
dep:
	@echo "downloading dependence..."
	make fmt && go get -v -x && go mod download && go mod tidy
build:
	@echo "building..."
	@make fmt && GOOS=linux CGO_ENABLED=0 GOARCH=amd64 go build -v .
test:
	go test -count=1

# docker section
docker_build:
	docker build -t go_gin_example . --network=host
docker_run:
	docker run -d -p 8080:8080 --name go_gin_example_srv go_gin_example:latest
docker_log:
	docker logs -f go_gin_example_srv

help:
	@echo
	@echo "帮助文档："
	@echo "  - make help              查看可用脚本"
	@echo "  - make buildenv          编译基础镜像"
	@echo "  - make fastnginx         编译 nginx 镜像       （支持 fastdfs）"
	@echo "  - make dep               安装第三方依赖"
	@echo "  - make protos            编译协议文件"
	@echo "  - make pull              拉取所有镜像          （镜像 tag 为 latest）"
	@echo "  - make pull/*            拉取特定的一个镜像    （镜像 tag 为 latest）"
	@echo "  - make service           编译所有服务镜像      （镜像 tag 为 latest）"
	@echo "  - make service/*         编译特定的一个服务镜像（镜像 tag 为 latest）"
	@echo "  - make release           发布所有服务镜像      （以 git 最新 commit hash 作为镜像 tag）"
	@echo "  - make release/*         发布特定的一个服务镜像（以 git 最新 commit hash 作为镜像 tag）"
	@echo "  - make job               编译所有定时任务      （镜像 tag 为 latest）"
	@echo "  - make job/*             编译特定的一个定时任务 （镜像 tag 为 latest）"
	@echo "  - make release_job       发布所有定时任务      （以 git 最新 commit hash 作为镜像 tag）"
	@echo "  - make release_job/*     发布特定的一个定时任务 （以 git 最新 commit hash 作为镜像 tag）"
	@echo