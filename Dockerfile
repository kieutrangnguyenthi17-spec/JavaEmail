
# Giai đoạn 1: Build ứng dụng
FROM maven:3.9-eclipse-temurin-21 AS build

WORKDIR /app

COPY . .

RUN mvn clean package -DskipTests

# Giai đoạn 2: Chạy ứng dụng bằng Tomcat
FROM tomcat:9.0.123-jdk21-temurin-noble

# Xóa trang ROOT mặc định của Tomcat
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Đưa ứng dụng vào Tomcat
COPY --from=build /app/target/JavaEmail-1.0.war /usr/local/tomcat/webapps/ROOT.war

# Cổng Render
EXPOSE 10000

# Cấu hình Tomcat sử dụng cổng Render cấp
CMD ["sh", "-c", "sed -i 's/port=\"8080\"/port=\"'\"${PORT:-10000}\"'\"/' /usr/local/tomcat/conf/server.xml && catalina.sh run"]
