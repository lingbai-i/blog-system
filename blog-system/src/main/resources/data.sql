-- 博客系统基础数据初始化脚本
-- 用于用户首次部署时提供完整的基础数据

-- 插入系统配置数据
INSERT IGNORE INTO system_configs (config_key, config_value, description, is_active) VALUES
('site_name', '个人博客系统', '网站名称', true),
('site_description', '一个基于Spring Boot和Vue.js的现代化博客系统', '网站描述', true),
('site_keywords', '博客,技术分享,编程,开发', '网站关键词', true),
('admin_email', 'admin@blog.com', '管理员邮箱', true),
('allow_registration', 'true', '是否允许用户注册', true),
('comment_moderation', 'false', '评论是否需要审核', true),
('posts_per_page', '10', '每页显示文章数量', true),
('max_upload_size', '10485760', '最大上传文件大小(字节)', true);

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
'Vue 3 引入了 Composition API，这是一个全新的 API 设计，让我们能够更好地组织和复用代码逻辑。\n\n## 什么是 Composition API\n\nComposition API 是 Vue 3 中新增的一套 API，它提供了一种更灵活的方式来组织组件逻辑。与 Options API 不同，Composition API 允许我们将相关的逻辑组织在一起，而不是按照选项类型分离。\n\n## 基本用法\n\n```javascript\nimport { ref, computed, onMounted } from "vue"\n\nexport default {\n  setup() {\n    const count = ref(0)\n    const doubleCount = computed(() => count.value * 2)\n    \n    const increment = () => {\n      count.value++\n    }\n    \n    onMounted(() => {\n      console.log("组件已挂载")\n    })\n    \n    return {\n      count,\n      doubleCount,\n      increment\n    }\n  }\n}\n```\n\n## 优势\n\n1. **更好的逻辑复用**：可以将相关逻辑提取到可复用的函数中\n2. **更好的类型推导**：TypeScript 支持更好\n3. **更灵活的代码组织**：相关逻辑可以组织在一起\n\n## 总结\n\nComposition API 为 Vue 3 带来了更强大的功能和更好的开发体验，值得深入学习和使用。',
'Vue 3 引入了 Composition API，这是一个全新的 API 设计，让我们能够更好地组织和复用代码逻辑。本文将深入解析 Composition API 的使用方法和优势。',
'Frontend', '前端开发', 'Vue.js,JavaScript', true, 1250, 25, '2024-01-15 10:00:00', '2024-01-15 10:00:00'),

(2, 'Spring Boot 微服务架构实践', 
'在现代软件开发中，微服务架构已经成为了主流的架构模式。Spring Boot 为我们提供了强大的工具来构建微服务应用。\n\n## 微服务架构概述\n\n微服务架构是一种将单一应用程序开发为一组小型服务的方法，每个服务运行在自己的进程中，并使用轻量级机制（通常是 HTTP API）进行通信。\n\n## Spring Boot 在微服务中的优势\n\n1. **快速开发**：Spring Boot 的自动配置大大简化了开发过程\n2. **独立部署**：每个服务可以独立部署和扩展\n3. **技术多样性**：不同服务可以使用不同的技术栈\n\n## 实践案例\n\n```java\n@SpringBootApplication\n@EnableEurekaClient\npublic class UserServiceApplication {\n    public static void main(String[] args) {\n        SpringApplication.run(UserServiceApplication.class, args);\n    }\n}\n\n@RestController\n@RequestMapping("/api/users")\npublic class UserController {\n    \n    @Autowired\n    private UserService userService;\n    \n    @GetMapping("/{id}")\n    public ResponseEntity<User> getUser(@PathVariable Long id) {\n        User user = userService.findById(id);\n        return ResponseEntity.ok(user);\n    }\n}\n```\n\n## 最佳实践\n\n1. **服务拆分原则**：按业务能力拆分\n2. **数据管理**：每个服务管理自己的数据\n3. **容错处理**：实现熔断和降级机制\n\n微服务架构虽然复杂，但带来的好处是显著的，值得在合适的场景下采用。',
'在现代软件开发中，微服务架构已经成为了主流的架构模式。本文将介绍如何使用 Spring Boot 构建微服务应用，包括最佳实践和实际案例。',
'Backend', '后端开发', 'Spring Boot,Java', true, 980, 18, '2024-01-10 14:30:00', '2024-01-10 14:30:00'),

