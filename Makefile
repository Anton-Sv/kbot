APP=$(shell basename $(shell git remote get-url origin) .git)
REGISTRY=europe-west1-docker.pkg.dev/k8s-k3s-406521/k8s-repo
TARGETOS=linux
TARGETARCH=amd64
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)

build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/anton-sv/kbot/cmd.appVersion=${VERSION}

clean:
	rm -rf kbot

format:
	gofmt -s -w ./

get:
	go get

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}

lint:
	golangci-lint run

arm:
	$(MAKE) TARGETOS=darwin TARGETARCH=arm64 build image

linux:
	$(MAKE) TARGETOS=linux TARGETARCH=amd64 build image

macos:
	$(MAKE) TARGETOS=darwin TARGETARCH=amd64 build image

windows:
	$(MAKE) TARGETOS=windows TARGETARCH=amd64 build image

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}

push-arm:
	$(MAKE) TARGETOS=darwin TARGETARCH=arm64 push

push-linux:
	$(MAKE) TARGETOS=linux TARGETARCH=amd64 push

push-macos:
	$(MAKE) TARGETOS=darwin TARGETARCH=amd64 push

push-windows:
	$(MAKE) TARGETOS=windows TARGETARCH=amd64 push

test:
	go test -v

