FROM alpine
LABEL maintainer="juliekivuva@gmail.com"
RUN apk --no-cache add ca-certificates
EXPOSE 80 443 8080 9090
WORKDIR /app
COPY service .
ENTRYPOINT [ "/app/service" ]