(3, 'MySQL 性能优化技巧', 
'数据库性能优化是后端开发中的重要技能。本文将分享一些实用的 MySQL 性能优化技巧。\n\n## 索引优化\n\n索引是提高查询性能的关键因素：\n\n```sql\n-- 创建复合索引\nCREATE INDEX idx_user_status_created ON users(status, created_at);\n\n-- 查看索引使用情况\nEXPLAIN SELECT * FROM users WHERE status = 1 ORDER BY created_at;\n```\n\n## 查询优化\n\n1. **避免 SELECT ***：只查询需要的字段\n2. **使用 LIMIT**：限制返回结果数量\n3. **优化 WHERE 条件**：将选择性高的条件放在前面\n\n## 配置优化\n\n```ini\n# my.cnf 配置示例\ninnodb_buffer_pool_size = 1G\ninnodb_log_file_size = 256M\nquery_cache_size = 64M\n```\n\n## 监控和分析\n\n使用 EXPLAIN 分析查询执行计划，使用慢查询日志找出性能瓶颈。\n\n性能优化是一个持续的过程，需要根据实际情况不断调整。',
'数据库性能优化是后端开发中的重要技能。本文分享了 MySQL 性能优化的实用技巧，包括索引优化、查询优化和配置调优等方面。',
'Database', '数据库', 'MySQL,数据库', true, 756, 12, '2024-01-12 09:15:00', '2024-01-12 09:15:00'),

(4, 'React Hooks 最佳实践指南',
'React Hooks 改变了我们编写 React 组件的方式，让函数组件拥有了状态管理和生命周期的能力。\n\n## useState 的正确使用\n\n```jsx\nimport React, { useState } from "react";\n\nfunction Counter() {\n  const [count, setCount] = useState(0);\n  \n  // 正确：使用函数式更新\n  const increment = () => {\n    setCount(prevCount => prevCount + 1);\n  };\n  \n  return (\n    <div>\n      <p>Count: {count}</p>\n      <button onClick={increment}>+1</button>\n    </div>\n  );\n}\n```\n\n## useEffect 的最佳实践\n\n```jsx\nimport React, { useState, useEffect } from "react";\n\nfunction UserProfile({ userId }) {\n  const [user, setUser] = useState(null);\n  \n  useEffect(() => {\n    let cancelled = false;\n    \n    async function fetchUser() {\n      const response = await fetch(`/api/users/${userId}`);\n      const userData = await response.json();\n      \n      if (!cancelled) {\n        setUser(userData);\n      }\n    }\n    \n    fetchUser();\n    \n    return () => {\n      cancelled = true;\n    };\n  }, [userId]);\n  \n  return user ? <div>{user.name}</div> : <div>Loading...</div>;\n}\n```\n\n## 自定义 Hooks\n\n```jsx\nfunction useLocalStorage(key, initialValue) {\n  const [storedValue, setStoredValue] = useState(() => {\n    try {\n      const item = window.localStorage.getItem(key);\n      return item ? JSON.parse(item) : initialValue;\n    } catch (error) {\n      return initialValue;\n    }\n  });\n  \n  const setValue = (value) => {\n    try {\n      setStoredValue(value);\n      window.localStorage.setItem(key, JSON.stringify(value));\n    } catch (error) {\n      console.error(error);\n    }\n  };\n  \n  return [storedValue, setValue];\n}\n```\n\n## 性能优化\n\n1. **使用 useMemo 和 useCallback**：避免不必要的重新计算\n2. **合理使用依赖数组**：避免无限循环\n3. **拆分组件**：减少重新渲染的范围\n\nReact Hooks 提供了强大而灵活的状态管理方案，掌握其最佳实践对于编写高质量的 React 应用至关重要。',
'React Hooks 改变了我们编写 React 组件的方式。本文详细介绍了 useState、useEffect 等核心 Hooks 的最佳实践，以及如何编写自定义 Hooks。',
'Frontend', '前端开发', 'React,JavaScript', true, 892, 21, '2024-01-18 16:45:00', '2024-01-18 16:45:00'),

(5, 'Docker 容器化部署实战',
'Docker 已经成为现代应用部署的标准工具。本文将介绍如何使用 Docker 进行应用容器化部署。\n\n## Dockerfile 最佳实践\n\n```dockerfile\n# 使用多阶段构建\nFROM node:16-alpine AS builder\nWORKDIR /app\nCOPY package*.json ./\nRUN npm ci --only=production\n\nFROM node:16-alpine AS runtime\nWORKDIR /app\nCOPY --from=builder /app/node_modules ./node_modules\nCOPY . .\nEXPOSE 3000\nUSER node\nCMD ["npm", "start"]\n```\n\n## Docker Compose 编排\n\n```yaml\nversion: "3.8"\nservices:\n  web:\n    build: .\n    ports:\n      - "3000:3000"\n    environment:\n      - NODE_ENV=production\n    depends_on:\n      - db\n      \n  db:\n    image: mysql:8.0\n    environment:\n      MYSQL_ROOT_PASSWORD: password\n      MYSQL_DATABASE: myapp\n    volumes:\n      - db_data:/var/lib/mysql\n      \nvolumes:\n  db_data:\n```\n\n## 容器监控\n\n```bash\n# 查看容器状态\ndocker ps\n\n# 查看容器日志\ndocker logs -f container_name\n\n# 进入容器\ndocker exec -it container_name /bin/sh\n```\n\n## 安全最佳实践\n\n1. **使用非 root 用户**：避免权限过大\n2. **最小化镜像**：减少攻击面\n3. **定期更新基础镜像**：修复安全漏洞\n\nDocker 容器化部署提高了应用的可移植性和一致性，是现代 DevOps 的重要组成部分。',
'Docker 已经成为现代应用部署的标准工具。本文介绍了 Docker 容器化部署的最佳实践，包括 Dockerfile 编写、Docker Compose 编排等。',
'DevOps', '运维部署', 'Docker,容器化', true, 634, 15, '2024-01-20 11:20:00', '2024-01-20 11:20:00'),

