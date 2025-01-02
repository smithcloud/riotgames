FROM openjdk:17
WORKDIR /apps
COPY . .
RUN chmod +x gradlew
RUN ./gradlew build
COPY ./build/libs/skills-backend-0.0.1-SNAPSHOT.jar .
CMD ["java","-jar","/apps/skills-backend-0.0.1-SNAPSHOT.jar"]
