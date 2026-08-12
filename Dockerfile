# syntax=docker/dockerfile:1

# ==============================
# Stage 1: Build
# ==============================
FROM maven:3.9.11-eclipse-temurin-21 AS builder

WORKDIR /app

# Copy only dependency files first
# This allows Docker to cache Maven dependencies
COPY pom.xml .

# Cache Maven repository between builds
RUN --mount=type=cache,target=/root/.m2 \
    mvn dependency:go-offline -B

# Copy source code
COPY src ./src

# Build the application
RUN --mount=type=cache,target=/root/.m2 \
    mvn clean package -DskipTests -B


# ==============================
# Stage 2: Runtime
# ==============================
FROM eclipse-temurin:21-jre

WORKDIR /app

# Copy generated JAR from builder
COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
