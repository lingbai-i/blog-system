# 个人博客系统

一个基于 Spring Boot + Vue.js 开发的现代化前后端分离博客系统，支持用户和管理员双重角色、文章管理、评论功能等完整的博客功能。

## 🚀 功能特性

### 📚 文章管理

- 文章的创建、编辑、删除
- 文章发布/取消发布
- 文章分类和标签管理
- 文章搜索功能
- 文章浏览量和点赞统计
- 支持 Markdown 格式

### 👥 用户系统

- 用户注册和登录（支持用户和管理员双重登录）
- 用户个人资料管理
- 用户个人博客管理（我的文章、写文章）
- 管理员权限管理
- 基于角色的路由守卫
- 智能登录后重定向

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
- 管理员后台数据统计

## 🛠️ 技术栈

### 后端技术

- **后端框架**: Spring Boot 3.5.0
- **数据库**: MySQL 8.0+ / H2 (开发环境)
- **ORM 框架**: Spring Data JPA
- **Java 版本**: Java 21
- **构建工具**: Maven
- **API 文档**: SpringDoc OpenAPI 3

### 前端技术

- **前端框架**: Vue.js 3 (Composition API)
- **UI 组件库**: Element Plus
- **构建工具**: Vite
- **HTTP 客户端**: Axios
- **路由管理**: Vue Router 4
- **样式**: CSS3 + Scoped Styles

## 📋 系统要求

- Java 21 或更高版本
- Maven 3.6 或更高版本
- Node.js 16 或更高版本
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

### 3. 运行后端服务

```bash
# 使用 Maven 运行后端
./mvnw spring-boot:run

# 或者先编译再运行
./mvnw clean package
java -jar target/blog-system-0.0.1-SNAPSHOT.jar
```

### 4. 运行前端服务

```bash
# 进入前端目录
cd frontend

# 安装依赖
npm install

# 启动开发服务器
npm run dev
```

### 5. 访问应用

- **前端应用**: http://localhost:3000
- **后端 API**: http://localhost:8080
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
- `GET /api/blogs/my` - 获取用户自己的博客
- `POST /api/blogs` - 创建新博客
- `PUT /api/blogs/{id}` - 更新博客
- `DELETE /api/blogs/{id}` - 删除博客
- `PUT /api/blogs/{id}/publish` - 发布/取消发布博客
- `GET /api/blogs/search?keyword={keyword}` - 搜索博客

#### 管理员相关

- `POST /api/admin/login` - 管理员登录
- `GET /api/admin/blogs` - 获取所有博客（管理员）
- `GET /api/admin/stats` - 获取统计数据
- `POST /api/admin/blogs` - 管理员创建博客
- `PUT /api/admin/blogs/{id}` - 管理员更新博客
- `DELETE /api/admin/blogs/{id}` - 管理员删除博客

#### 用户相关

- `POST /api/auth/register` - 用户注册
- `POST /api/auth/login` - 用户登录
- `GET /api/auth/profile` - 获取用户信息
- `PUT /api/auth/profile` - 更新用户信息

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
- 登录页面: 选择"管理员登录"
- 登录后跳转: `/admin` (管理员后台)

### 普通用户账号

- 用户名: `user`
- 密码: `user123`
- 登录页面: 选择"用户登录"
- 登录后跳转: `/dashboard` (用户仪表板)

> 注意：用户也可以通过注册页面创建新账号，注册成功后会自动登录并跳转到用户仪表板。

## 📁 项目结构

