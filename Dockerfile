FROM golang:1.16.5-alpine3.12 as builder
RUN apk add --no-cache \
    xz-dev \
    musl-dev \
    gcc
RUN mkdir -p /go/src/github.com/mendersoftware/azure-iot-manager
COPY . /go/src/github.com/mendersoftware/azure-iot-manager
RUN cd /go/src/github.com/mendersoftware/azure-iot-manager && env CGO_ENABLED=1 go build

FROM alpine:3.14.3
RUN apk add --no-cache ca-certificates xz
RUN mkdir -p /etc/azure-iot-manager
COPY ./config.yaml /etc/azure-iot-manager
COPY --from=builder /go/src/github.com/mendersoftware/azure-iot-manager/azure-iot-manager /usr/bin
ENTRYPOINT ["/usr/bin/azure-iot-manager"]

EXPOSE 8080
