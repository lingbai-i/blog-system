-- 博客系统基础数据初始化脚本
-- 用于用户首次部署时提供完整的基础数据

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

-- 插入用户数据（包含更多示例用户）
INSERT IGNORE INTO users (id, account, username, email, password, full_name, bio, is_admin, is_active) VALUES
(1, 'admin', 'Admin', 'admin@blog.com', 'admin123', '系统管理员', '博客系统管理员，负责系统维护和内容管理。', true, true),
(2, 'blogger', 'Blogger', 'blogger@blog.com', 'blogger123', '博客作者', '热爱技术分享的全栈开发者，专注于Web开发和系统架构。', false, true),
(3, 'reader', 'Reader', 'reader@blog.com', 'reader123', '博客读者', '技术爱好者，喜欢阅读和学习新技术。', false, true),
(4, 'developer', 'Developer', 'developer@blog.com', 'dev123', '开发者', '资深软件工程师，擅长Java后端开发和微服务架构。', false, true),
(5, 'student', 'Student', 'student@blog.com', 'student123', '技术学生', '计算机专业学生，正在学习编程和软件开发。', false, true),
(6, 'frontend', 'Frontend', 'frontend@blog.com', 'frontend123', '前端工程师', '专注于前端开发，熟悉Vue.js、React等现代前端框架。', false, true),
(7, 'backend', 'Backend', 'backend@blog.com', 'backend123', '后端工程师', '后端开发专家，精通Spring Boot、数据库设计和系统优化。', false, true);

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
(6, 'HTML', 'html', 'HTML标记语言', '#E34F26', true, 0),
(7, 'CSS', 'css', 'CSS样式表语言', '#1572B6', true, 0),
(8, 'Sass', 'sass', 'Sass CSS预处理器', '#CC6699', true, 0),
(9, 'Less', 'less', 'Less CSS预处理器', '#1D365D', true, 0),
(10, 'Webpack', 'webpack', 'Webpack模块打包工具', '#8DD6F9', true, 0),
(11, 'Vite', 'vite', 'Vite构建工具', '#646CFF', true, 0),
(12, 'Node.js', 'nodejs', 'Node.js运行时环境', '#339933', true, 0),

-- 后端技术标签
(13, 'Java', 'java', 'Java编程语言', '#ED8B00', true, 0),
(14, 'Spring Boot', 'spring-boot', 'Spring Boot后端框架', '#6DB33F', true, 0),
(15, 'Spring Cloud', 'spring-cloud', 'Spring Cloud微服务框架', '#6DB33F', true, 0),
(16, 'Python', 'python', 'Python编程语言', '#3776AB', true, 0),
(17, 'Django', 'django', 'Django Web框架', '#092E20', true, 0),
(18, 'Flask', 'flask', 'Flask轻量级Web框架', '#000000', true, 0),
(19, 'Go', 'golang', 'Go编程语言', '#00ADD8', true, 0),
(20, 'Rust', 'rust', 'Rust编程语言', '#000000', true, 0),
(21, 'C++', 'cpp', 'C++编程语言', '#00599C', true, 0),
(22, 'C#', 'csharp', 'C#编程语言', '#239120', true, 0),
(23, '.NET', 'dotnet', '.NET开发框架', '#512BD4', true, 0),

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
(33, 'Google Cloud', 'gcp', 'Google Cloud Platform', '#4285F4', true, 0),

-- 移动开发技术标签
(34, 'Android', 'android', 'Android移动开发', '#3DDC84', true, 0),
(35, 'iOS', 'ios', 'iOS移动开发', '#000000', true, 0),
(36, 'React Native', 'react-native', 'React Native跨平台开发', '#61DAFB', true, 0),
(37, 'Flutter', 'flutter', 'Flutter跨平台开发', '#02569B', true, 0),
(38, 'Kotlin', 'kotlin', 'Kotlin编程语言', '#7F52FF', true, 0),
(39, 'Swift', 'swift', 'Swift编程语言', '#FA7343', true, 0),

