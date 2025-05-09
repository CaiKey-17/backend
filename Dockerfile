# -------------------------------------------------------
# 1) Build stage
# -------------------------------------------------------
FROM maven:3.8.5-openjdk-17-slim AS build

# Create and switch to /app as the working directory
WORKDIR /app

# Copy the 'discoveryserver' folder into /app/discoveryserver
COPY . ./api
WORKDIR /app/api

# Build the Spring Boot jar, skipping tests for speed (remove -DskipTests if desired)
RUN mvn clean package -DskipTests


# -------------------------------------------------------
# 2) Runtime stage
# -------------------------------------------------------
FROM openjdk:17-jdk-slim

# Switch to /app in the runtime image
WORKDIR /app

# Copy the built jar from the first stage
COPY --from=build /app/api/target/*.jar api.jar

# Expose the Eureka port (default 8761)
EXPOSE 8761

# Run the jar
ENTRYPOINT ["java", "-jar", "api.jar"]
