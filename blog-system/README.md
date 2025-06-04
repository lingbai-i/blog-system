# 个人博客系统

一个基于 Spring Boot 开发的功能完整的个人博客系统，支持文章管理、用户系统、评论功能等。

## 🚀 功能特性

### 📚 文章管理

- 文章的创建、编辑、删除
- 文章发布/取消发布
- 文章分类和标签管理
- 文章搜索功能
- 文章浏览量和点赞统计
- 支持 Markdown 格式

### 👥 用户系统

- 用户注册和登录
- 用户信息管理
- 密码修改
- 管理员权限管理
- 用户角色区分

### 💬 评论系统

- 文章评论功能
- 评论回复功能
- 评论审核机制
- 匿名评论支持
- 评论统计

### 🔍 搜索功能

- 按标题搜索文章
- 按分类筛选文章
- 按标签筛选文章
- 热门文章推荐
- 最新文章展示

### 📊 统计功能

- 文章浏览量统计
- 文章点赞数统计
- 评论数量统计
- 用户数量统计

## 🛠️ 技术栈

- **后端框架**: Spring Boot 3.5.0
- **数据库**: MySQL 8.0+ / H2 (开发环境)
- **ORM 框架**: Spring Data JPA
- **Java 版本**: Java 21
- **构建工具**: Maven
- **API 文档**: SpringDoc OpenAPI 3
- **前端**: HTML5 + CSS3 + JavaScript (原生)

## 📋 系统要求

- Java 21 或更高版本
- Maven 3.6 或更高版本
- MySQL 8.0 或更高版本 (生产环境)

## 🚀 快速开始

### 1. 克隆项目

```bash
git clone <repository-url>
cd blog-system
```

### 2. 配置数据库

#### 使用 MySQL (推荐)

1. 创建数据库:

```sql
CREATE DATABASE blog_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

2. 修改 `src/main/resources/application.properties` 中的数据库配置:

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/blog_db?useSSL=false&serverTimezone=Asia/Shanghai
spring.datasource.username=your_username
spring.datasource.password=your_password
```

#### 使用 H2 (开发环境)

如果想使用 H2 内存数据库进行快速测试，可以将 `application.properties` 修改为:

```properties
spring.datasource.url=jdbc:h2:mem:testdb
spring.datasource.driver-class-name=org.h2.Driver
spring.datasource.username=sa
spring.datasource.password=
spring.h2.console.enabled=true
spring.jpa.hibernate.ddl-auto=create-drop
spring.jpa.show-sql=true
```

### 3. 运行应用

```bash
# 使用 Maven 运行
./mvnw spring-boot:run

# 或者先编译再运行
./mvnw clean package
java -jar target/blog-system-0.0.1-SNAPSHOT.jar
```

### 4. 访问应用

- **主页**: http://localhost:8080
- **API 文档**: http://localhost:8080/swagger-ui.html
- **H2 控制台** (如果使用 H2): http://localhost:8080/h2-console

## 📖 API 文档

应用启动后，可以通过以下地址访问 API 文档:

- Swagger UI: http://localhost:8080/swagger-ui.html
- OpenAPI JSON: http://localhost:8080/v3/api-docs

### 主要 API 端点

#### 博客相关

- `GET /api/blogs` - 获取所有已发布的博客（分页）
- `GET /api/blogs/{id}` - 获取指定博客详情
- `POST /api/blogs` - 创建新博客
- `PUT /api/blogs/{id}` - 更新博客
- `DELETE /api/blogs/{id}` - 删除博客
- `GET /api/blogs/search?keyword={keyword}` - 搜索博客
- `GET /api/blogs/category/{category}` - 按分类获取博客
- `GET /api/blogs/tag/{tag}` - 按标签获取博客

#### 用户相关

- `POST /api/users/register` - 用户注册
- `POST /api/users/login` - 用户登录
- `GET /api/users/{id}` - 获取用户信息
- `PUT /api/users/{id}` - 更新用户信息
- `PUT /api/users/{id}/password` - 修改密码

#### 评论相关

- `POST /api/comments` - 创建评论
- `GET /api/comments/blog/{blogId}` - 获取博客的所有评论
- `POST /api/comments/reply` - 回复评论
- `PUT /api/comments/{id}/approve` - 审核通过评论
- `DELETE /api/comments/{id}` - 删除评论

## 🎯 默认账号

系统启动后会自动创建以下测试账号:

### 管理员账号

- 用户名: `admin`
- 密码: `admin123`
- 邮箱: `admin@blog.com`

### 普通用户账号

- 用户名: `blogger`
- 密码: `blogger123`
- 邮箱: `blogger@blog.com`

- 用户名: `reader`
- 密码: `reader123`
- 邮箱: `reader@blog.com`

## 📁 项目结构

```
src/
├── main/
│   ├── java/
│   │   └── com/
│   │       └── blogsystem/
│   │           ├── BlogSystemApplication.java     # 主启动类
│   │           ├── entity/                        # 实体类
│   │           │   ├── Blog.java                 # 博客实体
│   │           │   ├── User.java                 # 用户实体
│   │           │   └── Comment.java              # 评论实体
│   │           ├── repository/                    # 数据访问层
│   │           │   ├── BlogRepository.java
│   │           │   ├── UserRepository.java
│   │           │   └── CommentRepository.java
│   │           ├── service/                       # 业务逻辑层
│   │           │   ├── BlogService.java
│   │           │   ├── UserService.java
│   │           │   └── CommentService.java
│   │           ├── controller/                    # 控制器层
│   │           │   ├── BlogController.java
│   │           │   ├── UserController.java
│   │           │   └── CommentController.java
│   │           └── config/                        # 配置类
│   │               ├── DataInitializer.java      # 数据初始化
│   │               ├── GlobalExceptionHandler.java # 全局异常处理
│   │               └── CorsConfig.java           # 跨域配置
│   └── resources/
│       ├── application.properties                 # 应用配置
│       └── static/
│           └── index.html                        # 前端页面
└── test/
    └── java/                                     # 测试代码
```

## 🔧 配置说明

### 数据库配置

在 `application.properties` 中配置数据库连接:

```properties
# MySQL 配置
spring.datasource.url=jdbc:mysql://localhost:3306/blog_db?useSSL=false&serverTimezone=Asia/Shanghai
spring.datasource.username=root
spring.datasource.password=123456

# JPA 配置
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQL8Dialect
```

### 服务器配置

```properties
# 服务器端口
server.port=8080

# 文件上传配置
spring.servlet.multipart.max-file-size=10MB
spring.servlet.multipart.max-request-size=10MB
```

## 🚀 部署

### 1. 打包应用

```bash
./mvnw clean package
```

### 2. 运行 JAR 文件

```bash
java -jar target/blog-system-0.0.1-SNAPSHOT.jar
```

### 3. 使用 Docker (可选)

创建 `Dockerfile`:

```dockerfile
FROM openjdk:21-jdk-slim
VOLUME /tmp
COPY target/blog-system-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app.jar"]
```

构建和运行:

```bash
docker build -t blog-system .
docker run -p 8080:8080 blog-system
```

## 🤝 贡献

欢迎提交 Issue 和 Pull Request 来改进这个项目。

## 📄 许可证

本项目采用 MIT 许可证。

## 📞 联系方式

如有问题或建议，请通过以下方式联系:

- 提交 Issue
- 发送邮件

---

**享受编码的乐趣！** 🎉