(6, 'JavaScript ES6+ 新特性详解', 
'ES6+ 为 JavaScript 带来了许多强大的新特性，让代码更加简洁和高效。\n\n## 箭头函数\n\n```javascript\n// 传统函数\nfunction add(a, b) {\n    return a + b;\n}\n\n// 箭头函数\nconst add = (a, b) => a + b;\n\n// 数组方法中的应用\nconst numbers = [1, 2, 3, 4, 5];\nconst doubled = numbers.map(n => n * 2);\n```\n\n## 解构赋值\n\n```javascript\n// 数组解构\nconst [first, second, ...rest] = [1, 2, 3, 4, 5];\n\n// 对象解构\nconst { name, age, ...others } = user;\n\n// 函数参数解构\nfunction greet({ name, age }) {\n    console.log(`Hello ${name}, you are ${age} years old`);\n}\n```\n\n## Promise 和 async/await\n\n```javascript\n// Promise\nfetch('/api/data')\n    .then(response => response.json())\n    .then(data => console.log(data))\n    .catch(error => console.error(error));\n\n// async/await\nasync function fetchData() {\n    try {\n        const response = await fetch('/api/data');\n        const data = await response.json();\n        console.log(data);\n    } catch (error) {\n        console.error(error);\n    }\n}\n```\n\n## 模块系统\n\n```javascript\n// 导出\nexport const PI = 3.14159;\nexport function calculate(radius) {\n    return PI * radius * radius;\n}\n\n// 导入\nimport { PI, calculate } from './math.js';\n```\n\nES6+ 的这些特性大大提升了 JavaScript 的开发体验和代码质量。',
'ES6+ 为 JavaScript 带来了许多强大的新特性。本文详细介绍了箭头函数、解构赋值、Promise、模块系统等重要特性的使用方法。',
'Frontend', '前端开发', 'JavaScript,ES6', true, 543, 9, '2024-01-08 20:00:00', '2024-01-08 20:00:00'),

(7, 'Redis 缓存策略与实践',
'Redis 是一个高性能的内存数据库，广泛用于缓存、会话存储和消息队列等场景。\n\n## 缓存策略\n\n### 1. Cache-Aside 模式\n\n```java\n@Service\npublic class UserService {\n    \n    @Autowired\n    private RedisTemplate<String, Object> redisTemplate;\n    \n    @Autowired\n    private UserRepository userRepository;\n    \n    public User getUser(Long id) {\n        String key = "user:" + id;\n        \n        // 先查缓存\n        User user = (User) redisTemplate.opsForValue().get(key);\n        if (user != null) {\n            return user;\n        }\n        \n        // 缓存未命中，查数据库\n        user = userRepository.findById(id);\n        if (user != null) {\n            // 写入缓存\n            redisTemplate.opsForValue().set(key, user, 30, TimeUnit.MINUTES);\n        }\n        \n        return user;\n    }\n}\n```\n\n### 2. Write-Through 模式\n\n```java\npublic void updateUser(User user) {\n    // 同时更新数据库和缓存\n    userRepository.save(user);\n    String key = "user:" + user.getId();\n    redisTemplate.opsForValue().set(key, user, 30, TimeUnit.MINUTES);\n}\n```\n\n## 数据结构应用\n\n### String - 简单缓存\n```bash\nSET user:1001 "{\"name\":\"张三\",\"age\":25}"\nGET user:1001\nEXPIRE user:1001 3600\n```\n\n### Hash - 对象存储\n```bash\nHMSET user:1001 name "张三" age 25 email "zhangsan@example.com"\nHGETALL user:1001\n```\n\n### List - 消息队列\n```bash\nLPUSH message_queue "task1"\nRPOP message_queue\n```\n\n### Set - 去重集合\n```bash\nSADD online_users "user1" "user2" "user3"\nSMEMBERS online_users\n```\n\n## 性能优化\n\n1. **合理设置过期时间**：避免内存溢出\n2. **使用管道技术**：减少网络往返\n3. **选择合适的数据结构**：提高操作效率\n4. **监控内存使用**：及时发现问题\n\n## 高可用方案\n\n- **主从复制**：数据备份和读写分离\n- **哨兵模式**：自动故障转移\n- **集群模式**：水平扩展\n\nRedis 的正确使用能够显著提升应用性能，但需要根据具体场景选择合适的策略。',
'Redis 是一个高性能的内存数据库，广泛用于缓存场景。本文介绍了 Redis 的缓存策略、数据结构应用和性能优化技巧。',
'Backend', '数据库', 'Redis,缓存', true, 721, 16, '2024-01-22 14:30:00', '2024-01-22 14:30:00'),

