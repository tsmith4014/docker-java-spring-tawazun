version: "3"

services:
  db:
    image: "mysql"
    container_name: tawazun-db
    ports:
      - "3306:3306"
    environment:
      - MYSQL_DATABASE=tawazun-db
      - MYSQL_ROOT_PASSWORD=DevOps
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
      timeout: 20s
      retries: 10

  app:
    container_name: tawazun-app
    build: .
    ports:
      - "8080:8080"
    environment:
      - DB_URL=db
      - DB_PORT=3306
      - DB_NAME=tawazun-db
      - DB_USERNAME=root
      - DB_PASSWORD=DevOps
    depends_on:
      db:
        condition: service_healthy

