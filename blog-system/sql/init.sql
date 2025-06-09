-- 博客系统数据库初始化脚本
-- 用于 Docker 容器化部署时自动初始化数据库

-- 设置字符集
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- 创建数据库（如果不存在）
CREATE DATABASE IF NOT EXISTS `blog_system` 
DEFAULT CHARACTER SET utf8mb4 
DEFAULT COLLATE utf8mb4_unicode_ci;

USE `blog_system`;

-- 用户表
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(50) NOT NULL COMMENT '用户名',
  `email` varchar(100) NOT NULL COMMENT '邮箱',
  `password` varchar(255) NOT NULL COMMENT '密码（加密）',
  `nickname` varchar(50) DEFAULT NULL COMMENT '昵称',
  `avatar` varchar(255) DEFAULT NULL COMMENT '头像URL',
  `bio` text COMMENT '个人简介',
  `role` enum('USER','ADMIN') NOT NULL DEFAULT 'USER' COMMENT '用户角色',
  `status` enum('ACTIVE','INACTIVE','BANNED') NOT NULL DEFAULT 'ACTIVE' COMMENT '用户状态',
  `email_verified` tinyint(1) NOT NULL DEFAULT '0' COMMENT '邮箱是否验证',
  `last_login_time` datetime DEFAULT NULL COMMENT '最后登录时间',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`),
  UNIQUE KEY `uk_email` (`email`),
  KEY `idx_role` (`role`),
  KEY `idx_status` (`status`),
  KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';

-- 分类表
DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `name` varchar(50) NOT NULL COMMENT '分类名称',
  `description` text COMMENT '分类描述',
  `color` varchar(7) DEFAULT '#007bff' COMMENT '分类颜色',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '排序顺序',
  `status` enum('ACTIVE','INACTIVE') NOT NULL DEFAULT 'ACTIVE' COMMENT '分类状态',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_name` (`name`),
  KEY `idx_status` (`status`),
  KEY `idx_sort_order` (`sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='分类表';

-- 标签表
DROP TABLE IF EXISTS `tags`;
CREATE TABLE `tags` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '标签ID',
  `name` varchar(30) NOT NULL COMMENT '标签名称',
  `color` varchar(7) DEFAULT '#6c757d' COMMENT '标签颜色',
  `usage_count` int NOT NULL DEFAULT '0' COMMENT '使用次数',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_name` (`name`),
  KEY `idx_usage_count` (`usage_count`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='标签表';

-- 文章表
DROP TABLE IF EXISTS `articles`;
CREATE TABLE `articles` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '文章ID',
  `title` varchar(200) NOT NULL COMMENT '文章标题',
  `content` longtext NOT NULL COMMENT '文章内容',
  `summary` text COMMENT '文章摘要',
  `cover_image` varchar(255) DEFAULT NULL COMMENT '封面图片URL',
  `author_id` bigint NOT NULL COMMENT '作者ID',
  `category_id` bigint DEFAULT NULL COMMENT '分类ID',
  `status` enum('DRAFT','PUBLISHED','ARCHIVED') NOT NULL DEFAULT 'DRAFT' COMMENT '文章状态',
  `is_top` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否置顶',
  `allow_comment` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否允许评论',
  `view_count` int NOT NULL DEFAULT '0' COMMENT '浏览次数',
  `like_count` int NOT NULL DEFAULT '0' COMMENT '点赞次数',
  `comment_count` int NOT NULL DEFAULT '0' COMMENT '评论次数',
  `published_at` datetime DEFAULT NULL COMMENT '发布时间',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_author_id` (`author_id`),
  KEY `idx_category_id` (`category_id`),
  KEY `idx_status` (`status`),
  KEY `idx_is_top` (`is_top`),
  KEY `idx_published_at` (`published_at`),
  KEY `idx_view_count` (`view_count`),
  KEY `idx_like_count` (`like_count`),
  CONSTRAINT `fk_articles_author` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_articles_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='文章表';

-- 文章标签关联表
DROP TABLE IF EXISTS `article_tags`;
CREATE TABLE `article_tags` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '关联ID',
  `article_id` bigint NOT NULL COMMENT '文章ID',
  `tag_id` bigint NOT NULL COMMENT '标签ID',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_article_tag` (`article_id`,`tag_id`),
  KEY `idx_tag_id` (`tag_id`),
  CONSTRAINT `fk_article_tags_article` FOREIGN KEY (`article_id`) REFERENCES `articles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_article_tags_tag` FOREIGN KEY (`tag_id`) REFERENCES `tags` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='文章标签关联表';

-- 评论表
DROP TABLE IF EXISTS `comments`;
CREATE TABLE `comments` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '评论ID',
  `article_id` bigint NOT NULL COMMENT '文章ID',
  `user_id` bigint NOT NULL COMMENT '评论用户ID',
  `parent_id` bigint DEFAULT NULL COMMENT '父评论ID（回复）',
  `content` text NOT NULL COMMENT '评论内容',
  `status` enum('PENDING','APPROVED','REJECTED') NOT NULL DEFAULT 'APPROVED' COMMENT '评论状态',
  `like_count` int NOT NULL DEFAULT '0' COMMENT '点赞次数',
  `ip_address` varchar(45) DEFAULT NULL COMMENT 'IP地址',
  `user_agent` varchar(500) DEFAULT NULL COMMENT '用户代理',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_article_id` (`article_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_parent_id` (`parent_id`),
  KEY `idx_status` (`status`),
  KEY `idx_created_at` (`created_at`),
  CONSTRAINT `fk_comments_article` FOREIGN KEY (`article_id`) REFERENCES `articles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_comments_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_comments_parent` FOREIGN KEY (`parent_id`) REFERENCES `comments` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='评论表';

-- 点赞表
DROP TABLE IF EXISTS `likes`;
CREATE TABLE `likes` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '点赞ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `target_type` enum('ARTICLE','COMMENT') NOT NULL COMMENT '点赞目标类型',
  `target_id` bigint NOT NULL COMMENT '目标ID',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_target` (`user_id`,`target_type`,`target_id`),
  KEY `idx_target` (`target_type`,`target_id`),
  CONSTRAINT `fk_likes_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='点赞表';

-- 访问日志表
DROP TABLE IF EXISTS `access_logs`;
CREATE TABLE `access_logs` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `user_id` bigint DEFAULT NULL COMMENT '用户ID（可为空）',
  `ip_address` varchar(45) NOT NULL COMMENT 'IP地址',
  `user_agent` varchar(500) DEFAULT NULL COMMENT '用户代理',
  `request_method` varchar(10) NOT NULL COMMENT '请求方法',
  `request_url` varchar(500) NOT NULL COMMENT '请求URL',
  `response_status` int NOT NULL COMMENT '响应状态码',
  `response_time` int DEFAULT NULL COMMENT '响应时间（毫秒）',
  `referer` varchar(500) DEFAULT NULL COMMENT '来源页面',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '访问时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_ip_address` (`ip_address`),
  KEY `idx_created_at` (`created_at`),
  KEY `idx_response_status` (`response_status`),
  CONSTRAINT `fk_access_logs_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='访问日志表';

-- 系统配置表
DROP TABLE IF EXISTS `system_configs`;
CREATE TABLE `system_configs` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '配置ID',
  `config_key` varchar(100) NOT NULL COMMENT '配置键',
  `config_value` text COMMENT '配置值',
  `config_type` enum('STRING','NUMBER','BOOLEAN','JSON') NOT NULL DEFAULT 'STRING' COMMENT '配置类型',
  `description` varchar(255) DEFAULT NULL COMMENT '配置描述',
  `is_public` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否公开（前端可访问）',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_config_key` (`config_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统配置表';

-- 插入默认数据

-- 默认管理员用户（密码：admin123）
INSERT INTO `users` (`username`, `email`, `password`, `nickname`, `role`, `status`, `email_verified`) VALUES
('admin', 'admin@blog.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iKXIGfR8f5Ym0.1.1.1.1.1.1.1.1', '系统管理员', 'ADMIN', 'ACTIVE', 1);

-- 默认分类
INSERT INTO `categories` (`name`, `description`, `color`, `sort_order`) VALUES
('技术分享', '分享技术相关的文章和经验', '#007bff', 1),
('生活随笔', '记录生活中的点点滴滴', '#28a745', 2),
('学习笔记', '学习过程中的笔记和总结', '#ffc107', 3),
('项目实战', '实际项目开发经验分享', '#dc3545', 4);

-- 默认标签
INSERT INTO `tags` (`name`, `color`) VALUES
('Java', '#f89820'),
('Spring Boot', '#6db33f'),
('Vue.js', '#4fc08d'),
('MySQL', '#4479a1'),
('Docker', '#2496ed'),
('前端', '#61dafb'),
('后端', '#68217a'),
('全栈', '#ff6b6b');

-- 默认系统配置
INSERT INTO `system_configs` (`config_key`, `config_value`, `config_type`, `description`, `is_public`) VALUES
('site.title', '我的博客系统', 'STRING', '网站标题', 1),
('site.description', '一个基于Spring Boot和Vue.js的现代化博客系统', 'STRING', '网站描述', 1),
('site.keywords', '博客,技术分享,Spring Boot,Vue.js', 'STRING', '网站关键词', 1),
('site.author', '博客管理员', 'STRING', '网站作者', 1),
('site.icp', '', 'STRING', 'ICP备案号', 1),
('upload.max_size', '10485760', 'NUMBER', '文件上传最大大小（字节）', 0),
('upload.allowed_types', 'jpg,jpeg,png,gif,pdf,doc,docx', 'STRING', '允许上传的文件类型', 0),
('comment.auto_approve', 'true', 'BOOLEAN', '评论是否自动审核通过', 0),
('comment.max_length', '1000', 'NUMBER', '评论最大长度', 0);

SET FOREIGN_KEY_CHECKS = 1;

-- 创建索引优化查询性能
CREATE INDEX idx_articles_status_published ON articles(status, published_at DESC);
CREATE INDEX idx_articles_author_status ON articles(author_id, status);
CREATE INDEX idx_comments_article_status ON comments(article_id, status, created_at DESC);

-- 输出初始化完成信息
SELECT '数据库初始化完成！' as message;
SELECT CONCAT('默认管理员账号: admin, 密码: admin123') as admin_info;