(8, 'TypeScript 进阶开发指南',
'TypeScript 为 JavaScript 添加了静态类型检查，提高了代码的可维护性和开发效率。\n\n## 高级类型\n\n### 联合类型和交叉类型\n\n```typescript\n// 联合类型\ntype Status = "loading" | "success" | "error";\n\n// 交叉类型\ntype User = {\n  name: string;\n  age: number;\n};\n\ntype Admin = {\n  permissions: string[];\n};\n\ntype AdminUser = User & Admin;\n```\n\n### 泛型\n\n```typescript\n// 泛型函数\nfunction identity<T>(arg: T): T {\n  return arg;\n}\n\n// 泛型接口\ninterface ApiResponse<T> {\n  code: number;\n  message: string;\n  data: T;\n}\n\n// 泛型类\nclass Repository<T> {\n  private items: T[] = [];\n  \n  add(item: T): void {\n    this.items.push(item);\n  }\n  \n  findById(id: string): T | undefined {\n    return this.items.find(item => (item as any).id === id);\n  }\n}\n```\n\n## 装饰器\n\n```typescript\n// 类装饰器\nfunction Entity(tableName: string) {\n  return function <T extends { new (...args: any[]): {} }>(constructor: T) {\n    return class extends constructor {\n      tableName = tableName;\n    };\n  };\n}\n\n// 方法装饰器\nfunction Log(target: any, propertyName: string, descriptor: PropertyDescriptor) {\n  const method = descriptor.value;\n  \n  descriptor.value = function (...args: any[]) {\n    console.log(`Calling ${propertyName} with args:`, args);\n    const result = method.apply(this, args);\n    console.log(`Result:`, result);\n    return result;\n  };\n}\n\n@Entity("users")\nclass User {\n  constructor(public name: string, public age: number) {}\n  \n  @Log\n  greet(): string {\n    return `Hello, I\'m ${this.name}`;\n  }\n}\n```\n\n## 模块和命名空间\n\n```typescript\n// 模块\nexport interface User {\n  id: string;\n  name: string;\n}\n\nexport class UserService {\n  async getUser(id: string): Promise<User> {\n    // 实现逻辑\n  }\n}\n\n// 命名空间\nnamespace Utils {\n  export function formatDate(date: Date): string {\n    return date.toISOString().split(\'T\')[0];\n  }\n  \n  export function generateId(): string {\n    return Math.random().toString(36).substr(2, 9);\n  }\n}\n```\n\n## 配置优化\n\n```json\n{\n  "compilerOptions": {\n    "target": "ES2020",\n    "module": "ESNext",\n    "moduleResolution": "node",\n    "strict": true,\n    "esModuleInterop": true,\n    "skipLibCheck": true,\n    "forceConsistentCasingInFileNames": true,\n    "declaration": true,\n    "outDir": "./dist",\n    "rootDir": "./src"\n  }\n}\n```\n\nTypeScript 的强类型系统和丰富的语言特性，让大型项目的开发和维护变得更加容易。',
'TypeScript 为 JavaScript 添加了静态类型检查。本文介绍了 TypeScript 的高级特性，包括泛型、装饰器、模块系统等进阶开发技巧。',
'Frontend', '前端开发', 'TypeScript,JavaScript', true, 567, 13, '2024-01-25 09:30:00', '2024-01-25 09:30:00'),

(9, 'Java 并发编程实战', 
'Java 并发编程是后端开发的重要技能，本文将介绍一些实用的并发编程技巧。\n\n## 线程池的使用\n\n```java\n// 创建线程池\nExecutorService executor = Executors.newFixedThreadPool(10);\n\n// 提交任务\nexecutor.submit(() -> {\n    // 执行任务\n    System.out.println("Task executed by " + Thread.currentThread().getName());\n});\n\n// 关闭线程池\nexecutor.shutdown();\n```\n\n## 同步机制\n\n### synchronized 关键字\n\n```java\npublic class Counter {\n    private int count = 0;\n    \n    public synchronized void increment() {\n        count++;\n    }\n    \n    public synchronized int getCount() {\n        return count;\n    }\n}\n```\n\n### ReentrantLock\n\n```java\npublic class Counter {\n    private final ReentrantLock lock = new ReentrantLock();\n    private int count = 0;\n    \n    public void increment() {\n        lock.lock();\n        try {\n            count++;\n        } finally {\n            lock.unlock();\n        }\n    }\n}\n```\n\n## 并发集合\n\n```java\n// 线程安全的 Map\nConcurrentHashMap<String, String> map = new ConcurrentHashMap<>();\n\n// 线程安全的 Queue\nBlockingQueue<String> queue = new LinkedBlockingQueue<>();\n```\n\n掌握这些并发编程技巧，能够编写出高性能的多线程应用。',
'Java 并发编程是后端开发的重要技能。本文介绍了线程池、同步机制、并发集合等关键概念和实用技巧。',
'Backend', '后端开发', 'Java,并发编程', true, 445, 8, '2024-01-14 11:45:00', '2024-01-14 11:45:00'),

