# 个人博客系统

一个基于 Spring Boot + Vue.js 开发的现代化前后端分离博客系统，支持用户和管理员双重角色、文章管理、评论功能等完整的博客功能。

## 🎯 最新更新

- ✅ **作者信息显示**：修复了新发布文章不显示作者名的问题
- ✅ **Token 认证优化**：完善了用户身份验证机制
- ✅ **代码结构优化**：清理了废弃文件，提升了代码质量
- ✅ **文档完善**：更新了部署和配置说明
- ✅ **功能状态更新**：根据前后端实现情况更新功能完成状态

## 🚀 功能特性

### ✅ 已实现功能（前后端均完成）

#### 📝 文章管理

- ✅ 创建、编辑、删除博客文章（前端：UserDashboard.vue + 后端：BlogController.java）
- ✅ 文章分类和标签管理（前端：Articles.vue + 后端：CategoryController.java, TagController.java）
- ✅ 文章发布/草稿状态切换（前端：UserDashboard.vue + 后端：BlogController.java）
- ✅ 分页显示文章列表（前端：Articles.vue + 后端：BlogController.java）
- ✅ 文章详情页面（前端：BlogDetail.vue + 后端：BlogController.java）
- ⚠️ 支持 Markdown 编辑器（后端已支持，前端使用基础文本编辑器）
- ⚠️ 文章浏览量统计（后端已实现，前端显示待完善）

#### 👥 用户系统

- ✅ 用户注册和登录（前端：Login.vue, Register.vue + 后端：UserController.java）
- ✅ 管理员和普通用户双重登录（前端：Login.vue + 后端：UserController.java, AdminController.java）
- ✅ 用户个人资料管理（前端：UserDashboard.vue + 后端：UserController.java）
- ✅ 用户个人博客管理（前端：UserDashboard.vue + 后端：BlogController.java）
- ✅ 基本的管理员权限管理（前端：Admin.vue + 后端：AdminController.java）
- ✅ 基于角色的路由守卫（前端：router/index.js）
- ✅ 智能登录后重定向（前端：Login.vue）

#### 💬 评论系统

- ✅ 文章评论功能（前端：BlogDetail.vue + 后端：CommentController.java）
- ✅ 评论回复功能（后端：CommentController.java）
- ✅ 评论审核机制（后端：CommentService.java）
- ⚠️ 评论管理界面（后端已实现，前端管理界面待完善）
- ✅ 评论统计（后端：CommentController.java）

#### 🔍 搜索功能

- ✅ 按标题搜索文章（前端：Search.vue + 后端：BlogController.java）
- ✅ 按分类筛选文章（前端：Articles.vue + 后端：BlogController.java）
- ✅ 按标签筛选文章（前端：Articles.vue + 后端：BlogController.java）
- ✅ 最新文章展示（前端：Home.vue + 后端：BlogController.java）
- ⚠️ 热门文章推荐（后端逻辑待实现）

#### 📊 统计功能

- ✅ 管理员数据概览（前端：Admin.vue + 后端：AdminController.java）
- ⚠️ 文章浏览量统计（后端已实现，前端显示待完善）
- ⚠️ 评论数量统计（后端已实现，前端显示待完善）
- ⚠️ 分类文章数量统计（后端已实现，前端显示待完善）
- ⚠️ 标签使用频率统计（后端已实现，前端显示待完善）

#### 🏷️ 分类和标签管理

- ✅ 分类的创建、编辑、删除（后端：CategoryController.java）
- ✅ 标签的创建、编辑、删除（后端：TagController.java）
- ✅ 分类和标签的状态管理（后端已实现）
- ⚠️ 分类和标签的前端管理界面（等待前端实现）
- ⚠️ 分类和标签的搜索功能（等待前端实现）

### ⚠️ 部分实现功能（等待前端或后端完善）

#### 📊 数据统计显示

- ⚠️ 文章浏览量显示（后端已实现，等待前端完善显示）
- ⚠️ 数据可视化图表（后端数据已准备，等待前端图表实现）
- ⚠️ 统计数据详细展示（后端已实现，等待前端界面优化）

#### 💬 评论管理界面

- ⚠️ 评论批量管理（后端已实现，等待前端管理界面）
- ⚠️ 评论审核界面（后端已实现，等待前端界面）

#### 🏷️ 分类标签管理

- ⚠️ 分类管理界面（后端已实现，等待前端管理界面）
- ⚠️ 标签管理界面（后端已实现，等待前端管理界面）
- ⚠️ 分类标签搜索（后端已实现，等待前端搜索界面）

