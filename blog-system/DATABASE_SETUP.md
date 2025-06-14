# 数据库初始化指南

本项目提供了完整的数据库初始化方案，包括表结构创建和示例数据插入。

## 文件说明

### 1. schema.sql

- **位置**: `src/main/resources/schema.sql`
- **作用**: 定义数据库表结构
- **包含内容**:
  - 用户表 (users)
  - 博客文章表 (blogs)
  - 评论表 (comments)
  - 标签表 (tags)
  - 博客标签关联表 (blog_tags)
  - 分类表 (categories)
  - 系统配置表 (system_configs)
  - 访问日志表 (access_logs)

### 2. data.sql

- **位置**: `src/main/resources/data.sql`
- **作用**: 插入初始化数据
- **包含内容**:
  - 系统配置数据
  - 默认分类数据
  - 常用标签数据
  - 示例用户数据
  - 示例博客文章

### 3. DataInitializer.java

- **位置**: `src/main/java/com/blogsystem/config/DataInitializer.java`
- **作用**: 程序启动时的数据初始化
- **特点**: 会对密码进行加密处理

## 配置说明

在 `application.properties` 中已配置:

```properties
# SQL 初始化配置
spring.sql.init.mode=always
spring.sql.init.schema-locations=classpath:schema.sql
spring.sql.init.data-locations=classpath:data.sql
spring.sql.init.continue-on-error=true
spring.sql.init.separator=;

# JPA 配置
spring.jpa.defer-datasource-initialization=true
spring.jpa.database-platform=org.hibernate.dialect.MySQL8Dialect
```

## 使用方法

### 方式一：自动初始化（推荐）

1. **创建数据库**:

   ```sql
   CREATE DATABASE blog CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   ```

2. **启动应用**:

   ```bash
   mvn spring-boot:run
   ```

3. **自动执行**:
   - Spring Boot 会自动执行 `schema.sql` 创建表结构
   - 然后执行 `data.sql` 插入基础数据
   - 最后 `DataInitializer` 会插入示例数据（如果表为空）

### 方式二：手动执行

如果需要手动执行 SQL 文件：

```bash
# 执行表结构
mysql -u root -p blog < src/main/resources/schema.sql

# 执行初始数据
mysql -u root -p blog < src/main/resources/data.sql
```

## 默认账户

初始化完成后，系统会创建以下默认账户：

| 账户类型 | 用户名    | 密码       | 邮箱               | 说明       | 头像支持 |
| -------- | --------- | ---------- | ------------------ | ---------- | -------- |
| 管理员   | admin     | admin123   | admin@blog.com     | 系统管理员 | ✅       |
| 普通用户 | frontend  | frontend123 | frontend@blog.com | 前端工程师 | ✅       |
| 普通用户 | backend   | backend123  | backend@blog.com  | 后端工程师 | ✅       |
| 普通用户 | database  | database123 | database@blog.com | 数据库专家 | ✅       |
| 普通用户 | devops    | devops123   | devops@blog.com   | 运维工程师 | ✅       |

**注意**: 所有用户都支持头像上传功能，头像文件存储在 `uploads/avatars/` 目录下。

## 数据库表结构

数据库包含以下核心表和扩展表，详细的表结构定义请参考 `src/main/resources/schema.sql` 文件：

### 核心表
- **users**: 用户信息表，存储用户基本信息和认证数据
- **articles**: 文章表，存储博客文章的内容和元数据
- **comments**: 评论表，存储文章评论信息
- **categories**: 分类表，存储文章分类信息
- **tags**: 标签表，存储文章标签信息

### 扩展表
- **article_tags**: 文章标签关联表，多对多关系
- **likes**: 点赞表，存储用户点赞记录
- **system_configs**: 系统配置表，存储系统配置参数
- **access_logs**: 访问日志表，记录用户访问日志

### 表关系说明
- 用户与文章：一对多关系（一个用户可以发布多篇文章）
- 文章与分类：多对一关系（多篇文章属于一个分类）
- 文章与标签：多对多关系（通过article_tags表关联）
- 文章与评论：一对多关系（一篇文章可以有多个评论）
- 用户与评论：一对多关系（一个用户可以发表多个评论）
- 用户与点赞：一对多关系（一个用户可以点赞多个目标）

## 注意事项

1. **密码安全**: `data.sql` 中的密码是明文，实际应用中会通过 `DataInitializer` 进行加密

2. **数据库编码**: 确保数据库使用 `utf8mb4` 编码以支持 emoji 等特殊字符

3. **初始化模式**:

   - `spring.sql.init.mode=always` 表示每次启动都会执行
   - 生产环境建议改为 `never` 或 `embedded`

4. **数据冲突**: 使用 `INSERT IGNORE` 避免重复插入数据

5. **外键约束**: 表之间建立了适当的外键关系，删除时会级联处理

## 故障排除

### 常见问题

1. **数据库连接失败**

   - 检查数据库服务是否启动
   - 确认用户名密码是否正确
   - 验证数据库名称是否存在

2. **SQL 执行失败**

   - 检查 SQL 语法是否正确
   - 确认数据库版本兼容性
   - 查看应用日志获取详细错误信息

3. **数据重复插入**
   - 检查是否使用了 `INSERT IGNORE`
   - 确认唯一约束是否正确设置

### 重置数据库

如果需要重置数据库：

```sql
-- 删除所有表
DROP DATABASE blog;

-- 重新创建数据库
CREATE DATABASE blog CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 重启应用，自动重新初始化
```

## 扩展建议

1. **生产环境优化**:

   - 添加数据库连接池配置
   - 设置合适的索引策略
   - 配置数据库备份机制

2. **性能优化**:

   - 根据实际使用情况调整索引
   - 考虑分表分库策略
   - 添加缓存机制

3. **安全加固**:
   - 修改默认密码
   - 限制数据库访问权限
   - 启用 SSL 连接
   
   本项目由@mycc-lingbai-i Teams制作
