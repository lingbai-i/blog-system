# 使用官方 OpenJDK 17 作为基础镜像
FROM openjdk:17-jdk-slim

# 设置工作目录
WORKDIR /app

# 安装必要的工具
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# 复制 Maven 包装器文件
COPY .mvn/ .mvn/
COPY mvnw pom.xml ./
RUN chmod +x mvnw

# 下载依赖（利用 Docker 缓存层）
RUN ./mvnw dependency:go-offline -B

# 复制源代码
COPY src/ src/

# 构建应用
RUN ./mvnw clean package -DskipTests

# 创建必要的目录
RUN mkdir -p /app/uploads /app/logs

# 设置环境变量
ENV SPRING_PROFILES_ACTIVE=prod
ENV JAVA_OPTS="-Xms512m -Xmx1024m -XX:+UseG1GC"

# 暴露端口
EXPOSE 8080 8081

# 健康检查
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8081/actuator/health || exit 1

# 启动应用
CMD ["sh", "-c", "java $JAVA_OPTS -jar target/blog-system-*.jar"]