-- 工具和其他技术标签
(40, 'Git', 'git', 'Git版本控制系统', '#F05032', true, 0),
(41, 'GitHub', 'github', 'GitHub代码托管平台', '#181717', true, 0),
(42, 'GitLab', 'gitlab', 'GitLab代码托管平台', '#FC6D26', true, 0),
(43, 'Jenkins', 'jenkins', 'Jenkins持续集成工具', '#D24939', true, 0),
(44, 'Linux', 'linux', 'Linux操作系统', '#FCC624', true, 0),
(45, 'Ubuntu', 'ubuntu', 'Ubuntu操作系统', '#E95420', true, 0),
(46, 'Nginx', 'nginx', 'Nginx Web服务器', '#009639', true, 0),
(47, 'Apache', 'apache', 'Apache Web服务器', '#D22128', true, 0),

-- 概念性标签
(48, '微服务', 'microservices', '微服务架构', '#4ECDC4', true, 0),
(49, '架构设计', 'architecture', '系统架构设计', '#FF6B6B', true, 0),
(50, '算法', 'algorithm', '算法和数据结构', '#9B59B6', true, 0),
(51, '性能优化', 'performance', '性能优化技术', '#E74C3C', true, 0),
(52, '安全', 'security', '网络安全和信息安全', '#34495E', true, 0),
(53, '测试', 'testing', '软件测试技术', '#F39C12', true, 0),
(54, 'DevOps', 'devops', 'DevOps开发运维', '#2ECC71', true, 0),
(55, '人工智能', 'ai', '人工智能技术', '#8E44AD', true, 0),
(56, '机器学习', 'machine-learning', '机器学习技术', '#3498DB', true, 0),
(57, '深度学习', 'deep-learning', '深度学习技术', '#E67E22', true, 0),
(58, '区块链', 'blockchain', '区块链技术', '#F1C40F', true, 0),
(59, '物联网', 'iot', '物联网技术', '#16A085', true, 0),
(60, '大数据', 'big-data', '大数据技术', '#C0392B', true, 0);