(10, 'Kubernetes 容器编排实践',
'Kubernetes 是目前最流行的容器编排平台，本文介绍其核心概念和实际应用。\n\n## 核心概念\n\n### Pod\n\n```yaml\napiVersion: v1\nkind: Pod\nmetadata:\n  name: nginx-pod\n  labels:\n    app: nginx\nspec:\n  containers:\n  - name: nginx\n    image: nginx:1.20\n    ports:\n    - containerPort: 80\n    resources:\n      requests:\n        memory: "64Mi"\n        cpu: "250m"\n      limits:\n        memory: "128Mi"\n        cpu: "500m"\n```\n\n### Deployment\n\n```yaml\napiVersion: apps/v1\nkind: Deployment\nmetadata:\n  name: nginx-deployment\nspec:\n  replicas: 3\n  selector:\n    matchLabels:\n      app: nginx\n  template:\n    metadata:\n      labels:\n        app: nginx\n    spec:\n      containers:\n      - name: nginx\n        image: nginx:1.20\n        ports:\n        - containerPort: 80\n```\n\n### Service\n\n```yaml\napiVersion: v1\nkind: Service\nmetadata:\n  name: nginx-service\nspec:\n  selector:\n    app: nginx\n  ports:\n  - protocol: TCP\n    port: 80\n    targetPort: 80\n  type: LoadBalancer\n```\n\n## 常用命令\n\n```bash\n# 查看 Pod\nkubectl get pods\n\n# 查看服务\nkubectl get services\n\n# 应用配置\nkubectl apply -f deployment.yaml\n\n# 查看日志\nkubectl logs pod-name\n\n# 进入容器\nkubectl exec -it pod-name -- /bin/bash\n```\n\n## 最佳实践\n\n1. **资源限制**：为容器设置合理的资源请求和限制\n2. **健康检查**：配置 liveness 和 readiness 探针\n3. **配置管理**：使用 ConfigMap 和 Secret 管理配置\n4. **滚动更新**：使用 Deployment 实现零停机部署\n\n## 监控和日志\n\n```yaml\n# Prometheus 监控配置\napiVersion: v1\nkind: ServiceMonitor\nmetadata:\n  name: nginx-monitor\nspec:\n  selector:\n    matchLabels:\n      app: nginx\n  endpoints:\n  - port: metrics\n```\n\nKubernetes 提供了强大的容器编排能力，是现代云原生应用的基础设施。',
'Kubernetes 是目前最流行的容器编排平台。本文介绍了 K8s 的核心概念、常用命令和最佳实践，帮助你快速上手容器编排。',
'DevOps', '运维部署', 'Kubernetes,容器编排', true, 589, 14, '2024-01-28 10:15:00', '2024-01-28 10:15:00'),

