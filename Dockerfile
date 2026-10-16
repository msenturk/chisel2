# Build chisel from source
FROM golang:1.23-alpine AS build
RUN go install github.com/jpillora/chisel@latest

# Small runtime image
FROM alpine:3.20
RUN apk add --no-cache ca-certificates
COPY --from=build /go/bin/chisel /usr/local/bin/chisel

# Render injects PORT (default 10000)
ENV PORT=10000
EXPOSE 10000

# Shell form so $PORT and $AUTH get expanded
CMD chisel server --host 0.0.0.0 --port $PORT --auth "$AUTH" --keepalive 25s
