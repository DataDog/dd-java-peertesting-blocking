FROM maven:3.8-jdk-8 as build

RUN apt-get update && \
	apt-get install -y libarchive-tools

WORKDIR /app

COPY spring-boot/pom.xml .
RUN mkdir /maven && mvn -Dmaven.repo.local=/maven -B dependency:go-offline

COPY spring-boot/src ./src
RUN mvn -Dmaven.repo.local=/maven package

COPY install_ddtrace.sh binaries/* /binaries/
RUN /binaries/install_ddtrace.sh

FROM eclipse-temurin:11

WORKDIR /app
COPY --from=build /binaries/SYSTEM_TESTS_LIBRARY_VERSION SYSTEM_TESTS_LIBRARY_VERSION
COPY --from=build /binaries/SYSTEM_TESTS_LIBDDWAF_VERSION SYSTEM_TESTS_LIBDDWAF_VERSION
COPY --from=build /binaries/SYSTEM_TESTS_APPSEC_EVENT_RULES_VERSION SYSTEM_TESTS_APPSEC_EVENT_RULES_VERSION
COPY --from=build /app/target/myproject-0.0.1-SNAPSHOT.jar .
COPY --from=build /dd-tracer/dd-java-agent.jar .

COPY blocked.html /app/
COPY blocked.json /app/


#ENV DD_TRACE_HEADER_TAGS='user-agent:http.request.headers.user-agent'

RUN echo "#!/bin/bash\njava -Xmx362m -javaagent:/app/dd-java-agent.jar -jar /app/myproject-0.0.1-SNAPSHOT.jar --server.port=7777" > app.sh
RUN chmod +x app.sh
CMD [ "./app.sh" ]