(11, 'Node.js 性能优化技巧',
'Node.js 在服务端开发中越来越受欢迎，本文分享一些实用的性能优化技巧。\n\n## 事件循环优化\n\n```javascript\n// 避免阻塞事件循环\nfunction heavyComputation(data) {\n  return new Promise((resolve) => {\n    setImmediate(() => {\n      // 将计算密集型任务放到下一个事件循环\n      const result = processData(data);\n      resolve(result);\n    });\n  });\n}\n\n// 使用 Worker Threads 处理 CPU 密集型任务\nconst { Worker, isMainThread, parentPort } = require(\'worker_threads\');\n\nif (isMainThread) {\n  const worker = new Worker(__filename);\n  worker.postMessage({ data: largeDataSet });\n  worker.on(\'message\', (result) => {\n    console.log(\'Result:\', result);\n  });\n} else {\n  parentPort.on(\'message\', ({ data }) => {\n    const result = heavyProcessing(data);\n    parentPort.postMessage(result);\n  });\n}\n```\n\n## 内存管理\n\n```javascript\n// 避免内存泄漏\nclass DataProcessor {\n  constructor() {\n    this.cache = new Map();\n    this.maxCacheSize = 1000;\n  }\n  \n  process(key, data) {\n    // 限制缓存大小\n    if (this.cache.size >= this.maxCacheSize) {\n      const firstKey = this.cache.keys().next().value;\n      this.cache.delete(firstKey);\n    }\n    \n    this.cache.set(key, data);\n  }\n  \n  cleanup() {\n    this.cache.clear();\n  }\n}\n\n// 使用流处理大文件\nconst fs = require(\'fs\');\nconst readline = require(\'readline\');\n\nasync function processLargeFile(filename) {\n  const fileStream = fs.createReadStream(filename);\n  const rl = readline.createInterface({\n    input: fileStream,\n    crlfDelay: Infinity\n  });\n  \n  for await (const line of rl) {\n    // 逐行处理，避免将整个文件加载到内存\n    processLine(line);\n  }\n}\n```\n\n## 数据库优化\n\n```javascript\n// 连接池配置\nconst mysql = require(\'mysql2/promise\');\n\nconst pool = mysql.createPool({\n  host: \'localhost\',\n  user: \'root\',\n  password: \'password\',\n  database: \'mydb\',\n  waitForConnections: true,\n  connectionLimit: 10,\n  queueLimit: 0\n});\n\n// 批量操作\nasync function batchInsert(users) {\n  const values = users.map(user => [user.name, user.email]);\n  const sql = \'INSERT INTO users (name, email) VALUES ?\';\n  \n  try {\n    const [result] = await pool.execute(sql, [values]);\n    return result;\n  } catch (error) {\n    console.error(\'Batch insert error:\', error);\n    throw error;\n  }\n}\n```\n\n## 缓存策略\n\n```javascript\n// Redis 缓存\nconst redis = require(\'redis\');\nconst client = redis.createClient();\n\nclass CacheService {\n  async get(key) {\n    try {\n      const value = await client.get(key);\n      return value ? JSON.parse(value) : null;\n    } catch (error) {\n      console.error(\'Cache get error:\', error);\n      return null;\n    }\n  }\n  \n  async set(key, value, ttl = 3600) {\n    try {\n      await client.setEx(key, ttl, JSON.stringify(value));\n    } catch (error) {\n      console.error(\'Cache set error:\', error);\n    }\n  }\n}\n```\n\n## 监控和分析\n\n```javascript\n// 性能监控\nconst performanceHooks = require(\'perf_hooks\');\n\nfunction measurePerformance(fn, name) {\n  return async (...args) => {\n    const start = performanceHooks.performance.now();\n    const result = await fn(...args);\n    const end = performanceHooks.performance.now();\n    \n    console.log(`${name} took ${end - start} milliseconds`);\n    return result;\n  };\n}\n```\n\n通过这些优化技巧，可以显著提升 Node.js 应用的性能和稳定性。',
'Node.js 在服务端开发中越来越受欢迎。本文分享了事件循环优化、内存管理、数据库优化等实用的 Node.js 性能优化技巧。',
'Backend', '后端开发', 'Node.js,性能优化', true, 423, 11, '2024-01-30 15:20:00', '2024-01-30 15:20:00'),

(12, 'Python 数据分析入门',
'Python 在数据分析领域有着广泛的应用，本文介绍常用的数据分析库和技巧。\n\n## Pandas 数据处理\n\n```python\nimport pandas as pd\nimport numpy as np\n\n# 读取数据\ndf = pd.read_csv(\'data.csv\')\n\n# 数据清洗\ndf.dropna()  # 删除空值\ndf.fillna(0)  # 填充空值\ndf.drop_duplicates()  # 删除重复值\n\n# 数据筛选\nfiltered_df = df[df[\'age\'] > 25]\nresult = df.groupby(\'category\').agg({\n    \'sales\': [\'sum\', \'mean\'],\n    \'quantity\': \'count\'\n})\n```\n\n## NumPy 数值计算\n\n```python\nimport numpy as np\n\n# 创建数组\narr = np.array([1, 2, 3, 4, 5])\nmatrix = np.random.rand(3, 3)\n\n# 数学运算\nmean_val = np.mean(arr)\nstd_val = np.std(arr)\ncorr_matrix = np.corrcoef(matrix)\n\n# 数组操作\nreshaped = arr.reshape(5, 1)\nfiltered = arr[arr > 2]\n```\n\n## Matplotlib 数据可视化\n\n```python\nimport matplotlib.pyplot as plt\nimport seaborn as sns\n\n# 基础图表\nplt.figure(figsize=(10, 6))\nplt.plot(x, y, label=\'Line Plot\')\nplt.scatter(x, y, label=\'Scatter Plot\')\nplt.hist(data, bins=20, alpha=0.7)\nplt.legend()\nplt.show()\n\n# 高级图表\nsns.heatmap(correlation_matrix, annot=True)\nsns.boxplot(x=\'category\', y=\'value\', data=df)\n```\n\n## 数据分析流程\n\n1. **数据收集**：从各种数据源获取数据\n2. **数据清洗**：处理缺失值、异常值\n3. **探索性分析**：了解数据分布和特征\n4. **特征工程**：创建新特征，转换数据\n5. **建模分析**：应用统计模型或机器学习\n6. **结果解释**：解释分析结果并提出建议\n\n## 实际案例\n\n```python\n# 销售数据分析\nsales_data = pd.read_csv(\'sales.csv\')\n\n# 月度销售趋势\nmonthly_sales = sales_data.groupby(\'month\')[\'revenue\'].sum()\nplt.plot(monthly_sales.index, monthly_sales.values)\nplt.title(\'Monthly Sales Trend\')\n\n# 产品类别分析\ncategory_analysis = sales_data.groupby(\'category\').agg({\n    \'revenue\': \'sum\',\n    \'quantity\': \'sum\',\n    \'profit_margin\': \'mean\'\n})\n```\n\nPython 强大的数据分析生态系统让数据处理变得简单高效。',
'Python 在数据分析领域有着广泛的应用。本文介绍了 Pandas、NumPy、Matplotlib 等常用库的使用方法和数据分析的基本流程。',
'DataAnalyst', '数据分析', 'Python,数据分析', true, 456, 12, '2024-02-01 09:45:00', '2024-02-01 09:45:00'),