-- 插入博客数据（扩展示例文章）
INSERT IGNORE INTO blogs (id, title, content, summary, author_name, category, tags, is_published, view_count, like_count, created_at, published_at) VALUES
(1, 'Vue 3 Composition API 深入解析', 
'Vue 3 引入了 Composition API，这是一个全新的 API 设计，让我们能够更好地组织和复用代码逻辑。Composition API 是 Vue 3 中新增的一套 API，它提供了一种更灵活的方式来组织组件逻辑。与 Options API 不同，Composition API 允许我们将相关的逻辑组织在一起，而不是按照选项类型分离。基本用法包括使用 ref、computed 和生命周期钩子来管理状态和副作用。这种模式让代码更具可读性和可维护性，尤其是在大型项目中。优势包括更好的逻辑复用能力、更强的 TypeScript 支持以及更灵活的代码组织方式。Composition API 为 Vue 3 带来了更强大的功能和更好的开发体验，值得深入学习和使用。',
'Vue 3 引入了 Composition API，这是一个全新的 API 设计，让我们能够更好地组织和复用代码逻辑。本文将深入解析 Composition API 的使用方法和优势。',
'Frontend', '前端开发', 'Vue.js,JavaScript', true, 1250, 25, '2024-01-15 10:00:00', '2024-01-15 10:00:00'),
(2, 'Spring Boot 微服务架构实践', 
'在现代软件开发中，微服务架构已经成为了主流的架构模式。Spring Boot 为我们提供了强大的工具来构建微服务应用。微服务架构是一种将单一应用程序开发为一组小型服务的方法，每个服务运行在自己的进程中，并使用轻量级机制（通常是 HTTP API）进行通信。Spring Boot 在微服务中的优势包括快速开发、独立部署和多样化的技术栈支持。实践案例展示了如何通过 Spring Boot 构建用户服务并实现 RESTful 接口。最佳实践建议按业务能力拆分服务，每个服务管理自己的数据，并实现熔断和降级机制以提高系统的健壮性。尽管微服务架构复杂，但带来的好处是显著的，值得在合适的场景下采用。',
'在现代软件开发中，微服务架构已经成为了主流的架构模式。本文将介绍如何使用 Spring Boot 构建微服务应用，包括最佳实践和实际案例。',
'Backend', '后端开发', 'Spring Boot,Java', true, 980, 18, '2024-01-10 14:30:00', '2024-01-10 14:30:00'),
(3, 'MySQL 性能优化技巧', 
'数据库性能优化是后端开发中的重要技能。本文分享了一些实用的 MySQL 性能优化技巧。索引是提高查询性能的关键因素，合理创建复合索引并分析执行计划可以显著提升性能。查询优化建议避免 SELECT *，限制返回字段数量，并优化 WHERE 条件顺序。配置优化方面，innodb_buffer_pool_size、innodb_log_file_size 和 query_cache_size 是常用的调优参数。此外，应定期使用 EXPLAIN 工具分析查询执行计划，并启用慢查询日志查找瓶颈。性能优化是一个持续的过程，需要根据实际情况不断调整。',
'数据库性能优化是后端开发中的重要技能。本文分享了 MySQL 性能优化的实用技巧，包括索引优化、查询优化和配置调优等方面。',
'Database', '数据库', 'MySQL,数据库', true, 756, 12, '2024-01-12 09:15:00', '2024-01-12 09:15:00'),
(4, 'React Hooks 最佳实践指南',
'React Hooks 改变了我们编写 React 组件的方式，让函数组件拥有了状态管理和生命周期的能力。useState 提供了状态管理能力，useEffect 可用于处理副作用。自定义 Hooks 可以帮助我们复用逻辑。此外，useMemo 和 useCallback 可以有效避免不必要的重新计算。掌握这些最佳实践对于编写高质量的 React 应用至关重要。',
'React Hooks 改变了我们编写 React 组件的方式。本文详细介绍了 useState、useEffect 等核心 Hooks 的最佳实践，以及如何编写自定义 Hooks。',
'Frontend', '前端开发', 'React,JavaScript', true, 892, 21, '2024-01-18 16:45:00', '2024-01-18 16:45:00'),
(5, 'Docker 容器化部署实战',
'Docker 已经成为现代应用部署的标准工具。本文介绍了 Docker 容器化部署的最佳实践，包括 Dockerfile 编写、Docker Compose 编排等。多阶段构建可以减小镜像大小，非 root 用户运行容器可以增强安全性，定期更新基础镜像有助于修复漏洞。',
'Docker 已经成为现代应用部署的标准工具。本文介绍了 Docker 容器化部署的最佳实践，包括 Dockerfile 编写、Docker Compose 编排等。',
'DevOps', '运维部署', 'Docker,容器化', true, 634, 15, '2024-01-20 11:20:00', '2024-01-20 11:20:00'),
(6, 'JavaScript ES6+ 新特性详解', 
'ES6+ 为 JavaScript 带来了许多强大的新特性，让代码更加简洁和高效。箭头函数简化了函数表达式写法，解构赋值提高了变量赋值的灵活性，Promise 和 async/await 让异步编程更加优雅。模块系统提供了良好的代码封装和导入导出机制。',
'ES6+ 为 JavaScript 带来了许多强大的新特性。本文详细介绍了箭头函数、解构赋值、Promise、模块系统等重要特性的使用方法。',
'Frontend', '前端开发', 'JavaScript,ES6', true, 543, 9, '2024-01-08 20:00:00', '2024-01-08 20:00:00'),
(7, 'Redis 缓存策略与实践',
'Redis 是一个高性能的内存数据库，广泛用于缓存、会话存储和消息队列等场景。Cache-Aside 模式允许应用程序直接管理缓存，Write-Through 模式则保证缓存和数据库同时更新。Redis 提供了多种数据结构如 String、Hash、List 和 Set，适用于不同的应用场景。',
'Redis 是一个高性能的内存数据库，广泛用于缓存场景。本文介绍了 Redis 的缓存策略、数据结构应用和性能优化技巧。',
'Backend', '数据库', 'Redis,缓存', true, 721, 16, '2024-01-22 14:30:00', '2024-01-22 14:30:00'),
(8, 'TypeScript 进阶开发指南',
'TypeScript 为 JavaScript 添加了静态类型检查，提高了代码的可维护性和开发效率。高级类型如联合类型、交叉类型和条件类型扩展了类型系统的能力。泛型提供了通用组件的编写方式，装饰器增强了类的功能。',
'TypeScript 为 JavaScript 添加了静态类型检查。本文介绍了 TypeScript 的高级特性，包括泛型、装饰器、模块系统等进阶开发技巧。',
'Frontend', '前端开发', 'TypeScript,JavaScript', true, 567, 13, '2024-01-25 09:30:00', '2024-01-25 09:30:00'),
(9, 'Java 并发编程实战', 
'Java 并发编程是后端开发的重要技能。线程池简化了任务调度，synchronized 和 ReentrantLock 提供了同步机制，ConcurrentHashMap 和 BlockingQueue 是线程安全的数据结构。并发编程使得程序能够充分利用多核 CPU 资源，提高执行效率。',
'Java 并发编程是后端开发的重要技能。本文介绍了线程池、同步机制、并发集合等关键概念和实用技巧。',
'Backend', '后端开发', 'Java,并发编程', true, 445, 8, '2024-01-14 11:45:00', '2024-01-14 11:45:00'),
(10, 'Kubernetes 容器编排实践',
'Kubernetes 是目前最流行的容器编排平台。Pod 是最小部署单元，Deployment 提供了滚动更新能力，Service 实现了服务发现和负载均衡。kubectl 是 Kubernetes 的主要命令行工具。最佳实践包括资源限制、健康检查、ConfigMap 使用等。',
'Kubernetes 是目前最流行的容器编排平台。本文介绍了 K8s 的核心概念、常用命令和最佳实践，帮助你快速上手容器编排。',
'DevOps', '运维部署', 'Kubernetes,容器编排', true, 589, 14, '2024-01-28 10:15:00', '2024-01-28 10:15:00'),
(11, 'Node.js 性能优化技巧',
'Node.js 在服务端开发中越来越受欢迎。事件循环优化和 Worker Threads 可以提高性能。连接池和 Redis 缓存提升了数据库访问效率。性能监控工具可以帮助我们及时发现瓶颈。',
'Node.js 在服务端开发中越来越受欢迎。本文分享了事件循环优化、内存管理、数据库优化等实用的 Node.js 性能优化技巧。',
'Backend', '后端开发', 'Node.js,性能优化', true, 423, 11, '2024-01-30 15:20:00', '2024-01-30 15:20:00'),
(12, 'Python 数据分析入门',
'Python 在数据分析领域有着广泛的应用。Pandas 提供了强大的数据清洗和处理能力，NumPy 用于数值计算，Matplotlib 和 Seaborn 则用于数据可视化。数据分析流程包括数据收集、清洗、探索、建模、结果解释等多个阶段。',
'Python 在数据分析领域有着广泛的应用。本文介绍了 Pandas、NumPy、Matplotlib 等常用库的使用方法和数据分析的基本流程。',
'DataAnalyst', '数据分析', 'Python,数据分析', true, 456, 12, '2024-02-01 09:45:00', '2024-02-01 09:45:00');

