FROM golang:1.20 as build

WORKDIR /go/src/practice-4
COPY . .

RUN go mod download
RUN go test ./...

RUN CGO_ENABLED=0 go build -o /go/bin/db ./cmd/db
RUN CGO_ENABLED=0 go build -o /go/bin/server ./cmd/server
RUN CGO_ENABLED=0 go build -o /go/bin/lb ./cmd/lb

FROM alpine:latest
WORKDIR /opt/practice-4

COPY entry.sh .
COPY --from=build /go/bin/db .
COPY --from=build /go/bin/server .
COPY --from=build /go/bin/lb .

RUN chmod +x /opt/practice-4/*

ENTRYPOINT ["/opt/practice-4/entry.sh"]
CMD ["server"]
