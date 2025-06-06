# 博客系统开发规范

## 📋 目录

- [项目概述](#项目概述)
- [技术栈](#技术栈)
- [开发环境](#开发环境)
- [代码规范](#代码规范)
- [Git 工作流](#git-工作流)
- [项目结构](#项目结构)
- [开发流程](#开发流程)
- [测试规范](#测试规范)
- [部署规范](#部署规范)
- [团队协作](#团队协作)

## 🎯 项目概述

本项目是一个基于 Spring Boot + Vue.js 的前后端分离博客系统，支持文章管理、用户系统、评论功能等完整的博客功能。

### 核心功能
- 📝 文章管理（创建、编辑、删除、排序、点赞）
- 👥 用户系统（注册、登录、权限管理）
- 💬 评论系统（评论、回复、审核）
- 🔍 搜索功能（多条件搜索和筛选）
- 📊 数据统计（浏览量、点赞数等）

## 🛠️ 技术栈

### 后端技术
- **框架**: Spring Boot 3.5.0
- **Java 版本**: Java 21
- **数据库**: MySQL 8.0+ / H2 (开发环境)
- **ORM**: Spring Data JPA
- **构建工具**: Maven 3.6+
- **API 文档**: SpringDoc OpenAPI 3

### 前端技术
- **框架**: Vue.js 3 (Composition API)
- **UI 库**: Element Plus
- **构建工具**: Vite
- **HTTP 客户端**: Axios
- **路由**: Vue Router 4

## 💻 开发环境

### 必需软件
- Java 21 或更高版本
- Maven 3.6 或更高版本
- Node.js 16 或更高版本
- MySQL 8.0 或更高版本
- Git

### IDE 推荐
- **后端**: IntelliJ IDEA / Eclipse
- **前端**: VS Code / WebStorm
- **数据库**: MySQL Workbench / Navicat

### 环境配置
```bash
# 克隆项目
git clone <repository-url>
cd blog-system

# 后端环境
./mvnw spring-boot:run

# 前端环境
cd frontend
npm install
npm run dev
```

## 📝 代码规范

### Java 代码规范

#### 命名规范
- **类名**: 使用 PascalCase，如 `BlogController`、`UserService`
- **方法名**: 使用 camelCase，如 `getAllBlogs()`、`createUser()`
- **变量名**: 使用 camelCase，如 `blogList`、`userId`
- **常量名**: 使用 UPPER_SNAKE_CASE，如 `MAX_PAGE_SIZE`
- **包名**: 使用小写，如 `com.blogsystem.controller`

#### 注释规范
```java
/**
 * 博客控制器
 * 处理博客相关的HTTP请求
 * 
 * @author 开发者姓名
 * @since 2024-01-01
 */
@RestController
@RequestMapping("/api/blogs")
public class BlogController {
    
    /**
     * 获取所有博客
     * 
     * @param page 页码
     * @param size 每页大小
     * @param sortBy 排序方式
     * @return 博客列表
     */
    @GetMapping
    public ResponseEntity<List<Blog>> getAllBlogs(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "time") String sortBy) {
        // 方法实现
    }
}
```

#### 代码结构
- **Controller**: 只处理HTTP请求，不包含业务逻辑
- **Service**: 包含业务逻辑，调用Repository
- **Repository**: 数据访问层，继承JpaRepository
- **Entity**: 实体类，使用JPA注解
- **Config**: 配置类，如CORS、安全配置等

### Vue.js 代码规范

#### 组件命名
- **文件名**: 使用 PascalCase，如 `BlogDetail.vue`、`UserDashboard.vue`
- **组件名**: 使用 PascalCase，如 `<BlogDetail>`
- **变量名**: 使用 camelCase，如 `blogList`、`isLoading`

#### 组件结构
```vue
<template>
  <!-- HTML 模板 -->
  <div class="blog-detail">
    <h1>{{ blog.title }}</h1>
    <!-- 其他内容 -->
  </div>
</template>

<script setup>
// 导入
import { ref, onMounted } from 'vue'
import axios from 'axios'

// 响应式数据
const blog = ref({})
const loading = ref(false)

// 方法
const fetchBlog = async (id) => {
  loading.value = true
  try {
    const response = await axios.get(`/api/blogs/${id}`)
    blog.value = response.data
  } catch (error) {
    console.error('获取博客失败:', error)
  } finally {
    loading.value = false
  }
}

// 生命周期
onMounted(() => {
  fetchBlog(route.params.id)
})
</script>

<style scoped>
/* 组件样式 */
.blog-detail {
  padding: 20px;
}
</style>
```

#### 注释规范
```javascript
/**
 * 获取博客详情
 * @param {number} id - 博客ID
 * @returns {Promise} 博客数据
 */
const fetchBlog = async (id) => {
  // 实现代码
}
```

## 🔄 Git 工作流

### 分支策略
- **main**: 主分支，用于生产环境
- **develop**: 开发分支，用于集成功能
- **feature/功能名**: 功能分支，如 `feature/user-login`
- **bugfix/问题描述**: 修复分支，如 `bugfix/login-error`
- **hotfix/紧急修复**: 热修复分支

### 提交规范
```bash
# 提交格式
<类型>: <描述>

# 类型说明
feat: 新功能
fix: 修复bug
docs: 文档更新
style: 代码格式调整
refactor: 代码重构
test: 测试相关
chore: 构建过程或辅助工具的变动

# 示例
feat: 添加文章点赞功能
fix: 修复用户登录失败的问题
docs: 更新API文档
style: 统一代码缩进格式
refactor: 重构博客服务层代码
test: 添加用户服务单元测试
chore: 更新依赖版本
```

### 工作流程
```bash
# 1. 从main分支创建功能分支
git checkout main
git pull origin main
git checkout -b feature/article-like

# 2. 开发功能
# ... 编写代码 ...

# 3. 提交代码
git add .
git commit -m "feat: 添加文章点赞功能"

# 4. 推送分支
git push origin feature/article-like

# 5. 创建Pull Request
# 在GitHub/GitLab上创建PR，请求合并到main分支

# 6. 代码审查通过后合并
# 删除功能分支
git checkout main
git pull origin main
git branch -d feature/article-like
```

## 📁 项目结构

### 后端结构
```
src/main/java/com/blogsystem/
├── BlogSystemApplication.java          # 主启动类
├── config/                            # 配置类
│   ├── CorsConfig.java               # 跨域配置
│   ├── DataInitializer.java          # 数据初始化
│   ├── GlobalExceptionHandler.java   # 全局异常处理
│   └── SecurityConfig.java           # 安全配置
├── controller/                        # 控制器层
│   ├── AdminController.java          # 管理员控制器
│   ├── BlogController.java           # 博客控制器
│   ├── CategoryController.java       # 分类控制器
│   ├── CommentController.java        # 评论控制器
│   ├── TagController.java            # 标签控制器
│   └── UserController.java           # 用户控制器
├── entity/                           # 实体类
│   ├── Blog.java                     # 博客实体
│   ├── Category.java                 # 分类实体
│   ├── Comment.java                  # 评论实体
│   ├── Tag.java                      # 标签实体
│   └── User.java                     # 用户实体
├── repository/                       # 数据访问层
│   ├── BlogRepository.java           # 博客仓库
│   ├── CategoryRepository.java       # 分类仓库
│   ├── CommentRepository.java        # 评论仓库
│   ├── TagRepository.java            # 标签仓库
│   └── UserRepository.java           # 用户仓库
└── service/                          # 业务逻辑层
    ├── BlogService.java              # 博客服务
    ├── CategoryService.java          # 分类服务
    ├── CommentService.java           # 评论服务
    ├── TagService.java               # 标签服务
    └── UserService.java              # 用户服务
```

### 前端结构
```
frontend/src/
├── App.vue                           # 根组件
├── main.js                           # 入口文件
├── router/                           # 路由配置
│   └── index.js                      # 路由定义
├── style/                            # 样式文件
│   └── global.css                    # 全局样式
└── views/                            # 页面组件
    ├── Admin.vue                     # 管理员页面
    ├── Articles.vue                  # 文章列表页面
    ├── BlogDetail.vue                # 博客详情页面
    ├── Home.vue                      # 首页
    ├── Login.vue                     # 登录页面
    ├── Register.vue                  # 注册页面
    ├── Search.vue                    # 搜索页面
    └── UserDashboard.vue             # 用户仪表板
```

## 🔄 开发流程

### 新功能开发流程

1. **需求分析**
   - 明确功能需求
   - 设计API接口
   - 确定数据库结构

2. **创建分支**
   ```bash
   git checkout -b feature/功能名
   ```

3. **后端开发**
   - 创建/修改Entity
   - 创建/修改Repository
   - 创建/修改Service
   - 创建/修改Controller
   - 编写单元测试

4. **前端开发**
   - 创建/修改Vue组件
   - 添加路由配置
   - 实现API调用
   - 添加样式

5. **测试**
   - 单元测试
   - 集成测试
   - 手动测试

6. **提交代码**
   ```bash
   git add .
   git commit -m "feat: 功能描述"
   git push origin feature/功能名
   ```

7. **代码审查**
   - 创建Pull Request
   - 团队成员审查
   - 修改反馈问题

8. **合并代码**
   - 审查通过后合并到main分支
   - 删除功能分支

### Bug修复流程

1. **问题定位**
   - 复现问题
   - 分析错误日志
   - 确定问题范围

2. **创建修复分支**
   ```bash
   git checkout -b bugfix/问题描述
   ```

3. **修复问题**
   - 修改相关代码
   - 添加测试用例
   - 验证修复效果

4. **提交和合并**
   ```bash
   git commit -m "fix: 修复问题描述"
   git push origin bugfix/问题描述
   ```

## 🧪 测试规范

### 后端测试

#### 单元测试
```java
@SpringBootTest
class BlogServiceTest {
    
    @Autowired
    private BlogService blogService;
    
    @Test
    void testCreateBlog() {
        // Given
        Blog blog = new Blog();
        blog.setTitle("测试博客");
        blog.setContent("测试内容");
        
        // When
        Blog savedBlog = blogService.createBlog(blog);
        
        // Then
        assertThat(savedBlog.getId()).isNotNull();
        assertThat(savedBlog.getTitle()).isEqualTo("测试博客");
    }
}
```

#### 集成测试
```java
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class BlogControllerIntegrationTest {
    
    @Autowired
    private TestRestTemplate restTemplate;
    
    @Test
    void testGetAllBlogs() {
        // When
        ResponseEntity<String> response = restTemplate.getForEntity("/api/blogs", String.class);
        
        // Then
        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
    }
}
```

### 前端测试

#### 组件测试
```javascript
// 使用 Vue Test Utils
import { mount } from '@vue/test-utils'
import BlogDetail from '@/views/BlogDetail.vue'

describe('BlogDetail.vue', () => {
  it('renders blog title', () => {
    const blog = { title: '测试博客', content: '测试内容' }
    const wrapper = mount(BlogDetail, {
      props: { blog }
    })
    expect(wrapper.text()).toContain('测试博客')
  })
})
```

### 测试覆盖率要求
- **后端**: 单元测试覆盖率 > 80%
- **前端**: 组件测试覆盖率 > 70%
- **集成测试**: 主要API端点全覆盖

## 🚀 部署规范

### 环境配置

#### 开发环境
- 使用H2内存数据库
- 启用热重载
- 详细日志输出

#### 生产环境
- 使用MySQL数据库
- 优化JVM参数
- 配置日志级别

### 部署流程

1. **构建项目**
   ```bash
   # 后端构建
   mvn clean package -Pprod
   
   # 前端构建
   cd frontend
   npm run build
   ```

2. **Windows服务部署**
   ```bash
   install-service.bat
   ```

### 配置管理
- **开发环境**: `application.properties`
- **生产环境**: `application-prod.yml`

## 👥 团队协作

### 角色分工
- **项目负责人**: 整体架构设计、代码审查
- **后端开发**: Java后端开发、API设计
- **前端开发**: Vue.js前端开发、UI实现
- **测试工程师**: 测试用例编写、质量保证

### 沟通规范

#### 日常沟通
- **每日站会**: 分享进度、讨论问题
- **周会**: 总结本周工作、计划下周任务
- **技术分享**: 定期分享技术心得

#### 文档管理
- **API文档**: 使用Swagger自动生成
- **需求文档**: 详细记录功能需求
- **技术文档**: 记录技术决策和架构设计

#### 代码审查
- **必须审查**: 所有代码合并前必须经过审查
- **审查要点**: 代码质量、性能、安全性
- **反馈及时**: 24小时内完成审查反馈

### 质量保证

#### 代码质量
- 遵循编码规范
- 编写单元测试
- 使用静态代码分析工具

#### 性能要求
- API响应时间 < 500ms
- 页面加载时间 < 3s
- 数据库查询优化

#### 安全要求
- 输入验证和过滤
- SQL注入防护
- XSS攻击防护
- 密码加密存储

## 📚 学习资源

### 技术文档
- [Spring Boot官方文档](https://spring.io/projects/spring-boot)
- [Vue.js官方文档](https://vuejs.org/)
- [Element Plus文档](https://element-plus.org/)
- [MySQL官方文档](https://dev.mysql.com/doc/)

### 最佳实践
- [Java编码规范](https://google.github.io/styleguide/javaguide.html)
- [Vue.js风格指南](https://vuejs.org/style-guide/)
- [RESTful API设计指南](https://restfulapi.net/)

## 🔧 常见问题

### 开发环境问题

**Q: 后端启动失败，提示数据库连接错误**
A: 检查MySQL服务是否启动，确认数据库配置是否正确

**Q: 前端启动失败，提示依赖安装错误**
A: 删除node_modules文件夹，重新执行npm install

**Q: 跨域请求被阻止**
A: 检查CorsConfig配置，确保允许前端域名访问

### 部署问题



**Q: Windows服务安装失败**
A: 以管理员身份运行install-service.bat

### 代码问题

**Q: API返回500错误**
A: 查看后端日志，检查异常堆栈信息

**Q: 前端页面显示异常**
A: 打开浏览器开发者工具，查看控制台错误信息

---

**最后更新**: 2024年12月
**版本**: v1.0
**维护者**: 博客系统开发团队

如有问题或建议，请提交Issue或联系项目负责人。