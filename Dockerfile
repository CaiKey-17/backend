# -------------------------------------------------------
# 1) Build stage
# -------------------------------------------------------
FROM maven:3.8.5-openjdk-17-slim AS build

WORKDIR /app
COPY . .

RUN mvn clean package -DskipTests


# -------------------------------------------------------
# 2) Runtime stage
# -------------------------------------------------------
FROM openjdk:17-jdk-slim

WORKDIR /app
COPY --from=build /app/target/*.jar backend.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "backend.jar"]
