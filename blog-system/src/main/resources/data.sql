-- 博客系统初始数据插入脚本
-- 该文件仅包含数据插入，不包含表结构创建
-- 配合 schema.sql 使用，实现结构与数据分离

-- 设置字符集
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- 插入系统配置数据
INSERT IGNORE INTO `system_configs` (`config_key`, `config_value`, `config_type`, `description`, `is_public`) VALUES
('site_name', '个人博客系统', 'string', '网站名称', 1),
('site_description', '一个基于Spring Boot和Vue.js的现代化博客系统', 'string', '网站描述', 1),
('site_keywords', '博客,技术分享,编程,开发', 'string', '网站关键词', 1),
('admin_email', 'admin@blog.com', 'string', '管理员邮箱', 1),
('allow_registration', 'true', 'boolean', '是否允许用户注册', 1),
('comment_moderation', 'false', 'boolean', '评论是否需要审核', 1),
('posts_per_page', '10', 'number', '每页显示文章数量', 1),
('max_upload_size', '10485760', 'number', '最大上传文件大小(字节)', 1);

-- 插入用户数据
INSERT IGNORE INTO `users` (`id`, `username`, `email`, `password`, `nickname`, `bio`, `avatar`, `role`, `status`, `email_verified`) VALUES
(1, 'admin', 'admin@blog.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa', '系统管理员', '博客系统管理员，负责系统维护和内容管理。', '/uploads/avatars/admin.png', 'ADMIN', 'ACTIVE', 1),
(2, 'frontend', 'frontend@blog.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa', '前端工程师', '专注于前端开发，熟悉Vue.js、React等现代前端框架。', '/uploads/avatars/frontend.png', 'USER', 'ACTIVE', 1),
(3, 'backend', 'backend@blog.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa', '后端工程师', '后端开发专家，精通Spring Boot、数据库设计和系统优化。', '/uploads/avatars/backend.png', 'USER', 'ACTIVE', 1),
(4, 'database', 'database@blog.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa', '数据库专家', '数据库架构师，专注于数据库设计、性能优化和数据安全。', '/uploads/avatars/database.png', 'USER', 'ACTIVE', 1),
(5, 'devops', 'devops@blog.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa', '运维工程师', 'DevOps工程师，专注于自动化部署、容器化和云原生技术。', '/uploads/avatars/devops.png', 'USER', 'ACTIVE', 1);

-- 插入分类数据
INSERT IGNORE INTO `categories` (`id`, `name`, `description`, `color`, `sort_order`, `status`) VALUES
(1, '技术分享', '技术相关的文章分享和经验交流', '#007bff', 1, 'ACTIVE'),
(2, '前端开发', '前端开发技术、框架和最佳实践', '#28a745', 2, 'ACTIVE'),
(3, '后端开发', '后端开发技术、架构设计和性能优化', '#dc3545', 3, 'ACTIVE'),
(4, '数据库', '数据库设计、优化和管理相关技术', '#ffc107', 4, 'ACTIVE'),
(5, '移动开发', '移动应用开发技术和跨平台解决方案', '#17a2b8', 5, 'ACTIVE'),
(6, '云计算', '云计算、容器化和微服务架构', '#6f42c1', 6, 'ACTIVE'),
(7, '人工智能', '人工智能、机器学习和深度学习', '#fd7e14', 7, 'ACTIVE'),
(8, '算法与数据结构', '算法设计、数据结构和编程竞赛', '#20c997', 8, 'ACTIVE'),
(9, '项目实战', '实际项目开发经验和案例分析', '#6c757d', 9, 'ACTIVE'),
(10, '学习笔记', '学习过程中的笔记和知识总结', '#e83e8c', 10, 'ACTIVE');