### ❌ 未实现功能

#### 📷 图片上传功能

- ❌ 文章图片上传（前后端均未实现）
- ❌ 用户头像上传（前后端均未实现）
- ❌ 图片管理和存储（前后端均未实现）

#### 🔐 高级权限管理

- ❌ 细粒度权限控制（前后端均未实现）
- ❌ 角色权限配置（前后端均未实现）
- ❌ 权限继承机制（前后端均未实现）

#### 🎨 富文本编辑器

- ❌ Markdown 编辑器集成（等待前端实现）
- ❌ 富文本编辑器（等待前端实现）
- ❌ 代码高亮显示（等待前端实现）

#### 🔒 高级安全功能

- ❌ JWT Token 认证（等待后端实现）
- ❌ 密码加密存储（等待后端实现）
- ❌ 登录限制和防暴力破解（等待后端实现）
- ❌ 操作日志记录（等待后端实现）

#### 🌐 SEO 和性能优化

- ❌ SEO 优化（等待前端实现）
- ❌ 页面缓存机制（等待前后端实现）
- ❌ 静态资源优化（等待前端实现）

## 🛠️ 技术栈

### 后端技术

- **后端框架**: Spring Boot 3.5.0
- **数据库**: MySQL 8.0+ / H2 (开发环境)
- **ORM 框架**: Spring Data JPA
- **Java 版本**: Java 21
- **构建工具**: Maven 3.6+
- **API 文档**: SpringDoc OpenAPI 3
- **认证方式**: 基于 Token 的身份验证

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
├── src/main/java/com/blogsystem/          # 后端源码 (Spring Boot)
│   ├── config/                           # 配置类
│   ├── controller/                       # 控制器层
│   ├── entity/                          # 实体类
│   ├── repository/                      # 数据访问层
│   ├── service/                         # 业务逻辑层
│   └── BlogSystemApplication.java       # 主启动类
├── src/main/resources/                   # 资源文件
│   ├── application.properties           # 应用配置
│   ├── application-prod.yml             # 生产环境配置
│   ├── application-docker.yml           # Docker环境配置
│   ├── data.sql                        # 初始数据
│   └── schema.sql                      # 数据库结构
├── src/test/java/                       # 测试代码
├── frontend/                            # 前端源码 (Vue.js)
│   ├── src/
│   │   ├── views/                      # 页面组件
│   │   │   ├── Admin.vue               # 管理员页面
│   │   │   ├── Articles.vue            # 文章列表页面
│   │   │   ├── BlogDetail.vue          # 博客详情页面
│   │   │   ├── Home.vue                # 首页
│   │   │   ├── Login.vue               # 登录页面
│   │   │   ├── Register.vue            # 注册页面
│   │   │   ├── Search.vue              # 搜索页面
│   │   │   └── UserDashboard.vue       # 用户仪表板
│   │   ├── router/                     # 路由配置
│   │   │   └── index.js                # 路由定义
│   │   ├── style/                      # 样式文件
│   │   │   └── global.css              # 全局样式
│   │   ├── App.vue                     # 根组件
│   │   └── main.js                     # 入口文件
│   ├── index.html                      # HTML模板
│   ├── package.json                    # 依赖配置
│   ├── package-lock.json               # 依赖锁定文件
│   └── vite.config.js                  # Vite配置
├── target/                              # Maven构建输出
├── .mvn/wrapper/                        # Maven Wrapper
├── pom.xml                             # Maven配置
├── mvnw                                # Maven Wrapper脚本 (Unix)
├── mvnw.cmd                            # Maven Wrapper脚本 (Windows)
├── Dockerfile                          # Docker镜像配置
├── docker-compose.yml                  # Docker编排配置
├── start-backend.bat                   # 后端启动脚本
├── install-service.bat                 # Windows服务安装脚本
├── manage-service.bat                  # Windows服务管理脚本
├── .gitignore                          # Git忽略文件
├── .gitattributes                      # Git属性配置
├── README.md                           # 项目说明
├── DATABASE_SETUP.md                   # 数据库设置说明
└── DEPLOYMENT.md                       # 部署说明
```

## ⚙️ 配置说明

### 数据库配置

项目支持多种数据库配置，详细说明请参考 [DATABASE_SETUP.md](DATABASE_SETUP.md)。

**快速配置：**

- **MySQL（推荐）**：修改 `application.properties` 中的数据库连接信息
- **H2（开发测试）**：无需额外配置，开箱即用

### 环境配置文件

- `application.properties` - 默认配置（开发环境）
- `application-prod.yml` - 生产环境配置
- `application-docker.yml` - Docker 环境配置

### 服务器配置

```properties
# 默认配置
server.port=8080
server.servlet.context-path=/api

