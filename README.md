# CP-Tawazun Project

## Introduction

CP-Tawazun is a Java Spring Boot application that is containerized using Docker. This guide details the process of setting up and deploying the application with a MySQL database, emphasizing the use of Docker and Docker Compose.

## Prerequisites

- Docker
- Docker Compose
- Git (for cloning the repository)

## Application Overview

This project utilizes Docker to deploy a Java Spring Boot application, connecting to a MySQL database. The connection settings are managed through environment variables which are defined in the Docker configuration files.

## Setting Up the Project

### Cloning the Repository

1. Clone the Java Spring Boot application repository using Git:
   ```
   git clone https://github.com/chandradeoarya/cp-tawazun.git
   ```
2. Navigate to the project directory:
   ```
   cd cp-tawazun
   ```

### Integrating Docker

Place the `Dockerfile` and `docker-compose.yml` files into the root of the Java Spring Boot application directory.

### Dockerfile

The Dockerfile is used to build the application's Docker image:

```dockerfile
FROM maven:3.8.6-openjdk-11

ENV DB_URL=localhost
ENV DB_PORT=3306
ENV DB_NAME=tawazun-db
ENV DB_USERNAME=root
ENV DB_PASSWORD=DevOps

WORKDIR /app

COPY . .

RUN mvn package

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "target/tawazun.jar"]
```

### Application Properties

The `application.properties` file in `src/main/resources` is configured to use the environment variables defined in the Docker setup:

```properties
spring.mvc.view.prefix=/WEB-INF/
spring.datasource.url=jdbc:mysql://${DB_URL}:${DB_PORT}/${DB_NAME}
spring.datasource.username=${DB_USERNAME}
spring.datasource.password=${DB_PASSWORD}
spring.jpa.hibernate.ddl-auto=create
spring.mvc.hiddenmethod.filter.enabled=true
logging.level.org.hibernate.SQL=DEBUG
logging.level.org.springframework=DEBUG
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQL8Dialect
```

### Docker Compose (docker-compose.yml)

The `docker-compose.yml` file orchestrates the application and database services:

```yaml
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
```

### Running the Application

1. Ensure you are in the root directory of the Java Spring Boot application.
2. Run `docker-compose up` to build and start the containers.

This README provides a detailed guide for setting up and running the CP-Tawazun project with Docker, focusing on the Docker and Docker Compose configurations. Adjust or expand as necessary for your project specifics.
