# Step 1: build the frontend UI
FROM node:13-alpine as build_ui

WORKDIR /src

COPY  ./src/ui/package.json ./src/ui/yarn.lock ./

RUN yarn install

COPY ./src/ui .

RUN yarn build

# Step 2: setup cache for gradle build
FROM gradle:5.6.4-jdk8 as cache

RUN mkdir -p /home/gradle/cache_home

ENV GRADLE_USER_HOME /home/gradle/cache_home

WORKDIR /src

COPY build.gradle.kts gradle.properties settings.gradle.kts ./

RUN gradle clean build -i --stacktrace

# Step 3: copy gradle cache and frontend assets then build the final application jar
FROM gradle:5.6.4-jdk8 as build-stage

WORKDIR /src

COPY --from=cache /home/gradle/cache_home /home/gradle/.gradle

COPY . .

COPY --from=build_ui /src/dist/* resources/build/

RUN gradle build --no-daemon

# Step 4: setup user and run the application
FROM openjdk:8-jre-alpine

ENV APPLICATION_USER paobble-web

ENV APPLICATION_VERSION 0.0.1

RUN adduser -D -g '' ${APPLICATION_USER}

RUN mkdir /app

RUN chown -R ${APPLICATION_USER} /app

USER ${APPLICATION_USER}

COPY --from=build-stage ./src/build/libs/example-${APPLICATION_VERSION}-all.jar /app/example.jar

WORKDIR /app

CMD ["java", "-server", "-XX:+UnlockExperimentalVMOptions", "-XX:+UseCGroupMemoryLimitForHeap", "-XX:InitialRAMFraction=2", "-XX:MinRAMFraction=2", "-XX:MaxRAMFraction=2", "-XX:+UseG1GC", "-XX:MaxGCPauseMillis=100", "-XX:+UseStringDeduplication", "-jar", "example.jar"]

