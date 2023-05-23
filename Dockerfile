FROM eclipse-temurin:17.0.7_7-jre-alpine
COPY target/spring-petclinic-*.jar /opt/spring-petclinic.jar
CMD ["java","-jar","/opt/"]
