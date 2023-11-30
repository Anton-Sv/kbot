APP=$(shell basename $(shell git remote get-url origin) .git)
REGISTRY=toxa2202
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
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

lint:
	golangci-lint run

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

test:
	go test -v

