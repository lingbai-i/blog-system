-- 博客系统数据库初始化脚本（完整版）
-- 该文件包含完整的表结构创建和初始数据插入
-- 仅在项目首次部署时使用

-- 创建数据库
CREATE DATABASE IF NOT EXISTS blog_system DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE blog_system;

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

-- 公告表
CREATE TABLE IF NOT EXISTS announcements (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL COMMENT '公告标题',
    content TEXT NOT NULL COMMENT '公告内容',
    is_published BOOLEAN DEFAULT FALSE COMMENT '是否发布',
    is_pinned BOOLEAN DEFAULT FALSE COMMENT '是否置顶',
    author_id BIGINT NOT NULL COMMENT '作者ID',
    author_name VARCHAR(100) NOT NULL COMMENT '作者名称',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    published_at TIMESTAMP NULL COMMENT '发布时间',
    INDEX idx_title (title),
    INDEX idx_author_id (author_id),
    INDEX idx_published (is_published),
    INDEX idx_pinned (is_pinned),
    INDEX idx_created_at (created_at),
    FOREIGN KEY (author_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='公告表';

-- ========================================
-- 初始数据插入（仅在首次部署时执行）
-- ========================================

-- 插入系统配置数据
INSERT IGNORE INTO system_configs (config_key, config_value, description, is_public) VALUES
('site_name', '个人博客系统', '网站名称', true),
('site_description', '一个基于Spring Boot和Vue.js的现代化博客系统', '网站描述', true),
('site_keywords', '博客,技术分享,编程,开发', '网站关键词', true),
('admin_email', 'admin@blog.com', '管理员邮箱', true),
('allow_registration', 'true', '是否允许用户注册', true),
('comment_moderation', 'false', '评论是否需要审核', true),
('posts_per_page', '10', '每页显示文章数量', true),
('max_upload_size', '10485760', '最大上传文件大小(字节)', true);

-- 插入用户数据（包含更多示例用户）
INSERT IGNORE INTO users (id, account, username, email, password, full_name, bio, avatar_url, is_admin, is_active) VALUES
(1, 'admin', 'Admin', 'admin@blog.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa', '系统管理员', '博客系统管理员，负责系统维护和内容管理。', '/uploads/avatars/admin.png', true, true),
(2, 'frontend', 'Frontend', 'frontend@blog.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa', '前端工程师', '专注于前端开发，熟悉Vue.js、React等现代前端框架。精通HTML5、CSS3、JavaScript，有丰富的移动端开发经验。', '/uploads/avatars/frontend.png', false, true),
(3, 'backend', 'Backend', 'backend@blog.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa', '后端工程师', '后端开发专家，精通Spring Boot、数据库设计和系统优化。擅长微服务架构设计和高并发系统开发。', '/uploads/avatars/backend.png', false, true),
(4, 'database', 'Database', 'database@blog.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa', '数据库专家', '数据库架构师，专注于数据库设计、性能优化和数据安全。熟悉MySQL、PostgreSQL、Redis等数据库技术。', '/uploads/avatars/database.png', false, true),
(5, 'devops', 'DevOps', 'devops@blog.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa', '运维工程师', 'DevOps工程师，专注于自动化部署、容器化和云原生技术。熟悉Docker、Kubernetes、CI/CD等技术栈。', '/uploads/avatars/devops.png', false, true),
(6, 'dataanalyst', 'DataAnalyst', 'dataanalyst@blog.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa', '数据分析师', '数据科学家，专注于数据挖掘、机器学习和数据可视化。熟悉Python、R、SQL等数据分析工具。', '/uploads/avatars/dataanalyst.png', false, true),
(7, 'designer', 'Designer', 'designer@blog.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa', 'UI/UX设计师', 'UI/UX设计师，专注于用户体验设计和界面设计。熟悉Figma、Sketch、Adobe Creative Suite等设计工具。', '/uploads/avatars/designer.png', false, true),
(8, 'tester', 'Tester', 'tester@blog.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa', '测试工程师', '软件测试工程师，专注于自动化测试、性能测试和质量保证。熟悉Selenium、JMeter等测试工具。', '/uploads/avatars/tester.png', false, true),
(9, 'product', 'Product', 'product@blog.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa', '产品经理', '产品经理，负责产品规划、需求分析和用户体验优化。具有敏锐的市场洞察力和优秀的沟通协调能力。', '/uploads/avatars/product.png', false, true),
(10, 'marketing', 'Marketing', 'marketing@blog.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa', '市场专员', '数字营销专家，专注于内容营销、社交媒体运营和品牌推广。熟悉SEO、SEM、数据分析等营销技术。', '/uploads/avatars/marketing.png', false, true);

-- 插入分类数据（扩展分类选项）
INSERT IGNORE INTO categories (id, name, slug, description, is_active, blog_count, sort_order) VALUES
(1, '技术分享', 'tech-share', '技术相关的文章分享和经验交流', true, 0, 1),
(2, '前端开发', 'frontend', '前端开发技术、框架和最佳实践', true, 0, 2),
(3, '后端开发', 'backend', '后端开发技术、架构设计和性能优化', true, 0, 3),
(4, '数据库', 'database', '数据库设计、优化和管理相关技术', true, 0, 4),
(5, '移动开发', 'mobile', '移动应用开发技术和跨平台解决方案', true, 0, 5),
(6, '云计算', 'cloud', '云计算、容器化和微服务架构', true, 0, 6),
(7, '人工智能', 'ai', '人工智能、机器学习和深度学习', true, 0, 7),
(8, '算法与数据结构', 'algorithm', '算法设计、数据结构和编程竞赛', true, 0, 8),
(9, '项目实战', 'project', '实际项目开发经验和案例分析', true, 0, 9),
(10, '学习笔记', 'study-notes', '学习过程中的笔记和知识总结', true, 0, 10),
(11, '工具推荐', 'tools', '开发工具、软件推荐和使用技巧', true, 0, 11),
(12, '职场发展', 'career', '职业发展、面试经验和技能提升', true, 0, 12),
(13, '开源项目', 'opensource', '开源项目介绍、贡献和维护经验', true, 0, 13),
(14, '生活随笔', 'life', '生活感悟、思考和非技术类内容', true, 0, 14),
(15, '行业动态', 'industry', '技术行业新闻、趋势和发展动态', true, 0, 15);

-- 插入标签数据（扩展技术标签）
INSERT IGNORE INTO tags (id, name, slug, description, color, is_active, usage_count) VALUES
-- 前端技术标签
(1, 'Vue.js', 'vue-js', 'Vue.js前端框架', '#4FC08D', true, 0),
(2, 'React', 'react', 'React前端框架', '#61DAFB', true, 0),
(3, 'Angular', 'angular', 'Angular前端框架', '#DD0031', true, 0),
(4, 'JavaScript', 'javascript', 'JavaScript编程语言', '#F7DF1E', true, 0),
(5, 'TypeScript', 'typescript', 'TypeScript编程语言', '#3178C6', true, 0),
(6, 'HTML5', 'html5', 'HTML5标记语言', '#E34F26', true, 0),
(7, 'CSS3', 'css3', 'CSS3样式表语言', '#1572B6', true, 0),
(8, 'Sass', 'sass', 'Sass CSS预处理器', '#CC6699', true, 0),
(9, 'Less', 'less', 'Less CSS预处理器', '#1D365D', true, 0),
(10, 'Webpack', 'webpack', 'Webpack模块打包工具', '#8DD6F9', true, 0),
(11, 'Vite', 'vite', 'Vite构建工具', '#646CFF', true, 0),
(12, 'Node.js', 'nodejs', 'Node.js运行时环境', '#339933', true, 0),
-- 后端技术标签
(13, 'Java', 'java', 'Java编程语言', '#007396', true, 0),
(14, 'Spring Boot', 'spring-boot', 'Spring Boot框架', '#6DB33F', true, 0),
(15, 'Spring', 'spring', 'Spring框架', '#6DB33F', true, 0),
(16, 'Python', 'python', 'Python编程语言', '#3776AB', true, 0),
(17, 'Django', 'django', 'Django Web框架', '#092E20', true, 0),
(18, 'Flask', 'flask', 'Flask微框架', '#000000', true, 0),
(19, 'Go', 'golang', 'Go编程语言', '#00ADD8', true, 0),
(20, 'Rust', 'rust', 'Rust编程语言', '#000000', true, 0),
(21, 'C++', 'cpp', 'C++编程语言', '#00599C', true, 0),
(22, 'C#', 'csharp', 'C#编程语言', '#239120', true, 0),
(23, '.NET', 'dotnet', '.NET框架', '#512BD4', true, 0),
-- 数据库技术标签
(24, 'MySQL', 'mysql', 'MySQL关系型数据库', '#4479A1', true, 0),
(25, 'PostgreSQL', 'postgresql', 'PostgreSQL关系型数据库', '#336791', true, 0),
(26, 'MongoDB', 'mongodb', 'MongoDB文档数据库', '#47A248', true, 0),
(27, 'Redis', 'redis', 'Redis内存数据库', '#DC382D', true, 0),
(28, 'Elasticsearch', 'elasticsearch', 'Elasticsearch搜索引擎', '#005571', true, 0),
-- 云计算和容器技术标签
(29, 'Docker', 'docker', 'Docker容器技术', '#2496ED', true, 0),
(30, 'Kubernetes', 'kubernetes', 'Kubernetes容器编排', '#326CE5', true, 0),
(31, 'AWS', 'aws', 'Amazon Web Services', '#FF9900', true, 0),
(32, 'Azure', 'azure', 'Microsoft Azure', '#0078D4', true, 0),
(33, '阿里云', 'aliyun', '阿里云服务', '#FF6A00', true, 0),
(34, '腾讯云', 'tencent-cloud', '腾讯云服务', '#006EFF', true, 0),
-- 移动开发技术标签
(35, 'Android', 'android', 'Android移动开发', '#3DDC84', true, 0),
(36, 'iOS', 'ios', 'iOS移动开发', '#000000', true, 0),
(37, 'React Native', 'react-native', 'React Native跨平台开发', '#61DAFB', true, 0),
(38, 'Flutter', 'flutter', 'Flutter跨平台开发', '#02569B', true, 0),
(39, 'Kotlin', 'kotlin', 'Kotlin编程语言', '#7F52FF', true, 0),
(40, 'Swift', 'swift', 'Swift编程语言', '#FA7343', true, 0),
-- 工具和平台标签
(41, 'Git', 'git', 'Git版本控制', '#F05032', true, 0),
(42, 'GitHub', 'github', 'GitHub代码托管', '#181717', true, 0),
(43, 'GitLab', 'gitlab', 'GitLab代码托管', '#FC6D26', true, 0),
(44, 'Jenkins', 'jenkins', 'Jenkins持续集成', '#D33833', true, 0),
(45, 'Linux', 'linux', 'Linux操作系统', '#FCC624', true, 0),
(46, 'Ubuntu', 'ubuntu', 'Ubuntu操作系统', '#E95420', true, 0),
(47, 'CentOS', 'centos', 'CentOS操作系统', '#262577', true, 0),
-- 概念和方法论标签
(48, '微服务', 'microservices', '微服务架构', '#007ACC', true, 0),
(49, 'RESTful API', 'restful-api', 'RESTful API设计', '#009688', true, 0),
(50, 'GraphQL', 'graphql', 'GraphQL查询语言', '#E10098', true, 0),
(51, '性能优化', 'performance', '性能优化技术', '#FF5722', true, 0),
(52, '安全', 'security', '信息安全技术', '#F44336', true, 0),
(53, '测试', 'testing', '软件测试技术', '#4CAF50', true, 0),
(54, '部署', 'deployment', '应用部署技术', '#2196F3', true, 0),
(55, '监控', 'monitoring', '系统监控技术', '#FF9800', true, 0),
(56, '架构设计', 'architecture', '系统架构设计', '#9C27B0', true, 0),
(57, '算法', 'algorithm', '算法和数据结构', '#607D8B', true, 0),
(58, '机器学习', 'machine-learning', '机器学习技术', '#795548', true, 0),
(59, '人工智能', 'artificial-intelligence', '人工智能技术', '#3F51B5', true, 0),
(60, '数据分析', 'data-analysis', '数据分析技术', '#009688', true, 0);

-- 插入博客文章数据
INSERT IGNORE INTO blogs (id, title, content, summary, author_name, category, tags, is_published, view_count, like_count, created_at, updated_at, published_at) VALUES
(1, 'Vue 3 Composition API 深入解析', 
'Vue 3 引入了 Composition API，这是一个全新的 API 设计，为组件逻辑提供了更好的组织方式。\n\n## Composition API 的优势\n\n### 1. 更好的逻辑复用\n\n```javascript\nimport { ref, computed, onMounted } from "vue"\n\nexport function useCounter() {\n  const count = ref(0)\n  const doubleCount = computed(() => count.value * 2)\n  \n  function increment() {\n    count.value++\n  }\n  \n  return {\n    count,\n    doubleCount,\n    increment\n  }\n}\n```\n\n### 2. 更好的 TypeScript 支持\n\nComposition API 天然支持 TypeScript，提供了更好的类型推断。\n\n### 3. 更灵活的组件组织\n\n```javascript\nexport default {\n  setup() {\n    // 用户相关逻辑\n    const { user, login, logout } = useUser()\n    \n    // 购物车相关逻辑\n    const { cart, addToCart, removeFromCart } = useCart()\n    \n    return {\n      user,\n      login,\n      logout,\n      cart,\n      addToCart,\n      removeFromCart\n    }\n  }\n}\n```\n\n## 响应式系统\n\nVue 3 的响应式系统基于 Proxy，提供了更好的性能和更完整的拦截能力。\n\n### ref 和 reactive\n\n```javascript\nimport { ref, reactive } from "vue"\n\n// 基本类型使用 ref\nconst count = ref(0)\nconst message = ref("Hello")\n\n// 对象类型使用 reactive\nconst state = reactive({\n  user: {\n    name: "张三",\n    age: 25\n  },\n  posts: []\n})\n```\n\n## 生命周期钩子\n\n```javascript\nimport { onMounted, onUpdated, onUnmounted } from "vue"\n\nexport default {\n  setup() {\n    onMounted(() => {\n      console.log("组件已挂载")\n    })\n    \n    onUpdated(() => {\n      console.log("组件已更新")\n    })\n    \n    onUnmounted(() => {\n      console.log("组件即将卸载")\n    })\n  }\n}\n```\n\nComposition API 为 Vue 3 带来了更强大的功能和更好的开发体验。',
'Vue 3 Composition API 是一个革命性的功能，本文深入解析其核心概念、使用方法和最佳实践。',
'Frontend', '前端开发', 'Vue.js,JavaScript,前端开发', true, 1234, 89, '2024-01-15 10:30:00', '2024-01-15 10:30:00', '2024-01-15 10:30:00'),

(2, 'Spring Boot 微服务架构实践', 
'微服务架构已经成为现代应用开发的主流模式，Spring Boot 为微服务开发提供了强大的支持。\n\n## 微服务架构概述\n\n微服务架构将单一应用程序分解为一套小型服务，每个服务运行在自己的进程中，通过轻量级机制（通常是 HTTP API）进行通信。\n\n### 微服务的优势\n\n1. **独立部署**：每个服务可以独立部署和扩展\n2. **技术多样性**：不同服务可以使用不同的技术栈\n3. **故障隔离**：单个服务的故障不会影响整个系统\n4. **团队自治**：小团队可以独立开发和维护服务\n\n## Spring Boot 微服务实现\n\n### 1. 服务注册与发现\n\n```java\n@SpringBootApplication\n@EnableEurekaClient\npublic class UserServiceApplication {\n    public static void main(String[] args) {\n        SpringApplication.run(UserServiceApplication.class, args);\n    }\n}\n```\n\n### 2. 配置中心\n\n```yaml\nspring:\n  application:\n    name: user-service\n  cloud:\n    config:\n      uri: http://config-server:8888\n      profile: dev\n```\n\n### 3. 服务间通信\n\n```java\n@RestController\npublic class UserController {\n    \n    @Autowired\n    private OrderServiceClient orderServiceClient;\n    \n    @GetMapping("/users/{id}/orders")\n    public List<Order> getUserOrders(@PathVariable Long id) {\n        return orderServiceClient.getOrdersByUserId(id);\n    }\n}\n\n@FeignClient("order-service")\npublic interface OrderServiceClient {\n    @GetMapping("/orders/user/{userId}")\n    List<Order> getOrdersByUserId(@PathVariable Long userId);\n}\n```\n\n### 4. 断路器模式\n\n```java\n@Component\npublic class OrderServiceFallback implements OrderServiceClient {\n    \n    @Override\n    public List<Order> getOrdersByUserId(Long userId) {\n        return Collections.emptyList();\n    }\n}\n```\n\n## 数据管理\n\n### 数据库分离\n\n每个微服务应该有自己的数据库，避免服务间的数据耦合。\n\n```java\n@Entity\n@Table(name = "users")\npublic class User {\n    @Id\n    @GeneratedValue(strategy = GenerationType.IDENTITY)\n    private Long id;\n    \n    private String username;\n    private String email;\n    \n    // getters and setters\n}\n```\n\n### 分布式事务\n\n```java\n@Service\n@Transactional\npublic class OrderService {\n    \n    @Autowired\n    private PaymentServiceClient paymentServiceClient;\n    \n    public void createOrder(Order order) {\n        // 创建订单\n        orderRepository.save(order);\n        \n        // 调用支付服务\n        paymentServiceClient.processPayment(order.getPaymentInfo());\n    }\n}\n```\n\n## 监控和日志\n\n### 分布式追踪\n\n```java\n@RestController\npublic class UserController {\n    \n    private static final Logger logger = LoggerFactory.getLogger(UserController.class);\n    \n    @GetMapping("/users/{id}")\n    public User getUser(@PathVariable Long id) {\n        logger.info("Getting user with id: {}", id);\n        return userService.findById(id);\n    }\n}\n```\n\n微服务架构虽然带来了很多好处，但也增加了系统的复杂性。在实施时需要考虑服务拆分、数据一致性、网络延迟等问题。',
'本文介绍了使用 Spring Boot 构建微服务架构的实践经验，包括服务注册发现、配置管理、服务通信等关键技术。',
'Backend', '后端开发', 'Spring Boot,Java,微服务', true, 987, 67, '2024-01-17 14:20:00', '2024-01-17 14:20:00', '2024-01-17 14:20:00'),

(3, 'MySQL 性能优化技巧', 
'数据库性能优化是后端开发中的重要技能，本文分享一些 MySQL 性能优化的实用技巧。\n\n## 索引优化\n\n### 1. 选择合适的索引类型\n\n```sql\n-- 普通索引\nCREATE INDEX idx_username ON users(username);\n\n-- 唯一索引\nCREATE UNIQUE INDEX idx_email ON users(email);\n\n-- 复合索引\nCREATE INDEX idx_name_age ON users(name, age);\n\n-- 全文索引\nCREATE FULLTEXT INDEX idx_content ON articles(title, content);\n```\n\n### 2. 索引使用原则\n\n- **最左前缀原则**：复合索引从左到右匹配\n- **避免在索引列上使用函数**\n- **选择性高的列放在前面**\n\n```sql\n-- 好的查询\nSELECT * FROM users WHERE name = \'张三\' AND age = 25;\n\n-- 不好的查询\nSELECT * FROM users WHERE UPPER(name) = \'张三\';\n```\n\n## 查询优化\n\n### 1. 使用 EXPLAIN 分析查询\n\n```sql\nEXPLAIN SELECT * FROM users u \nJOIN orders o ON u.id = o.user_id \nWHERE u.status = \'active\' \nAND o.created_at > \'2024-01-01\';\n```\n\n### 2. 避免 SELECT *\n\n```sql\n-- 不推荐\nSELECT * FROM users WHERE id = 1;\n\n-- 推荐\nSELECT id, username, email FROM users WHERE id = 1;\n```\n\n### 3. 合理使用 LIMIT\n\n```sql\n-- 分页查询\nSELECT id, title FROM articles \nORDER BY created_at DESC \nLIMIT 20 OFFSET 100;\n\n-- 使用游标分页（更高效）\nSELECT id, title FROM articles \nWHERE id > 1000 \nORDER BY id \nLIMIT 20;\n```\n\n## 表结构优化\n\n### 1. 选择合适的数据类型\n\n```sql\nCREATE TABLE users (\n    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,\n    username VARCHAR(50) NOT NULL,\n    email VARCHAR(100) NOT NULL,\n    age TINYINT UNSIGNED,\n    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,\n    is_active BOOLEAN DEFAULT TRUE\n);\n```\n\n### 2. 表分区\n\n```sql\nCREATE TABLE orders (\n    id BIGINT AUTO_INCREMENT,\n    user_id BIGINT,\n    amount DECIMAL(10,2),\n    created_at DATE,\n    PRIMARY KEY (id, created_at)\n)\nPARTITION BY RANGE (YEAR(created_at)) (\n    PARTITION p2023 VALUES LESS THAN (2024),\n    PARTITION p2024 VALUES LESS THAN (2025),\n    PARTITION p2025 VALUES LESS THAN (2026)\n);\n```\n\n## 配置优化\n\n### 1. InnoDB 配置\n\n```ini\n# my.cnf\n[mysqld]\ninnodb_buffer_pool_size = 1G\ninnodb_log_file_size = 256M\ninnodb_flush_log_at_trx_commit = 2\ninnodb_file_per_table = 1\n```\n\n### 2. 查询缓存\n\n```ini\nquery_cache_type = 1\nquery_cache_size = 128M\nquery_cache_limit = 2M\n```\n\n## 监控和分析\n\n### 1. 慢查询日志\n\n```ini\nslow_query_log = 1\nslow_query_log_file = /var/log/mysql/slow.log\nlong_query_time = 2\n```\n\n### 2. 性能监控\n\n```sql\n-- 查看正在执行的查询\nSHOW PROCESSLIST;\n\n-- 查看表状态\nSHOW TABLE STATUS LIKE \'users\';\n\n-- 查看索引使用情况\nSHOW INDEX FROM users;\n```\n\n数据库性能优化是一个持续的过程，需要根据实际业务场景进行调整和优化。',
'MySQL 性能优化是数据库管理的重要技能，本文介绍了索引优化、查询优化、表结构设计等关键技术。',
'Database', '数据库', 'MySQL,数据库,性能优化', true, 756, 45, '2024-01-13 09:15:00', '2024-01-13 09:15:00', '2024-01-13 09:15:00');

-- 插入公告数据
INSERT IGNORE INTO announcements (id, title, content, is_published, is_pinned, created_at, updated_at, published_at, author_id, author_name) VALUES
(1, '欢迎来到博客系统', '欢迎大家使用我们的博客系统！这里是一个分享知识、交流经验的平台。希望大家能够在这里找到有价值的内容，也欢迎大家积极分享自己的见解和经验。', true, true, '2024-01-01 10:00:00', '2024-01-01 10:00:00', '2024-01-01 10:00:00', 1, 'Admin'),
(2, '系统功能介绍', '我们的博客系统支持文章发布、分类管理、标签系统、评论互动等功能。用户可以注册账号后发布自己的文章，也可以对其他用户的文章进行评论和点赞。管理员可以对系统进行全面的管理和维护。', true, false, '2024-01-02 14:30:00', '2024-01-02 14:30:00', '2024-01-02 14:30:00', 1, 'Admin'),
(3, '社区规范', '为了维护良好的社区环境，请大家遵守以下规范：1. 发布内容应当积极向上，不得包含违法违规信息；2. 尊重他人，文明交流；3. 不得恶意刷屏或发布垃圾信息；4. 保护个人隐私，不得泄露他人信息。感谢大家的配合！', true, false, '2024-01-03 09:15:00', '2024-01-03 09:15:00', '2024-01-03 09:15:00', 1, 'Admin');

-- 插入博客标签关联数据
INSERT IGNORE INTO blog_tags (blog_id, tag_id) VALUES
-- Vue 3 Composition API 深入解析
(1, 1), (1, 4), (1, 5),
-- Spring Boot 微服务架构实践
(2, 13), (2, 14), (2, 48),
-- MySQL 性能优化技巧
(3, 24), (3, 51);

-- 插入用户点赞记录数据
INSERT IGNORE INTO user_likes (user_id, blog_id, created_at) VALUES
(2, 1, '2024-01-16 10:30:00'),
(3, 1, '2024-01-16 11:15:00'),
(4, 1, '2024-01-16 14:20:00'),
(5, 1, '2024-01-17 09:45:00'),
(6, 1, '2024-01-17 16:30:00'),
(2, 2, '2024-01-17 10:00:00'),
(3, 2, '2024-01-17 15:30:00'),
(4, 2, '2024-01-18 09:15:00'),
(5, 3, '2024-01-13 11:20:00'),
(6, 3, '2024-01-13 14:45:00');