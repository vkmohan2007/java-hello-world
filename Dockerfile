# syntax=docker/dockerfile:1

# ==============================
# Stage 1: Build
# ==============================
FROM maven:3.9.11-eclipse-temurin-21 AS builder

WORKDIR /app

# Copy Maven configuration first
COPY pom.xml .

# Cache Maven dependencies
RUN --mount=type=cache,target=/root/.m2 \
    mvn dependency:go-offline -B

# Copy source code
COPY src ./src

# Build WAR
RUN --mount=type=cache,target=/root/.m2 \
    mvn clean package -DskipTests -B


# ==============================
# Stage 2: Runtime
# ==============================
FROM tomcat:9.0-jdk21-temurin

# Remove default Tomcat applications
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR file
COPY --from=builder \
    /app/target/hello-world-war.war \
    /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
