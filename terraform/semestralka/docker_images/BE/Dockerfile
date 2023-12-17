# Multi-stage build docker file

# app build stage
FROM docker.io/golang:alpine as builder
RUN mkdir /build 
ADD . /build/
WORKDIR /build 
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags '-extldflags "-static"' -o main .

# image build image - use scratch to get smallest possible size of an image
FROM scratch
COPY --from=builder /build/main /app/
WORKDIR /app
CMD ["./main"]
