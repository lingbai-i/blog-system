# 🌟 个人博客系统

一个基于 Spring Boot + Vue.js 开发的现代化前后端分离博客系统，支持用户和管理员双重角色、文章管理、评论功能等完整的博客功能。

## 📅 项目信息

- **最后更新**: 2025年6月8日
- **版本**: v1.0.0
- **开发状态**: 活跃开发中
- **许可证**: MIT License

## 🎯 最新更新 (2025年6月)

- ✅ **公告系统完善**：实现了完整的公告发布、管理和展示功能
- ✅ **用户头像上传**：支持多种图片格式的头像上传和显示
- ✅ **文章点赞功能**：实现文章点赞、点赞计数和防重复点赞机制
- ✅ **评论系统优化**：完善评论删除、级联删除和权限验证
- ✅ **搜索功能增强**：多条件搜索、筛选和排序功能
- ✅ **界面优化**：现代化UI设计，响应式布局
- ✅ **安全配置**：完善的身份验证和权限管理

## 🚀 功能模块

### 📝 文章管理模块

#### ✅ 已实现功能
- **文章CRUD操作**
  - 创建、编辑、删除博客文章
  - 支持Markdown和富文本编辑
  - 文章草稿和发布状态管理
  - 文章图片上传和管理

- **文章展示功能**
  - 分页显示文章列表
  - 文章详情页面展示
  - 文章浏览量统计
  - 代码高亮显示

- **文章分类管理**
  - 分类创建、编辑、删除
  - 按分类筛选文章
  - 分类文章数量统计

- **标签系统**
  - 标签创建、编辑、删除
  - 按标签筛选文章
  - 标签使用频率统计

- **文章排序功能**
  - 按发布时间排序
  - 按浏览量排序
  - 按点赞数排序
  - 按热度排序

- **文章点赞系统**
  - 用户点赞/取消点赞
  - 点赞数量统计
  - 防重复点赞机制

### 👥 用户管理模块

#### ✅ 已实现功能
- **用户认证系统**
  - 用户注册和登录
  - 管理员和普通用户双重登录
  - 基于Token的身份验证
  - 智能登录后重定向

- **用户资料管理**
  - 个人资料编辑
  - 用户头像上传和显示
  - 密码修改功能

- **权限管理**
  - 基于角色的权限控制
  - 路由守卫机制
  - 管理员权限验证

- **用户统计**
  - 个人文章统计
  - 点赞记录管理
  - 用户活跃度统计

### 💬 评论系统模块

#### ✅ 已实现功能
- **评论基础功能**
  - 文章评论发布
  - 评论回复功能
  - 评论嵌套显示

- **评论管理**
  - 评论删除功能
  - 级联删除机制
  - 评论审核机制
  - 评论权限验证

- **评论统计**
  - 评论数量统计
  - 用户评论记录

### 🔍 搜索功能模块

#### ✅ 已实现功能
- **文章搜索**
  - 按标题关键词搜索
  - 按内容全文搜索
  - 搜索结果高亮显示

- **筛选功能**
  - 按分类筛选
  - 按标签筛选
  - 多条件组合筛选

- **排序功能**
  - 按时间排序
  - 按热度排序
  - 按点赞数排序
  - 按浏览量排序

### 📢 公告系统模块

#### ✅ 已实现功能
- **公告管理**
  - 公告创建、编辑、删除
  - 公告发布状态管理
  - 公告优先级设置

- **公告展示**
  - 首页公告横幅
  - 公告列表页面
  - 公告详情页面

### 📊 统计分析模块

#### ✅ 已实现功能
- **管理员统计**
  - 系统数据概览
  - 用户统计信息
  - 文章统计信息
  - 评论统计信息

- **用户个人统计**
  - 个人文章统计
  - 点赞收藏统计
  - 评论互动统计

### 📁 文件管理模块

#### ✅ 已实现功能
- **图片上传**
  - 文章图片上传
  - 用户头像上传
  - 图片格式验证
  - 图片大小限制

- **静态资源管理**
  - 静态资源访问配置
  - 文件存储路径管理

## 🛠️ 技术栈

### 后端技术
- **框架**: Spring Boot 3.5.0
- **数据库**: MySQL 8.0+ / H2 (开发环境)
- **ORM**: Spring Data JPA
- **Java版本**: Java 21
- **构建工具**: Maven 3.6+
- **安全框架**: Spring Security
- **API文档**: SpringDoc OpenAPI 3
- **文件上传**: Spring Boot MultipartFile

### 前端技术
- **框架**: Vue.js 3 (Composition API)
- **UI组件库**: Element Plus
- **构建工具**: Vite
- **HTTP客户端**: Axios
- **路由管理**: Vue Router 4
- **富文本编辑器**: Quill.js
- **Markdown支持**: markdown-it
- **图表库**: ECharts
- **代码高亮**: highlight.js

## 📋 系统要求

- **Java**: 21 或更高版本
- **Maven**: 3.6 或更高版本
- **Node.js**: 16 或更高版本
- **MySQL**: 8.0 或更高版本 (生产环境)
- **浏览器**: 支持 ES6+ 的现代浏览器

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
CREATE DATABASE blog_system CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