(7, 'Docker 容器化部署实践', 
'Docker 容器化技术已经成为现代应用部署的标准方式。本文将介绍 Docker 的基本概念和实践应用。\n\n## Docker 基础\n\nDocker 是一个开源的容器化平台，可以将应用程序及其依赖打包到轻量级、可移植的容器中。\n\n## Dockerfile 编写\n\n```dockerfile\nFROM openjdk:11-jre-slim\n\nWORKDIR /app\n\nCOPY target/myapp.jar app.jar\n\nEXPOSE 8080\n\nCMD ["java", "-jar", "app.jar"]\n```\n\n## Docker Compose\n\n```yaml\nversion: "3.8"\nservices:\n  app:\n    build: .\n    ports:\n      - "8080:8080"\n    depends_on:\n      - db\n  db:\n    image: mysql:8.0\n    environment:\n      MYSQL_ROOT_PASSWORD: password\n      MYSQL_DATABASE: myapp\n```\n\n## 最佳实践\n\n1. **使用多阶段构建**减小镜像大小\n2. **合理使用缓存**提高构建速度\n3. **安全扫描**确保镜像安全\n\nDocker 大大简化了应用的部署和运维工作。',
'Docker 容器化技术已经成为现代应用部署的标准方式。本文将介绍 Docker 的基本概念、Dockerfile 编写和部署实践。',
'Author2', '项目经验', 'Docker,容器化,部署,项目经验', true, 567, 14, '2024-01-09 15:10:00', '2024-01-09 15:10:00'),

(8, 'TypeScript 进阶技巧', 
'TypeScript 为 JavaScript 添加了静态类型检查，提高了代码质量和开发效率。\n\n## 高级类型\n\n```typescript\n// 联合类型\ntype Status = "loading" | "success" | "error";\n\n// 交叉类型\ntype User = { name: string } & { age: number };\n\n// 条件类型\ntype NonNullable<T> = T extends null | undefined ? never : T;\n```\n\n## 泛型\n\n```typescript\nfunction identity<T>(arg: T): T {\n  return arg;\n}\n\ninterface GenericIdentityFn<T> {\n  (arg: T): T;\n}\n```\n\n## 装饰器\n\n```typescript\nfunction logged(target: any, propertyKey: string, descriptor: PropertyDescriptor) {\n  const originalMethod = descriptor.value;\n  \n  descriptor.value = function(...args: any[]) {\n    console.log(`Calling ${propertyKey} with`, args);\n    return originalMethod.apply(this, args);\n  };\n}\n\nclass Calculator {\n  @logged\n  add(a: number, b: number) {\n    return a + b;\n  }\n}\n```\n\nTypeScript 的强大类型系统让大型项目的维护变得更加容易。',
'TypeScript 为 JavaScript 添加了静态类型检查。本文将介绍 TypeScript 的高级类型、泛型、装饰器等进阶技巧。',
'Author1', '前端开发', 'TypeScript,JavaScript,前端开发', true, 445, 11, '2024-01-11 09:25:00', '2024-01-11 09:25:00'),

(9, 'Redis 缓存策略与实践', 
'Redis 是一个高性能的内存数据库，广泛用于缓存、会话存储等场景。\n\n## Redis 基本数据类型\n\n```redis\n# 字符串\nSET key "value"\nGET key\n\n# 哈希\nHSET user:1 name "John" age 30\nHGET user:1 name\n\n# 列表\nLPUSH mylist "item1" "item2"\nLRANGE mylist 0 -1\n\n# 集合\nSADD myset "member1" "member2"\nSMEMBERS myset\n```\n\n## 缓存策略\n\n1. **Cache-Aside**：应用程序直接管理缓存\n2. **Write-Through**：写入时同时更新缓存\n3. **Write-Behind**：异步写入数据库\n\n## Spring Boot 集成\n\n```java\n@Service\npublic class UserService {\n    \n    @Autowired\n    private RedisTemplate<String, Object> redisTemplate;\n    \n    @Cacheable(value = "users", key = "#id")\n    public User getUserById(Long id) {\n        return userRepository.findById(id);\n    }\n    \n    @CacheEvict(value = "users", key = "#user.id")\n    public void updateUser(User user) {\n        userRepository.save(user);\n    }\n}\n```\n\n合理使用 Redis 可以显著提升应用性能。',
'Redis 是一个高性能的内存数据库，广泛用于缓存场景。本文将介绍 Redis 的基本使用、缓存策略和 Spring Boot 集成实践。',
'Admin', '数据库', 'Redis,缓存,数据库,后端开发', true, 678, 16, '2024-01-06 14:15:00', '2024-01-06 14:15:00'),