# 生产环境会自动优化性能参数
```

## 🚀 部署

本项目提供多种部署方案，详细说明请参考 [DEPLOYMENT.md](DEPLOYMENT.md)。

### 快速部署

#### 方案一：Windows 服务（推荐）

```bash
# 安装为 Windows 服务
install-service.bat

# 管理服务
manage-service.bat
```

#### 方案二：Docker 部署

```bash
# 使用 Docker Compose 一键部署
docker-compose up -d
```

#### 方案三：直接运行

```bash
# 构建项目
mvn clean package

# 运行后端（生产模式）
start-backend.bat

# 或手动运行
java -jar -Xms512m -Xmx1024m -Dspring.profiles.active=prod target/blog-system-0.0.1-SNAPSHOT.jar
```

### 前端部署

```bash
cd frontend
npm install
npm run build
npm run preview
```

### Docker 配置文件

项目已包含完整的 Docker 配置：

- `Dockerfile` - 后端应用容器化配置
- `docker-compose.yml` - 多服务编排配置
- `application-docker.yml` - Docker 环境专用配置

详细使用方法请参考 [DEPLOYMENT.md](DEPLOYMENT.md)。

## ✨ 功能特色

### 核心功能

- 📝 **博客管理**：创建、编辑、删除博客文章，支持富文本编辑
- 👥 **用户系统**：用户注册、登录、个人资料管理
- 💬 **评论系统**：支持博客文章评论和回复
- 🔐 **权限控制**：管理员和普通用户权限分离
- 🔍 **搜索功能**：支持博客标题和内容搜索
- 📄 **分页显示**：大数据量的分页处理

### 技术特色

- 🚀 **高性能**：Spring Boot + Vue 3 + Element Plus 技术栈
- 📱 **响应式设计**：支持桌面和移动设备
- 🎨 **现代化 UI**：基于 Element Plus 的美观界面
- 📊 **数据统计**：博客访问量、用户统计等
- 🔧 **多环境配置**：开发、生产、Docker 环境配置

### 部署特色

- 🖥️ **Windows 服务**：一键安装为系统服务，开机自启
- 🐳 **Docker 支持**：完整的容器化部署方案
- 📋 **服务管理**：图形化服务管理界面
- 🔄 **自动重启**：服务异常自动恢复
- 📝 **详细文档**：完整的部署和配置说明

### 🎨 现代化 UI 设计

- **Element Plus 组件库**：提供丰富的 UI 组件
- **响应式布局**：适配各种屏幕尺寸
- **暗色主题支持**：用户可切换主题模式
- **动画效果**：流畅的页面切换和交互动画

### 🔧 技术架构

- **前后端分离**：清晰的架构设计
- **RESTful API**：标准的 API 设计
- **JWT 认证**：安全的用户认证机制
- **数据验证**：前后端双重数据验证
- **异常处理**：完善的错误处理机制

### 📊 性能优化

- **数据库索引**：优化查询性能
- **分页查询**：减少数据传输量
- **缓存机制**：提升响应速度
- **代码分割**：前端按需加载

### 🛡️ 安全特性

- **SQL 注入防护**：使用 JPA 防止 SQL 注入
- **XSS 防护**：前端输入过滤和转义
- **CSRF 防护**：跨站请求伪造防护
- **密码加密**：使用 BCrypt 加密存储

## 🧹 维护说明

### 清理废弃文件

项目已进行废弃文件清理，当前项目结构干净整洁：

**已清理的内容：**

- ✅ 无废弃的临时文件
- ✅ 无多余的备份文件
- ✅ 无未使用的配置文件
- ✅ 项目结构规范化

**定期维护建议：**

```bash
# 清理前端构建缓存（如需要）
cd frontend
rm -rf node_modules
npm install

# 清理后端构建文件
mvn clean

# 清理运行时日志文件（如存在）
# 注意：logs/ 目录在 .gitignore 中，不会提交到版本控制
rm -rf logs/
```

### 代码质量

- ✅ 代码结构清晰，按功能模块组织
- ✅ 前后端分离架构合理
- ✅ 依赖管理规范（Maven + npm）
- ✅ 配置文件完整（开发/生产/Docker 环境）
- 🔄 建议定期更新依赖版本
- 🔄 建议完善单元测试覆盖率

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