2. 修改 `src/main/resources/application.properties` 中的数据库配置:

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/blog_system?useSSL=false&serverTimezone=Asia/Shanghai
spring.datasource.username=your_username
spring.datasource.password=your_password
```

#### 使用 H2 数据库 (开发环境)

无需额外配置，系统会自动创建内存数据库。

### 3. 启动后端服务

```bash
# 使用 Maven 启动
mvn spring-boot:run

# 或者编译后启动
mvn clean package
java -jar target/blog-system-0.0.1-SNAPSHOT.jar
```

后端服务将在 `http://localhost:8080` 启动

### 4. 启动前端服务

```bash
cd frontend
npm install
npm run dev
```

前端服务将在 `http://localhost:3000` 启动

### 5. 访问系统

- **前端页面**: http://localhost:3000
- **后端API**: http://localhost:8080
- **API文档**: http://localhost:8080/swagger-ui.html

## 📖 使用指南

### 管理员账户

系统启动后会自动创建管理员账户：
- **用户名**: admin
- **密码**: admin123

### 普通用户

可以通过注册页面创建普通用户账户。

### 主要功能使用

1. **发布文章**: 登录后进入用户中心，点击"发布文章"
2. **管理文章**: 在用户中心可以查看、编辑、删除自己的文章
3. **浏览文章**: 在首页和文章列表页浏览所有公开文章
4. **搜索文章**: 使用搜索框按关键词搜索文章
5. **评论互动**: 在文章详情页发表评论和回复
6. **管理后台**: 管理员可以访问管理后台进行系统管理

## 🔧 开发指南

### 项目结构

```
blog-system/
├── src/main/java/com/blogsystem/     # 后端源码
│   ├── controller/                   # 控制器层
│   ├── service/                      # 服务层
│   ├── repository/                   # 数据访问层
│   ├── entity/                       # 实体类
│   ├── dto/                         # 数据传输对象
│   ├── config/                      # 配置类
│   └── utils/                       # 工具类
├── src/main/resources/              # 资源文件
│   ├── application.properties       # 主配置文件
│   ├── application-dev.yml         # 开发环境配置
│   ├── application-prod.yml        # 生产环境配置
│   └── data.sql                    # 初始化数据
├── frontend/                        # 前端源码
│   ├── src/
│   │   ├── views/                   # 页面组件
│   │   ├── components/              # 通用组件
│   │   ├── router/                  # 路由配置
│   │   └── style/                   # 样式文件
│   ├── package.json                # 前端依赖
│   └── vite.config.js              # Vite配置
└── uploads/                         # 文件上传目录
    ├── articles/                    # 文章图片
    └── avatars/                     # 用户头像
```

### API 接口文档

启动后端服务后，访问 `http://localhost:8080/swagger-ui.html` 查看完整的API文档。

### 主要API端点

- **用户管理**: `/api/users/*`
- **文章管理**: `/api/blogs/*`
- **评论管理**: `/api/comments/*`
- **分类管理**: `/api/categories/*`
- **标签管理**: `/api/tags/*`
- **公告管理**: `/api/announcements/*`
- **文件上传**: `/api/upload/*`
- **统计数据**: `/api/stats/*`

## 🚀 部署指南

### 生产环境部署

1. **构建前端**:
```bash
cd frontend
npm run build
```

2. **构建后端**:
```bash
mvn clean package -Pprod
```

3. **部署**:
```bash
java -jar -Xms512m -Xmx1024m -Dspring.profiles.active=prod target/blog-system-0.0.1-SNAPSHOT.jar
```

### Docker 部署

```dockerfile
# Dockerfile 示例
FROM openjdk:21-jre-slim

WORKDIR /app

COPY target/blog-system-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8080

CMD ["java", "-jar", "app.jar"]
```

## 🤝 贡献指南

1. Fork 本项目
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

## 📝 更新日志

### v1.0.0 (2025-06-08)
- 🎉 项目初始版本发布
- ✅ 完整的博客系统功能
- ✅ 用户管理和权限控制
- ✅ 文章发布和管理
- ✅ 评论系统
- ✅ 搜索和筛选功能
- ✅ 公告系统
- ✅ 文件上传功能
- ✅ 响应式前端界面

## 🐛 问题反馈

如果您在使用过程中遇到问题，请通过以下方式反馈：

1. 在 GitHub 上提交 Issue
2. 发送邮件至项目维护者
3. 在项目讨论区发起讨论

## 📄 许可证

本项目采用 MIT 许可证。详情请参阅 [LICENSE](LICENSE) 文件。

## 🙏 致谢

感谢以下开源项目的支持：

- [Spring Boot](https://spring.io/projects/spring-boot)
- [Vue.js](https://vuejs.org/)
- [Element Plus](https://element-plus.org/)
- [MySQL](https://www.mysql.com/)
- [Maven](https://maven.apache.org/)
- [Vite](https://vitejs.dev/)

---

**开发团队**: Blog System Development Team  
**最后更新**: 2025年6月8日  
**项目状态**: 🟢 活跃开发中
