-- 博客系统数据库初始化脚本
-- 创建数据库表结构

-- 用户表
CREATE TABLE IF NOT EXISTS users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    account VARCHAR(50) NOT NULL UNIQUE COMMENT '账号',
    username VARCHAR(50) NOT NULL COMMENT '用户名',
    email VARCHAR(100) UNIQUE COMMENT '邮箱',
    password VARCHAR(255) NOT NULL COMMENT '密码',
    full_name VARCHAR(100) COMMENT '真实姓名',
    bio TEXT COMMENT '个人简介',
    avatar_url VARCHAR(255) COMMENT '头像URL',
    is_admin BOOLEAN DEFAULT FALSE COMMENT '是否为管理员',
    is_active BOOLEAN DEFAULT TRUE COMMENT '是否激活',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_account (account),
    INDEX idx_email (email),
    INDEX idx_is_admin (is_admin)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';

-- 博客文章表
CREATE TABLE IF NOT EXISTS blogs (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL COMMENT '标题',
    content LONGTEXT NOT NULL COMMENT '内容',
    summary TEXT COMMENT '摘要',
    author_name VARCHAR(100) NOT NULL COMMENT '作者名称',
    category VARCHAR(50) COMMENT '分类',
    tags VARCHAR(500) COMMENT '标签，逗号分隔',
    is_published BOOLEAN DEFAULT FALSE COMMENT '是否发布',
    view_count INT DEFAULT 0 COMMENT '浏览次数',
    like_count INT DEFAULT 0 COMMENT '点赞次数',
    comment_count INT DEFAULT 0 COMMENT '评论次数',
    featured_image VARCHAR(255) COMMENT '特色图片URL',
    images TEXT COMMENT '文章图片列表，JSON格式',
    meta_description VARCHAR(300) COMMENT 'SEO描述',
    meta_keywords VARCHAR(200) COMMENT 'SEO关键词',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    published_at TIMESTAMP NULL COMMENT '发布时间',
    INDEX idx_title (title),
    INDEX idx_author (author_name),
    INDEX idx_category (category),
    INDEX idx_published (is_published),
    INDEX idx_created_at (created_at),
    INDEX idx_published_at (published_at),
    FULLTEXT idx_content (title, content, summary)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='博客文章表';

-- 评论表
CREATE TABLE IF NOT EXISTS comments (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    blog_id BIGINT NOT NULL COMMENT '博客ID',
    user_id BIGINT NULL COMMENT '用户ID（注册用户）',
    parent_id BIGINT NULL COMMENT '父评论ID（回复）',
    author_name VARCHAR(100) NOT NULL COMMENT '评论者姓名',
    author_email VARCHAR(100) NOT NULL COMMENT '评论者邮箱',
    author_website VARCHAR(255) COMMENT '评论者网站',
    content TEXT NOT NULL COMMENT '评论内容',
    images TEXT COMMENT '评论图片列表，JSON格式存储',
    reply_to_name VARCHAR(100) COMMENT '被回复的用户名',
    is_approved BOOLEAN DEFAULT FALSE COMMENT '是否审核通过',
    ip_address VARCHAR(45) COMMENT 'IP地址',
    user_agent TEXT COMMENT '用户代理',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_blog_id (blog_id),
    INDEX idx_user_id (user_id),
    INDEX idx_parent_id (parent_id),
    INDEX idx_approved (is_approved),
    INDEX idx_created_at (created_at),
    FOREIGN KEY (blog_id) REFERENCES blogs(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (parent_id) REFERENCES comments(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='评论表';

-- 标签表（可选，用于标签管理）
CREATE TABLE IF NOT EXISTS tags (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE COMMENT '标签名称',
    slug VARCHAR(50) NOT NULL UNIQUE COMMENT '标签别名',
    description TEXT COMMENT '标签描述',
    color VARCHAR(7) DEFAULT '#007bff' COMMENT '标签颜色',
    usage_count INT DEFAULT 0 COMMENT '使用次数',
    is_active BOOLEAN DEFAULT TRUE COMMENT '是否激活',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_name (name),
    INDEX idx_slug (slug),
    INDEX idx_usage_count (usage_count),
    INDEX idx_is_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='标签表';

-- 博客标签关联表
CREATE TABLE IF NOT EXISTS blog_tags (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    blog_id BIGINT NOT NULL COMMENT '博客ID',
    tag_id BIGINT NOT NULL COMMENT '标签ID',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    UNIQUE KEY uk_blog_tag (blog_id, tag_id),
    INDEX idx_blog_id (blog_id),
    INDEX idx_tag_id (tag_id),
    FOREIGN KEY (blog_id) REFERENCES blogs(id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='博客标签关联表';

-- 分类表（可选，用于分类管理）
CREATE TABLE IF NOT EXISTS categories (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE COMMENT '分类名称',
    slug VARCHAR(50) NOT NULL UNIQUE COMMENT '分类别名',
    description TEXT COMMENT '分类描述',
    parent_id BIGINT NULL COMMENT '父分类ID',
    sort_order INT DEFAULT 0 COMMENT '排序',
    is_active BOOLEAN DEFAULT TRUE COMMENT '是否启用',
    blog_count INT DEFAULT 0 COMMENT '文章数量',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_name (name),
    INDEX idx_slug (slug),
    INDEX idx_parent_id (parent_id),
    INDEX idx_sort_order (sort_order),
    FOREIGN KEY (parent_id) REFERENCES categories(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='分类表';

-- 系统配置表
CREATE TABLE IF NOT EXISTS system_configs (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    config_key VARCHAR(100) NOT NULL UNIQUE COMMENT '配置键',
    config_value TEXT COMMENT '配置值',
    config_type VARCHAR(20) DEFAULT 'string' COMMENT '配置类型',
    description VARCHAR(255) COMMENT '配置描述',
    is_public BOOLEAN DEFAULT FALSE COMMENT '是否公开',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_config_key (config_key),
    INDEX idx_is_public (is_public)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统配置表';

-- 访问日志表（可选，用于统计分析）
CREATE TABLE IF NOT EXISTS access_logs (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NULL COMMENT '用户ID',
    blog_id BIGINT NULL COMMENT '博客ID',
    ip_address VARCHAR(45) NOT NULL COMMENT 'IP地址',
    user_agent TEXT COMMENT '用户代理',
    request_url VARCHAR(500) COMMENT '请求URL',
    request_method VARCHAR(10) COMMENT '请求方法',
    referer VARCHAR(500) COMMENT '来源页面',
    response_time INT COMMENT '响应时间(ms)',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '访问时间',
    INDEX idx_user_id (user_id),
    INDEX idx_blog_id (blog_id),
    INDEX idx_ip_address (ip_address),
    INDEX idx_created_at (created_at),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (blog_id) REFERENCES blogs(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='访问日志表';

-- 用户点赞记录表
CREATE TABLE IF NOT EXISTS user_likes (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL COMMENT '用户ID',
    blog_id BIGINT NOT NULL COMMENT '博客ID',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '点赞时间',
    UNIQUE KEY uk_user_blog (user_id, blog_id),
    INDEX idx_user_id (user_id),
    INDEX idx_blog_id (blog_id),
    INDEX idx_created_at (created_at),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (blog_id) REFERENCES blogs(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户点赞记录表';