APP=$(shell basename $(shell git remote get-url origin) .git)
LATEST_IMAGE=$(shell docker images -q | awk '{print $1}' | awk 'NR==1')
REGISTRY=europe-west1-docker.pkg.dev/k8s-k3s-406521/k8s-repo
TARGETARCH=amd64
TARGETOS=linux
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)

build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/anton-sv/kbot/cmd.appVersion=${VERSION}

clean:
	rm -rf kbot
	docker rmi -f ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

format:
	gofmt -s -w ./

get:
	go get

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

lint:
	golangci-lint run

arm: format get
	CGO_ENABLED=0 GOOS=darwin GOARCH=arm64 go build -v -o kbot -ldflags "-X="github.com/anton-sv/kbot/cmd.appVersion=${VERSION}
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-arm64

linux: format get
	CGO_ENABLED=0 GOOS=linux GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/anton-sv/kbot/cmd.appVersion=${VERSION}
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

macos: format get
	CGO_ENABLED=0 GOOS=darwin GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/anton-sv/kbot/cmd.appVersion=${VERSION}
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

windows: format get
	CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -v -o kbot -ldflags "-X="github.com/anton-sv/kbot/cmd.appVersion=${VERSION}
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

test:
	go test -v

