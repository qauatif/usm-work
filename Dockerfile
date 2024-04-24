FROM curlimages/curl:8.2.1 AS download
ARG OTEL_AGENT_VERSION="1.32.0"
RUN curl --silent --fail -L "https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/download/v${OTEL_AGENT_VERSION}/opentelemetry-javaagent.jar" \
    -o "$HOME/opentelemetry-javaagent.jar"

FROM openjdk:17 AS TEMP_BUILD_IMAGE
RUN microdnf install findutils
ENV APP_HOME=/usr/app/
WORKDIR $APP_HOME
COPY build.gradle settings.gradle gradlew $APP_HOME
COPY gradle $APP_HOME/gradle
RUN ./gradlew build || return 0 
COPY . .
RUN ./gradlew build

FROM openjdk:17
ENV ARTIFACT_NAME=usm-work-0.0.1-SNAPSHOT.jar
ENV APP_HOME=/usr/app/
WORKDIR $APP_HOME
COPY --from=TEMP_BUILD_IMAGE $APP_HOME/build/libs/$ARTIFACT_NAME .
COPY --from=download /home/curl_user/opentelemetry-javaagent.jar /opentelemetry-javaagent.jar
CMD java -jar -javaagent:/opentelemetry-javaagent.jar $ARTIFACT_NAME