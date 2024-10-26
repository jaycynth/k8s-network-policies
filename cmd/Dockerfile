FROM alpine:latest
LABEL maintainer="juliekivuva@gmail.com"

RUN apk --no-cache add ca-certificates curl

EXPOSE 80 443 8080 9090

WORKDIR /app

COPY service .

ENTRYPOINT [ "/app/service" ]
