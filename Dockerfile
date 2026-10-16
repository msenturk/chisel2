FROM golang:1.23-alpine AS build
RUN go install github.com/jpillora/chisel@latest

FROM alpine:3.20
RUN apk add --no-cache ca-certificates
COPY --from=build /go/bin/chisel /usr/local/bin/chisel

ENV PORT=10000
EXPOSE 10000

# --socks5 is what makes `client ... socks` work
CMD chisel server --host 0.0.0.0 --port $PORT --socks5 --reverse --keepalive 25s
