 -- 博客系统完整数据库初始化脚本
-- 包含表结构创建和基础数据插入

-- 禁用外键检查
SET FOREIGN_KEY_CHECKS = 0;

-- 创建数据库表结构

-- 用户表
CREATE TABLE IF NOT EXISTS users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    account VARCHAR(50) NOT NULL UNIQUE COMMENT '账号',
    username VARCHAR(50) NOT NULL COMMENT '用户名',
    email VARCHAR(100) NOT NULL UNIQUE COMMENT '邮箱',
    password VARCHAR(255) NOT NULL COMMENT '密码',
    full_name VARCHAR(100) COMMENT '全名',
    bio TEXT COMMENT '个人简介',
    avatar_url VARCHAR(255) COMMENT '头像URL',
    is_admin BOOLEAN DEFAULT FALSE COMMENT '是否管理员',
    is_active BOOLEAN DEFAULT TRUE COMMENT '是否激活',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';

-- 分类表
CREATE TABLE IF NOT EXISTS categories (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL COMMENT '分类名称',
    slug VARCHAR(100) NOT NULL UNIQUE COMMENT '分类别名',
    description TEXT COMMENT '分类描述',
    color_code VARCHAR(7) DEFAULT '#007bff' COMMENT '分类颜色',
    is_active BOOLEAN DEFAULT TRUE COMMENT '是否激活',
    blog_count INT DEFAULT 0 COMMENT '博客数量',
    sort_order INT DEFAULT 0 COMMENT '排序',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='分类表';

-- 标签表
CREATE TABLE IF NOT EXISTS tags (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE COMMENT '标签名称',
    slug VARCHAR(50) NOT NULL UNIQUE COMMENT '标签别名',
    description TEXT COMMENT '标签描述',
    color VARCHAR(7) DEFAULT '#6c757d' COMMENT '标签颜色',
    is_active BOOLEAN DEFAULT TRUE COMMENT '是否激活',
    usage_count INT DEFAULT 0 COMMENT '使用次数',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='标签表';

-- 文章表
CREATE TABLE IF NOT EXISTS articles (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL COMMENT '文章标题',
    content LONGTEXT NOT NULL COMMENT '文章内容',
    summary TEXT COMMENT '文章摘要',
    author_id BIGINT COMMENT '作者ID',
    author_name VARCHAR(100) COMMENT '作者名称',
    category_id BIGINT COMMENT '分类ID',
    category VARCHAR(100) COMMENT '分类名称',
    tags TEXT COMMENT '标签列表',
    images TEXT COMMENT '图片列表',
    is_published BOOLEAN DEFAULT FALSE COMMENT '是否发布',
    is_featured BOOLEAN DEFAULT FALSE COMMENT '是否推荐',
    view_count INT DEFAULT 0 COMMENT '浏览次数',
    like_count INT DEFAULT 0 COMMENT '点赞次数',
    comment_count INT DEFAULT 0 COMMENT '评论次数',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    published_at TIMESTAMP NULL COMMENT '发布时间',
    FOREIGN KEY (author_id) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL,
    INDEX idx_author_id (author_id),
    INDEX idx_category_id (category_id),
    INDEX idx_published (is_published),
    INDEX idx_created_at (created_at),
    INDEX idx_published_at (published_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='文章表';

-- 文章标签关联表
CREATE TABLE IF NOT EXISTS article_tags (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    article_id BIGINT NOT NULL COMMENT '文章ID',
    tag_id BIGINT NOT NULL COMMENT '标签ID',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    FOREIGN KEY (article_id) REFERENCES articles(id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE,
    UNIQUE KEY uk_article_tag (article_id, tag_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='文章标签关联表';

-- 评论表
CREATE TABLE IF NOT EXISTS comments (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    article_id BIGINT NOT NULL COMMENT '文章ID',
    user_id BIGINT COMMENT '用户ID',
    author_name VARCHAR(100) NOT NULL COMMENT '评论者姓名',
    author_email VARCHAR(100) COMMENT '评论者邮箱',
    content TEXT NOT NULL COMMENT '评论内容',
    parent_id BIGINT COMMENT '父评论ID',
    is_approved BOOLEAN DEFAULT TRUE COMMENT '是否审核通过',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (article_id) REFERENCES articles(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (parent_id) REFERENCES comments(id) ON DELETE CASCADE,
    INDEX idx_article_id (article_id),
    INDEX idx_user_id (user_id),
    INDEX idx_parent_id (parent_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='评论表';

-- 点赞表
CREATE TABLE IF NOT EXISTS likes (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    article_id BIGINT NOT NULL COMMENT '文章ID',
    user_id BIGINT COMMENT '用户ID',
    user_ip VARCHAR(45) COMMENT '用户IP',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    FOREIGN KEY (article_id) REFERENCES articles(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY uk_article_user (article_id, user_id),
    INDEX idx_article_id (article_id),
    INDEX idx_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='点赞表';

-- 访问日志表
CREATE TABLE IF NOT EXISTS access_logs (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT COMMENT '用户ID',
    ip_address VARCHAR(45) NOT NULL COMMENT 'IP地址',
    user_agent TEXT COMMENT '用户代理',
    request_url VARCHAR(500) NOT NULL COMMENT '请求URL',
    request_method VARCHAR(10) NOT NULL COMMENT '请求方法',
    response_status INT COMMENT '响应状态码',
    response_time INT COMMENT '响应时间(毫秒)',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_user_id (user_id),
    INDEX idx_ip_address (ip_address),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='访问日志表';

-- 系统配置表
CREATE TABLE IF NOT EXISTS system_configs (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    config_key VARCHAR(100) NOT NULL UNIQUE COMMENT '配置键',
    config_value TEXT COMMENT '配置值',
    description TEXT COMMENT '配置描述',
    is_public BOOLEAN DEFAULT FALSE COMMENT '是否公开',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统配置表';

-- 公告表
CREATE TABLE IF NOT EXISTS announcements (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL COMMENT '公告标题',
    content TEXT NOT NULL COMMENT '公告内容',
    is_published BOOLEAN DEFAULT FALSE COMMENT '是否发布',
    is_pinned BOOLEAN DEFAULT FALSE COMMENT '是否置顶',
    author_id BIGINT COMMENT '作者ID',
    author_name VARCHAR(100) COMMENT '作者名称',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    published_at TIMESTAMP NULL COMMENT '发布时间',
    FOREIGN KEY (author_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_published (is_published),
    INDEX idx_pinned (is_pinned),
    INDEX idx_published_at (published_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='公告表';

-- 插入基础数据

-- 插入系统配置数据
INSERT IGNORE INTO system_configs (config_key, config_value, description, is_public) VALUES
('site_name', '个人博客系统', '网站名称', true),
('site_description', '一个基于Spring Boot和Vue.js的现代化博客系统', '网站描述', true),
('site_keywords', '博客,技术分享,编程,开发', '网站关键词', true),
('admin_email', 'admin@blog.com', '管理员邮箱', false),
('allow_registration', 'true', '是否允许用户注册', false),
('comment_moderation', 'false', '评论是否需要审核', false),
('posts_per_page', '10', '每页显示文章数量', false),
('max_upload_size', '10485760', '最大上传文件大小(字节)', false);

-- 插入用户数据
INSERT IGNORE INTO users (id, account, username, email, password, full_name, bio, is_admin, is_active) VALUES
(1, 'admin', 'Admin', 'admin@blog.com', 'admin123', '系统管理员', '博客系统管理员，负责系统维护和内容管理。', true, true),
(2, 'blogger', 'Blogger', 'blogger@blog.com', 'blogger123', '博客作者', '热爱技术分享的全栈开发者，专注于Web开发和系统架构。', false, true),
(3, 'reader', 'Reader', 'reader@blog.com', 'reader123', '博客读者', '技术爱好者，喜欢阅读和学习新技术。', false, true);

-- 插入分类数据
INSERT IGNORE INTO categories (id, name, slug, description, color_code, is_active, blog_count, sort_order) VALUES
(1, '技术分享', 'tech-share', '技术相关的文章分享和经验交流', '#007bff', true, 0, 1),
(2, '前端开发', 'frontend', '前端开发技术、框架和最佳实践', '#28a745', true, 0, 2),
(3, '后端开发', 'backend', '后端开发技术、架构设计和性能优化', '#dc3545', true, 0, 3),
(4, '数据库', 'database', '数据库设计、优化和管理相关技术', '#ffc107', true, 0, 4),
(5, '运维部署', 'devops', '运维、部署和系统管理相关技术', '#6f42c1', true, 0, 5);

-- 插入标签数据
INSERT IGNORE INTO tags (id, name, slug, description, color, is_active, usage_count) VALUES
(1, 'Vue.js', 'vue-js', 'Vue.js前端框架', '#4FC08D', true, 0),
(2, 'React', 'react', 'React前端框架', '#61DAFB', true, 0),
(3, 'JavaScript', 'javascript', 'JavaScript编程语言', '#F7DF1E', true, 0),
(4, 'TypeScript', 'typescript', 'TypeScript编程语言', '#3178C6', true, 0),
(5, 'Java', 'java', 'Java编程语言', '#ED8B00', true, 0),
(6, 'Spring Boot', 'spring-boot', 'Spring Boot后端框架', '#6DB33F', true, 0),
(7, 'MySQL', 'mysql', 'MySQL关系型数据库', '#4479A1', true, 0),
(8, 'Redis', 'redis', 'Redis内存数据库', '#DC382D', true, 0),
(9, 'Docker', 'docker', 'Docker容器技术', '#2496ED', true, 0),
(10, 'Kubernetes', 'kubernetes', 'Kubernetes容器编排', '#326CE5', true, 0);

-- 插入文章数据
INSERT IGNORE INTO articles (id, title, content, summary, author_id, author_name, category_id, category, tags, is_published, view_count, like_count, created_at, published_at) VALUES
(1, 'Vue 3 Composition API 深入解析', 
'Vue 3 引入了 Composition API，这是一个全新的 API 设计，让我们能够更好地组织和复用代码逻辑。\n\n## 什么是 Composition API\n\nComposition API 是 Vue 3 中新增的一套 API，它提供了一种更灵活的方式来组织组件逻辑。与 Options API 不同，Composition API 允许我们将相关的逻辑组织在一起，而不是按照选项类型分离。\n\n## 基本用法\n\n```javascript\nimport { ref, computed, onMounted } from "vue"\n\nexport default {\n  setup() {\n    const count = ref(0)\n    const doubleCount = computed(() => count.value * 2)\n    \n    const increment = () => {\n      count.value++\n    }\n    \n    onMounted(() => {\n      console.log("组件已挂载")\n    })\n    \n    return {\n      count,\n      doubleCount,\n      increment\n    }\n  }\n}\n```\n\n## 优势\n\n1. **更好的逻辑复用**：可以将相关逻辑提取到可复用的函数中\n2. **更强的 TypeScript 支持**：类型推断更加准确\n3. **更灵活的代码组织**：相关逻辑可以组织在一起\n\n## 总结\n\nComposition API 为 Vue 3 带来了更强大的功能和更好的开发体验，值得深入学习和使用。',
'Vue 3 引入了 Composition API，这是一个全新的 API 设计，让我们能够更好地组织和复用代码逻辑。本文将深入解析 Composition API 的使用方法和优势。',
2, 'Blogger', 2, '前端开发', 'Vue.js,JavaScript', true, 1250, 25, '2024-01-15 10:00:00', '2024-01-15 10:00:00'),

(2, 'Spring Boot 微服务架构实践', 
'在现代软件开发中，微服务架构已经成为了主流的架构模式。Spring Boot 为我们提供了强大的工具来构建微服务应用。\n\n## 什么是微服务架构\n\n微服务架构是一种将单一应用程序开发为一组小型服务的方法，每个服务运行在自己的进程中，并使用轻量级机制（通常是 HTTP API）进行通信。\n\n## Spring Boot 在微服务中的优势\n\n1. **快速开发**：Spring Boot 的自动配置大大简化了开发过程\n2. **独立部署**：每个服务可以独立部署和扩展\n3. **多样化的技术栈**：不同服务可以使用不同的技术栈\n\n## 实践案例\n\n```java\n@RestController\n@RequestMapping("/api/users")\npublic class UserController {\n    \n    @Autowired\n    private UserService userService;\n    \n    @GetMapping("/{id}")\n    public ResponseEntity<User> getUser(@PathVariable Long id) {\n        User user = userService.findById(id);\n        return ResponseEntity.ok(user);\n    }\n    \n    @PostMapping\n    public ResponseEntity<User> createUser(@RequestBody User user) {\n        User savedUser = userService.save(user);\n        return ResponseEntity.status(HttpStatus.CREATED).body(savedUser);\n    }\n}\n```\n\n## 最佳实践\n\n1. **按业务能力拆分服务**\n2. **每个服务管理自己的数据**\n3. **实现熔断和降级机制**\n\n## 总结\n\n微服务架构虽然复杂，但带来的好处是显著的，值得在合适的场景下采用。',
'在现代软件开发中，微服务架构已经成为了主流的架构模式。本文将介绍如何使用 Spring Boot 构建微服务应用，包括最佳实践和实际案例。',
2, 'Blogger', 3, '后端开发', 'Spring Boot,Java', true, 980, 18, '2024-01-10 14:30:00', '2024-01-10 14:30:00'),

(3, 'MySQL 性能优化技巧', 
'数据库性能优化是后端开发中的重要技能。本文分享了一些实用的 MySQL 性能优化技巧。\n\n## 索引优化\n\n索引是提高查询性能的关键因素：\n\n```sql\n-- 创建复合索引\nCREATE INDEX idx_user_status_created ON users(status, created_at);\n\n-- 分析执行计划\nEXPLAIN SELECT * FROM users WHERE status = 1 ORDER BY created_at;\n```\n\n## 查询优化\n\n1. **避免 SELECT ***：只查询需要的字段\n2. **限制返回字段数量**\n3. **优化 WHERE 条件顺序**\n\n```sql\n-- 优化前\nSELECT * FROM articles WHERE title LIKE "%关键词%";\n\n-- 优化后\nSELECT id, title, summary FROM articles \nWHERE status = 1 AND title LIKE "关键词%"\nLIMIT 20;\n```\n\n## 配置优化\n\n常用的 MySQL 配置参数：\n\n```ini\n# 缓冲池大小\ninnodb_buffer_pool_size = 1G\n\n# 日志文件大小\ninnodb_log_file_size = 256M\n\n# 查询缓存\nquery_cache_size = 128M\n```\n\n## 监控和分析\n\n1. **使用 EXPLAIN 分析查询**\n2. **启用慢查询日志**\n3. **定期检查表结构**\n\n## 总结\n\n性能优化是一个持续的过程，需要根据实际情况不断调整。',
'数据库性能优化是后端开发中的重要技能。本文分享了 MySQL 性能优化的实用技巧，包括索引优化、查询优化和配置调优等方面。',
2, 'Blogger', 4, '数据库', 'MySQL,数据库', true, 756, 12, '2024-01-12 09:15:00', '2024-01-12 09:15:00');

-- 插入公告数据
INSERT IGNORE INTO announcements (id, title, content, is_published, is_pinned, created_at, updated_at, published_at, author_id, author_name) VALUES
(1, '欢迎来到博客系统', '欢迎大家使用我们的博客系统！这里是一个分享知识、交流经验的平台。希望大家能够在这里找到有价值的内容，也欢迎大家积极分享自己的见解和经验。', true, true, '2024-01-01 10:00:00', '2024-01-01 10:00:00', '2024-01-01 10:00:00', 1, 'Admin'),
(2, '系统功能介绍', '我们的博客系统支持文章发布、分类管理、标签系统、评论互动等功能。用户可以注册账号后发布自己的文章，也可以对其他用户的文章进行评论和点赞。管理员可以对系统进行全面的管理和维护。', true, false, '2024-01-02 14:30:00', '2024-01-02 14:30:00', '2024-01-02 14:30:00', 1, 'Admin');

-- 更新标签使用次数
UPDATE tags SET usage_count = (
    SELECT COUNT(*) FROM articles 
    WHERE articles.tags LIKE CONCAT('%', tags.name, '%') 
    AND articles.is_published = true
) WHERE id IN (1,2,3,4,5,6,7,8,9,10);

-- 更新分类文章数量
UPDATE categories SET blog_count = (
    SELECT COUNT(*) FROM articles 
    WHERE articles.category_id = categories.id 
    AND articles.is_published = true
) WHERE id IN (1,2,3,4,5);

-- 重新启用外键检查
SET FOREIGN_KEY_CHECKS = 1;