```
blog-system/
├── src/                                          # 后端代码
│   ├── main/
│   │   ├── java/
│   │   │   └── com/
│   │   │       └── blogsystem/
│   │   │           ├── BlogSystemApplication.java     # 主启动类
│   │   │           ├── entity/                        # 实体类
│   │   │           │   ├── Blog.java                 # 博客实体
│   │   │           │   ├── User.java                 # 用户实体
│   │   │           │   └── Comment.java              # 评论实体
│   │   │           ├── repository/                    # 数据访问层
│   │   │           │   ├── BlogRepository.java
│   │   │           │   ├── UserRepository.java
│   │   │           │   └── CommentRepository.java
│   │   │           ├── service/                       # 业务逻辑层
│   │   │           │   ├── BlogService.java
│   │   │           │   ├── UserService.java
│   │   │           │   └── CommentService.java
│   │   │           ├── controller/                    # 控制器层
│   │   │           │   ├── BlogController.java
│   │   │           │   ├── UserController.java
│   │   │           │   ├── AdminController.java      # 管理员控制器
│   │   │           │   └── CommentController.java
│   │   │           └── config/                        # 配置类
│   │   │               ├── DataInitializer.java      # 数据初始化
│   │   │               ├── GlobalExceptionHandler.java # 全局异常处理
│   │   │               └── CorsConfig.java           # 跨域配置
│   │   └── resources/
│   │       └── application.properties                 # 应用配置
│   └── test/
│       └── java/                                     # 测试代码
├── frontend/                                         # 前端代码
│   ├── src/
│   │   ├── views/                                    # 页面组件
│   │   │   ├── Home.vue                             # 首页
│   │   │   ├── Login.vue                            # 登录页面
│   │   │   ├── Register.vue                         # 注册页面
│   │   │   ├── Admin.vue                            # 管理员后台
│   │   │   ├── UserDashboard.vue                    # 用户仪表板
│   │   │   └── BlogDetail.vue                       # 博客详情页
│   │   ├── router/
│   │   │   └── index.js                             # 路由配置
│   │   ├── style/
│   │   │   └── main.css                             # 全局样式
│   │   ├── App.vue                                  # 根组件
│   │   └── main.js                                  # 入口文件
│   ├── package.json                                 # 前端依赖
│   └── vite.config.js                               # Vite 配置
└── pom.xml                                          # Maven 配置
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

# 跨域配置（支持前端开发服务器）
cors.allowed-origins=http://localhost:3000

# 文件上传配置
spring.servlet.multipart.max-file-size=10MB
spring.servlet.multipart.max-request-size=10MB
```

## 🚀 部署

### 1. 构建前端

```bash
cd frontend
npm run build
```

### 2. 打包后端应用

```bash
./mvnw clean package
```

### 3. 运行 JAR 文件

```bash
java -jar target/blog-system-0.0.1-SNAPSHOT.jar
```

### 4. 使用 Docker (可选)

创建 `Dockerfile`:

```dockerfile
# 多阶段构建
# 阶段1：构建前端
FROM node:18-alpine AS frontend-build
WORKDIR /app/frontend
COPY frontend/package*.json ./
RUN npm install
COPY frontend/ ./
RUN npm run build

# 阶段2：构建后端
FROM openjdk:21-jdk-slim AS backend-build
WORKDIR /app
COPY pom.xml ./
COPY src ./src
COPY --from=frontend-build /app/frontend/dist ./src/main/resources/static
RUN ./mvnw clean package -DskipTests

# 阶段3：运行时
FROM openjdk:21-jdk-slim
VOLUME /tmp
COPY --from=backend-build /app/target/blog-system-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app.jar"]
```

构建和运行:

```bash
docker build -t blog-system .
docker run -p 8080:8080 blog-system
```

## ✨ 功能特色

### 🎨 现代化 UI 设计

- 响应式布局，支持多设备访问
- Element Plus 组件库，提供优雅的用户体验
- 深色/浅色主题切换
- 流畅的页面切换动画

### 🔐 安全认证

- JWT Token 认证机制
- 基于角色的访问控制 (RBAC)
- 路由守卫保护敏感页面
- 自动登录状态检测

### 📱 用户体验

- 智能登录后重定向
- 实时数据更新
- 友好的错误提示
- 加载状态指示

### 🛡️ 数据安全

- 输入验证和清理
- SQL 注入防护
- XSS 攻击防护
- CORS 跨域配置

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