-- 插入标签数据
INSERT IGNORE INTO `tags` (`id`, `name`, `color`, `usage_count`) VALUES
-- 前端技术标签
(1, 'Vue.js', '#4FC08D', 0),
(2, 'React', '#61DAFB', 0),
(3, 'Angular', '#DD0031', 0),
(4, 'JavaScript', '#F7DF1E', 0),
(5, 'TypeScript', '#3178C6', 0),
(6, 'HTML5', '#E34F26', 0),
(7, 'CSS3', '#1572B6', 0),
(8, 'Sass', '#CC6699', 0),
(9, 'Less', '#1D365D', 0),
(10, 'Webpack', '#8DD6F9', 0),
(11, 'Vite', '#646CFF', 0),
(12, 'Node.js', '#339933', 0),
-- 后端技术标签
(13, 'Java', '#007396', 0),
(14, 'Spring Boot', '#6DB33F', 0),
(15, 'Spring', '#6DB33F', 0),
(16, 'Python', '#3776AB', 0),
(17, 'Django', '#092E20', 0),
(18, 'Flask', '#000000', 0),
(19, 'Go', '#00ADD8', 0),
(20, 'Rust', '#000000', 0),
(21, 'C++', '#00599C', 0),
(22, 'C#', '#239120', 0),
(23, '.NET', '#512BD4', 0),
-- 数据库技术标签
(24, 'MySQL', '#4479A1', 0),
(25, 'PostgreSQL', '#336791', 0),
(26, 'MongoDB', '#47A248', 0),
(27, 'Redis', '#DC382D', 0),
(28, 'Elasticsearch', '#005571', 0),
-- 云计算和容器技术标签
(29, 'Docker', '#2496ED', 0),
(30, 'Kubernetes', '#326CE5', 0),
(31, 'AWS', '#FF9900', 0),
(32, 'Azure', '#0078D4', 0),
(33, '阿里云', '#FF6A00', 0),
(34, '腾讯云', '#006EFF', 0),
-- 移动开发技术标签
(35, 'Android', '#3DDC84', 0),
(36, 'iOS', '#000000', 0),
(37, 'React Native', '#61DAFB', 0),
(38, 'Flutter', '#02569B', 0),
(39, 'Kotlin', '#7F52FF', 0),
(40, 'Swift', '#FA7343', 0),
-- 工具和平台标签
(41, 'Git', '#F05032', 0),
(42, 'GitHub', '#181717', 0),
(43, 'GitLab', '#FC6D26', 0),
(44, 'Jenkins', '#D33833', 0),
(45, 'Linux', '#FCC624', 0),
(46, 'Ubuntu', '#E95420', 0),
(47, 'CentOS', '#262577', 0),
-- 概念和方法论标签
(48, '微服务', '#007ACC', 0),
(49, 'RESTful API', '#009688', 0),
(50, 'GraphQL', '#E10098', 0),
(51, '性能优化', '#FF5722', 0),
(52, '安全', '#F44336', 0),
(53, '测试', '#4CAF50', 0),
(54, '部署', '#2196F3', 0),
(55, '监控', '#FF9800', 0),
(56, '架构设计', '#9C27B0', 0),
(57, '算法', '#607D8B', 0),
(58, '机器学习', '#795548', 0),
(59, '人工智能', '#3F51B5', 0),
(60, '数据分析', '#009688', 0);

-- 插入文章数据
INSERT IGNORE INTO `articles` (`id`, `title`, `content`, `summary`, `author_id`, `category_id`, `status`, `view_count`, `like_count`, `comment_count`, `published_at`) VALUES
(1, 'Vue 3 Composition API 深入解析', 
'Vue 3 引入了 Composition API，这是一个全新的 API 设计，为组件逻辑提供了更好的组织方式。\n\n## Composition API 的优势\n\n### 1. 更好的逻辑复用\n\n```javascript\nimport { ref, computed, onMounted } from "vue"\n\nexport function useCounter() {\n  const count = ref(0)\n  const doubleCount = computed(() => count.value * 2)\n  \n  function increment() {\n    count.value++\n  }\n  \n  return {\n    count,\n    doubleCount,\n    increment\n  }\n}\n```\n\n### 2. 更好的 TypeScript 支持\n\nComposition API 天然支持 TypeScript，提供了更好的类型推断。\n\n### 3. 更灵活的组件组织\n\n```javascript\nexport default {\n  setup() {\n    // 用户相关逻辑\n    const { user, login, logout } = useUser()\n    \n    // 购物车相关逻辑\n    const { cart, addToCart, removeFromCart } = useCart()\n    \n    return {\n      user,\n      login,\n      logout,\n      cart,\n      addToCart,\n      removeFromCart\n    }\n  }\n}\n```\n\nComposition API 为 Vue 3 带来了更强大的功能和更好的开发体验。',
'Vue 3 Composition API 是一个革命性的功能，本文深入解析其核心概念、使用方法和最佳实践。',
2, 2, 'PUBLISHED', 1234, 89, 12, '2024-01-15 10:30:00'),

