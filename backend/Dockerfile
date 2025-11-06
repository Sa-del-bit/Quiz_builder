# Use OpenJDK as the base image
FROM openjdk:latest

# Set the working directory
WORKDIR /app

# Copy the Maven wrapper and pom.xml
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

# Copy the source code
COPY src src

# Build the application
RUN ./mvnw clean package -DskipTests

# Expose port 9096
EXPOSE 9096

# Run the application
ENTRYPOINT ["java", "-jar", "target/quiz-builder-backend-0.0.1-SNAPSHOT.jar"]