(10, '前端性能优化实战', 
'前端性能优化是提升用户体验的关键。本文将介绍各种前端性能优化技巧和最佳实践。\n\n## 资源优化\n\n1. **图片优化**\n   - 使用 WebP 格式\n   - 图片懒加载\n   - 响应式图片\n\n2. **代码分割**\n\n```javascript\n// 动态导入\nconst LazyComponent = React.lazy(() => import("./LazyComponent"));\n\n// Webpack 代码分割\nimport(/* webpackChunkName: "lodash" */ "lodash").then((_) => {\n  // 使用 lodash\n});\n```\n\n## 缓存策略\n\n```javascript\n// Service Worker 缓存\nself.addEventListener("fetch", (event) => {\n  event.respondWith(\n    caches.match(event.request).then((response) => {\n      return response || fetch(event.request);\n    })\n  );\n});\n```\n\n## 性能监控\n\n```javascript\n// Performance API\nconst observer = new PerformanceObserver((list) => {\n  for (const entry of list.getEntries()) {\n    console.log(entry.name, entry.duration);\n  }\n});\n\nobserver.observe({ entryTypes: ["measure", "navigation"] });\n```\n\n性能优化是一个持续的过程，需要不断监控和改进。',
'前端性能优化是提升用户体验的关键。本文将介绍资源优化、代码分割、缓存策略等各种性能优化技巧和最佳实践。',
'Author2', '前端开发', '性能优化,前端开发,JavaScript', true, 534, 13, '2024-01-13 10:40:00', '2024-01-13 10:40:00');

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
(3, 24), (3, 51),
-- React Hooks 最佳实践指南
(4, 2), (4, 4),
-- Docker 容器化部署实战
(5, 29), (5, 54),
-- JavaScript ES6+ 新特性详解
(6, 4), (6, 5),
-- Redis 缓存策略与实践
(7, 27), (7, 51),
-- TypeScript 进阶开发指南
(8, 4), (8, 5),
-- Java 并发编程实战
(9, 13), (9, 51),
-- Kubernetes 容器编排实践
(10, 29), (10, 30), (10, 54),
-- Node.js 性能优化技巧
(11, 12), (11, 51),
-- Python 数据分析入门
(12, 16), (12, 60);

-- 插入用户点赞记录数据
INSERT IGNORE INTO user_likes (user_id, blog_id, created_at) VALUES
-- 用户1的点赞记录
(2, 1, '2024-01-15 11:00:00'),  -- 点赞Vue文章
(2, 3, '2024-01-15 12:00:00'),  -- 点赞MySQL文章
(2, 4, '2024-01-15 13:00:00'),  -- 点赞JavaScript文章
(2, 6, '2024-01-15 14:00:00'),  -- 点赞React文章
(2, 10, '2024-01-15 15:00:00'), -- 点赞性能优化文章

-- 用户2的点赞记录
(3, 1, '2024-01-15 16:00:00'),  -- 点赞Vue文章
(3, 2, '2024-01-15 17:00:00'),  -- 点赞Spring Boot文章
(3, 5, '2024-01-15 18:00:00'),  -- 点赞Java并发文章
(3, 7, '2024-01-15 19:00:00'),  -- 点赞Docker文章
(3, 9, '2024-01-15 20:00:00'),  -- 点赞Redis文章

-- 作者1的点赞记录
(4, 2, '2024-01-16 09:00:00'),  -- 点赞Spring Boot文章
(4, 3, '2024-01-16 10:00:00'),  -- 点赞MySQL文章
(4, 6, '2024-01-16 11:00:00'),  -- 点赞React文章
(4, 7, '2024-01-16 12:00:00'),  -- 点赞Docker文章
(4, 9, '2024-01-16 13:00:00'),  -- 点赞Redis文章
(4, 10, '2024-01-16 14:00:00'), -- 点赞性能优化文章

-- 作者2的点赞记录
(5, 1, '2024-01-16 15:00:00'),  -- 点赞Vue文章
(5, 2, '2024-01-16 16:00:00'),  -- 点赞Spring Boot文章
(5, 3, '2024-01-16 17:00:00'),  -- 点赞MySQL文章
(5, 4, '2024-01-16 18:00:00'),  -- 点赞JavaScript文章
(5, 5, '2024-01-16 19:00:00'),  -- 点赞Java并发文章
(5, 8, '2024-01-16 20:00:00');  -- 点赞TypeScript文章