(2, 'Spring Boot 微服务架构实践', 
'微服务架构已经成为现代应用开发的主流模式，Spring Boot 为微服务开发提供了强大的支持。\n\n## 微服务架构概述\n\n微服务架构将单一应用程序分解为一套小型服务，每个服务运行在自己的进程中。\n\n### 微服务的优势\n\n1. **独立部署**：每个服务可以独立部署和扩展\n2. **技术多样性**：不同服务可以使用不同的技术栈\n3. **故障隔离**：单个服务的故障不会影响整个系统\n4. **团队自治**：小团队可以独立开发和维护服务\n\n## Spring Boot 微服务实现\n\n### 1. 服务注册与发现\n\n```java\n@SpringBootApplication\n@EnableEurekaClient\npublic class UserServiceApplication {\n    public static void main(String[] args) {\n        SpringApplication.run(UserServiceApplication.class, args);\n    }\n}\n```\n\n微服务架构虽然带来了很多好处，但也增加了系统的复杂性。',
'本文介绍了使用 Spring Boot 构建微服务架构的实践经验，包括服务注册发现、配置管理、服务通信等关键技术。',
3, 3, 'PUBLISHED', 987, 67, 8, '2024-01-17 14:20:00'),

(3, 'MySQL 性能优化技巧', 
'数据库性能优化是后端开发中的重要技能，本文分享一些 MySQL 性能优化的实用技巧。\n\n## 索引优化\n\n### 1. 选择合适的索引类型\n\n```sql\n-- 普通索引\nCREATE INDEX idx_username ON users(username);\n\n-- 唯一索引\nCREATE UNIQUE INDEX idx_email ON users(email);\n\n-- 复合索引\nCREATE INDEX idx_name_age ON users(name, age);\n```\n\n### 2. 索引使用原则\n\n- **最左前缀原则**：复合索引从左到右匹配\n- **避免在索引列上使用函数**\n- **选择性高的列放在前面**\n\n## 查询优化\n\n### 1. 使用 EXPLAIN 分析查询\n\n```sql\nEXPLAIN SELECT * FROM users u \nJOIN orders o ON u.id = o.user_id \nWHERE u.status = \'active\';\n```\n\n数据库性能优化是一个持续的过程，需要根据实际业务场景进行调整。',
'MySQL 性能优化是数据库管理的重要技能，本文介绍了索引优化、查询优化、表结构设计等关键技术。',
4, 4, 'PUBLISHED', 756, 45, 6, '2024-01-13 09:15:00'),

(4, 'React Hooks 最佳实践', 
'React Hooks 改变了我们编写 React 组件的方式，本文总结了一些 Hooks 的最佳实践。\n\n## useState 的使用技巧\n\n```javascript\n// 使用函数式更新\nconst [count, setCount] = useState(0);\nsetCount(prevCount => prevCount + 1);\n\n// 使用对象状态\nconst [user, setUser] = useState({\n  name: "",\n  email: ""\n});\n```\n\n## useEffect 的优化\n\n```javascript\n// 正确的依赖数组\nuseEffect(() => {\n  fetchUserData(userId);\n}, [userId]);\n\n// 清理副作用\nuseEffect(() => {\n  const timer = setInterval(() => {\n    // 定时任务\n  }, 1000);\n  \n  return () => clearInterval(timer);\n}, []);\n```\n\nHooks 让函数组件拥有了状态管理和生命周期的能力。',
'React Hooks 是现代 React 开发的核心，本文分享了 useState、useEffect 等常用 Hooks 的最佳实践。',
2, 2, 'PUBLISHED', 543, 32, 5, '2024-01-20 16:45:00'),

(5, 'Docker 容器化部署指南', 
'Docker 容器化技术已经成为现代应用部署的标准，本文介绍 Docker 的基本使用和最佳实践。\n\n## Docker 基础概念\n\n### 镜像和容器\n\n- **镜像（Image）**：应用程序的只读模板\n- **容器（Container）**：镜像的运行实例\n\n### Dockerfile 编写\n\n```dockerfile\nFROM openjdk:11-jre-slim\n\nWORKDIR /app\n\nCOPY target/blog-system.jar app.jar\n\nEXPOSE 8080\n\nCMD ["java", "-jar", "app.jar"]\n```\n\n## Docker Compose\n\n```yaml\nversion: \'3.8\'\nservices:\n  app:\n    build: .\n    ports:\n      - "8080:8080"\n    depends_on:\n      - mysql\n  \n  mysql:\n    image: mysql:8.0\n    environment:\n      MYSQL_ROOT_PASSWORD: password\n```\n\nDocker 简化了应用的部署和运维工作。',
'Docker 容器化技术为应用部署带来了革命性的变化，本文介绍了 Docker 的基本概念和实际应用。',
5, 6, 'PUBLISHED', 432, 28, 4, '2024-01-22 11:30:00');