-- 插入公告数据
INSERT IGNORE INTO announcements (id, title, content, is_published, is_pinned, created_at, updated_at, published_at, author_id, author_name) VALUES
(1, '欢迎来到博客系统', '欢迎大家使用我们的博客系统！这里是一个分享知识、交流经验的平台。希望大家能够在这里找到有价值的内容，也欢迎大家积极分享自己的见解和经验。', true, true, '2024-01-01 10:00:00', '2024-01-01 10:00:00', '2024-01-01 10:00:00', 1, 'Admin'),
(2, '系统功能介绍', '我们的博客系统支持文章发布、分类管理、标签系统、评论互动等功能。用户可以注册账号后发布自己的文章，也可以对其他用户的文章进行评论和点赞。管理员可以对系统进行全面的管理和维护。', true, false, '2024-01-02 14:30:00', '2024-01-02 14:30:00', '2024-01-02 14:30:00', 1, 'Admin'),
(3, '社区规范', '为了维护良好的社区环境，请大家遵守以下规范：1. 发布内容应当积极向上，不得包含违法违规信息；2. 尊重他人，文明交流；3. 不得恶意刷屏或发布垃圾信息；4. 保护个人隐私，不得泄露他人信息。感谢大家的配合！', true, false, '2024-01-03 09:15:00', '2024-01-03 09:15:00', '2024-01-03 09:15:00', 1, 'Admin');
