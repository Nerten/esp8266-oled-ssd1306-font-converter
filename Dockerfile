FROM maven:3.9-eclipse-temurin-17-alpine AS build
COPY . /usr/src/app/
RUN --mount=type=cache,target=/root/.m2 --mount=type=cache,target=/root/.npm mvn -f /usr/src/app/pom.xml clean package

FROM openjdk:17-jdk-alpine
RUN apk add --no-cache fontconfig ttf-dejavu
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring
COPY --from=build /usr/src/app/target/*.jar app.jar
ENTRYPOINT ["java","-jar","/app.jar"]