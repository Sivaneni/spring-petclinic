FROM eclipse-temurin:17.0.7_7-jre-alpine
ENV TEST=TEST1
COPY target/spring-petclinic-*.jar /opt/spring-petclinic.jar
CMD ["java","-jar","/opt/spring-petclinic.jar"]
