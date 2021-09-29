FROM golang:1.16.8-alpine3.14 AS build-env
LABEL intermediate=true

COPY ./ /home/build
WORKDIR /home/build
RUN go build -o /go/bin/runtime main.go

# Final stage
FROM alpine:3.14

RUN apk add --no-cache ca-certificates

ENV PORT=8080
ENV SCW_UPSTREAM_HOST="http://127.0.0.1"
ENV SCW_UPSTREAM_PORT=8081

WORKDIR /home/app
# Import built binary for core runtime
COPY --from=build-env /go/bin /home/app
ENTRYPOINT ["/home/app/runtime"]