-- 插入文章标签关联数据
INSERT IGNORE INTO `article_tags` (`article_id`, `tag_id`) VALUES
-- Vue 3 Composition API 深入解析
(1, 1), (1, 4), (1, 5),
-- Spring Boot 微服务架构实践
(2, 13), (2, 14), (2, 48),
-- MySQL 性能优化技巧
(3, 24), (3, 51),
-- React Hooks 最佳实践
(4, 2), (4, 4),
-- Docker 容器化部署指南
(5, 29), (5, 54);

-- 插入点赞记录数据
INSERT IGNORE INTO `likes` (`user_id`, `target_type`, `target_id`) VALUES
-- 文章点赞
(2, 'ARTICLE', 1),
(3, 'ARTICLE', 1),
(4, 'ARTICLE', 1),
(5, 'ARTICLE', 1),
(1, 'ARTICLE', 2),
(2, 'ARTICLE', 2),
(4, 'ARTICLE', 2),
(1, 'ARTICLE', 3),
(2, 'ARTICLE', 3),
(3, 'ARTICLE', 4),
(4, 'ARTICLE', 4),
(1, 'ARTICLE', 5),
(3, 'ARTICLE', 5);

-- 插入评论数据
INSERT IGNORE INTO `comments` (`id`, `article_id`, `user_id`, `content`, `status`, `like_count`) VALUES
(1, 1, 3, '这篇关于 Vue 3 Composition API 的文章写得很详细，对我理解新特性很有帮助！', 'APPROVED', 5),
(2, 1, 4, 'Composition API 确实比 Options API 更灵活，特别是在逻辑复用方面。', 'APPROVED', 3),
(3, 1, 5, '代码示例很清晰，建议再补充一些实际项目中的应用场景。', 'APPROVED', 2),
(4, 2, 2, 'Spring Boot 微服务架构的介绍很全面，正好在学习这方面的内容。', 'APPROVED', 4),
(5, 2, 4, '微服务虽然好，但是复杂度确实增加了不少，需要权衡利弊。', 'APPROVED', 6),
(6, 3, 2, 'MySQL 优化技巧很实用，特别是索引优化的部分。', 'APPROVED', 3),
(7, 3, 5, '性能优化是个持续的过程，这些技巧在实际工作中很有用。', 'APPROVED', 2),
(8, 4, 3, 'React Hooks 确实改变了组件的编写方式，学习成本不高但收益很大。', 'APPROVED', 4),
(9, 5, 2, 'Docker 容器化部署确实简化了很多运维工作，推荐学习。', 'APPROVED', 3);

-- 更新标签使用次数
UPDATE `tags` SET `usage_count` = 3 WHERE `id` = 1;  -- Vue.js
UPDATE `tags` SET `usage_count` = 2 WHERE `id` = 2;  -- React
UPDATE `tags` SET `usage_count` = 3 WHERE `id` = 4;  -- JavaScript
UPDATE `tags` SET `usage_count` = 1 WHERE `id` = 5;  -- TypeScript
UPDATE `tags` SET `usage_count` = 2 WHERE `id` = 13; -- Java
UPDATE `tags` SET `usage_count` = 2 WHERE `id` = 14; -- Spring Boot
UPDATE `tags` SET `usage_count` = 1 WHERE `id` = 24; -- MySQL
UPDATE `tags` SET `usage_count` = 1 WHERE `id` = 29; -- Docker
UPDATE `tags` SET `usage_count` = 2 WHERE `id` = 48; -- 微服务
UPDATE `tags` SET `usage_count` = 1 WHERE `id` = 51; -- 性能优化
UPDATE `tags` SET `usage_count` = 1 WHERE `id` = 54; -- 部署

SET FOREIGN_KEY_CHECKS = 1;
