-- 插入示例数据

-- 插入用户数据
INSERT IGNORE INTO users (id, account, username, email, password, full_name, is_admin, is_active) VALUES
(1, 'admin', 'Admin', 'admin@example.com', 'admin123', '系统管理员', true, true),
(2, 'user1', 'User1', 'user1@example.com', 'user123', '普通用户1', false, true),
(3, 'user2', 'User2', 'user2@example.com', 'user123', '普通用户2', false, true),
(4, 'author1', 'Author1', 'author1@example.com', 'author123', '作者1', false, true),
(5, 'author2', 'Author2', 'author2@example.com', 'author123', '作者2', false, true);

-- 插入分类数据
INSERT IGNORE INTO categories (id, name, slug, description, is_active, blog_count) VALUES
(1, '技术分享', 'tech', '技术相关的文章分享', true, 0),
(2, '生活随笔', 'life', '生活感悟和随笔', true, 0),
(3, '学习笔记', 'study', '学习过程中的笔记和总结', true, 0),
(4, '项目经验', 'project', '项目开发经验分享', true, 0),
(5, '前端开发', 'frontend', '前端开发技术', true, 0),
(6, '后端开发', 'backend', '后端开发技术', true, 0),
(7, '数据库', 'database', '数据库相关技术', true, 0);

-- 插入标签数据
INSERT IGNORE INTO tags (id, name, slug, description, color, is_active) VALUES
(1, 'Vue.js', 'vue-js', 'Vue.js前端框架', '#4FC08D', true),
(2, 'Spring Boot', 'spring-boot', 'Spring Boot后端框架', '#6DB33F', true),
(3, 'JavaScript', 'javascript', 'JavaScript编程语言', '#F7DF1E', true),
(4, 'Java', 'java', 'Java编程语言', '#ED8B00', true),
(5, 'MySQL', 'mysql', 'MySQL数据库', '#4479A1', true),
(6, '前端开发', 'frontend-dev', '前端开发技术', '#61DAFB', true),
(7, '后端开发', 'backend-dev', '后端开发技术', '#68217A', true),
(8, '数据库', 'database', '数据库技术', '#336791', true),
(9, '算法', 'algorithm', '算法和数据结构', '#FF6B6B', true),
(10, '架构设计', 'architecture', '系统架构设计', '#4ECDC4', true);

-- 插入博客数据
INSERT IGNORE INTO blogs (id, title, content, summary, author_name, category, tags, is_published, view_count, like_count, created_at, published_at) VALUES
(1, 'Vue 3 Composition API 深入解析', 
'Vue 3 引入了 Composition API，这是一个全新的 API 设计，让我们能够更好地组织和复用代码逻辑。\n\n## 什么是 Composition API\n\nComposition API 是 Vue 3 中新增的一套 API，它提供了一种更灵活的方式来组织组件逻辑。与 Options API 不同，Composition API 允许我们将相关的逻辑组织在一起，而不是按照选项类型分离。\n\n## 基本用法\n\n```javascript\nimport { ref, computed, onMounted } from "vue"\n\nexport default {\n  setup() {\n    const count = ref(0)\n    const doubleCount = computed(() => count.value * 2)\n    \n    const increment = () => {\n      count.value++\n    }\n    \n    onMounted(() => {\n      console.log("组件已挂载")\n    })\n    \n    return {\n      count,\n      doubleCount,\n      increment\n    }\n  }\n}\n```\n\n## 优势\n\n1. **更好的逻辑复用**：可以将相关逻辑提取到可复用的函数中\n2. **更好的类型推导**：TypeScript 支持更好\n3. **更灵活的代码组织**：相关逻辑可以组织在一起\n\n## 总结\n\nComposition API 为 Vue 3 带来了更强大的功能和更好的开发体验，值得深入学习和使用。',
'Vue 3 引入了 Composition API，这是一个全新的 API 设计，让我们能够更好地组织和复用代码逻辑。本文将深入解析 Composition API 的使用方法和优势。',
'Admin', '前端开发', 'Vue.js,JavaScript,前端开发', true, 1250, 25, '2024-01-15 10:00:00', '2024-01-15 10:00:00'),

(2, 'Spring Boot 微服务架构实践', 
'在现代软件开发中，微服务架构已经成为了主流的架构模式。Spring Boot 为我们提供了强大的工具来构建微服务应用。\n\n## 微服务架构概述\n\n微服务架构是一种将单一应用程序开发为一组小型服务的方法，每个服务运行在自己的进程中，并使用轻量级机制（通常是 HTTP API）进行通信。\n\n## Spring Boot 在微服务中的优势\n\n1. **快速开发**：Spring Boot 的自动配置大大简化了开发过程\n2. **独立部署**：每个服务可以独立部署和扩展\n3. **技术多样性**：不同服务可以使用不同的技术栈\n\n## 实践案例\n\n```java\n@SpringBootApplication\n@EnableEurekaClient\npublic class UserServiceApplication {\n    public static void main(String[] args) {\n        SpringApplication.run(UserServiceApplication.class, args);\n    }\n}\n\n@RestController\n@RequestMapping("/api/users")\npublic class UserController {\n    \n    @Autowired\n    private UserService userService;\n    \n    @GetMapping("/{id}")\n    public ResponseEntity<User> getUser(@PathVariable Long id) {\n        User user = userService.findById(id);\n        return ResponseEntity.ok(user);\n    }\n}\n```\n\n## 最佳实践\n\n1. **服务拆分原则**：按业务能力拆分\n2. **数据管理**：每个服务管理自己的数据\n3. **容错处理**：实现熔断和降级机制\n\n微服务架构虽然复杂，但带来的好处是显著的，值得在合适的场景下采用。',
'在现代软件开发中，微服务架构已经成为了主流的架构模式。本文将介绍如何使用 Spring Boot 构建微服务应用，包括最佳实践和实际案例。',
'Admin', '后端开发', 'Spring Boot,微服务,Java,后端开发', true, 980, 18, '2024-01-10 14:30:00', '2024-01-10 14:30:00'),

(3, 'MySQL 性能优化技巧', 
'数据库性能优化是后端开发中的重要技能。本文将介绍一些实用的 MySQL 性能优化技巧。\n\n## 索引优化\n\n索引是提高查询性能的最重要手段：\n\n```sql\n-- 创建复合索引\nCREATE INDEX idx_user_status_created ON users(status, created_at);\n\n-- 查看索引使用情况\nEXPLAIN SELECT * FROM users WHERE status = 1 ORDER BY created_at;\n```\n\n## 查询优化\n\n1. **避免 SELECT ***：只查询需要的字段\n2. **使用 LIMIT**：限制返回结果数量\n3. **优化 WHERE 条件**：将选择性高的条件放在前面\n\n## 配置优化\n\n```ini\n# my.cnf 配置示例\ninnodb_buffer_pool_size = 1G\ninnodb_log_file_size = 256M\nquery_cache_size = 128M\n```\n\n## 监控和分析\n\n使用 EXPLAIN 分析查询执行计划，使用慢查询日志找出性能瓶颈。\n\n性能优化是一个持续的过程，需要根据实际情况不断调整和改进。',
'数据库性能优化是后端开发中的重要技能。本文将介绍一些实用的 MySQL 性能优化技巧，包括索引优化、查询优化和配置优化。',
'Admin', '数据库', 'MySQL,性能优化,数据库', true, 756, 12, '2024-01-05 09:15:00', '2024-01-05 09:15:00'),

(4, 'JavaScript ES6+ 新特性详解', 
'ES6+ 为 JavaScript 带来了许多新特性，大大提升了开发效率和代码质量。\n\n## 箭头函数\n\n```javascript\n// 传统函数\nfunction add(a, b) {\n  return a + b;\n}\n\n// 箭头函数\nconst add = (a, b) => a + b;\n```\n\n## 解构赋值\n\n```javascript\n// 数组解构\nconst [first, second] = [1, 2, 3];\n\n// 对象解构\nconst { name, age } = { name: "John", age: 30 };\n```\n\n## Promise 和 async/await\n\n```javascript\n// Promise\nfetch("/api/data")\n  .then(response => response.json())\n  .then(data => console.log(data));\n\n// async/await\nasync function fetchData() {\n  try {\n    const response = await fetch("/api/data");\n    const data = await response.json();\n    console.log(data);\n  } catch (error) {\n    console.error(error);\n  }\n}\n```\n\n这些新特性让 JavaScript 代码更加简洁和易读。',
'ES6+ 为 JavaScript 带来了许多新特性，本文将详细介绍箭头函数、解构赋值、Promise 等重要特性的使用方法。',
'Author1', '前端开发', 'JavaScript,ES6,前端开发', true, 892, 22, '2024-01-08 16:20:00', '2024-01-08 16:20:00'),

(5, 'Java 并发编程实战', 
'Java 并发编程是高级 Java 开发者必须掌握的技能。本文将介绍 Java 并发编程的核心概念和实践技巧。\n\n## 线程基础\n\n```java\n// 创建线程的三种方式\n\n// 1. 继承 Thread 类\nclass MyThread extends Thread {\n    @Override\n    public void run() {\n        System.out.println("Thread running");\n    }\n}\n\n// 2. 实现 Runnable 接口\nclass MyRunnable implements Runnable {\n    @Override\n    public void run() {\n        System.out.println("Runnable running");\n    }\n}\n\n// 3. 使用 Lambda 表达式\nThread thread = new Thread(() -> {\n    System.out.println("Lambda thread running");\n});\n```\n\n## 线程池\n\n```java\nExecutorService executor = Executors.newFixedThreadPool(10);\n\nexecutor.submit(() -> {\n    // 任务逻辑\n});\n\nexecutor.shutdown();\n```\n\n## 同步机制\n\n1. **synchronized 关键字**\n2. **ReentrantLock**\n3. **CountDownLatch**\n4. **CyclicBarrier**\n\n并发编程需要谨慎处理线程安全问题，合理使用同步机制。',
'Java 并发编程是高级开发者必须掌握的技能。本文将介绍线程基础、线程池、同步机制等核心概念和实践技巧。',
'Author1', '后端开发', 'Java,并发编程,后端开发', true, 634, 15, '2024-01-12 11:45:00', '2024-01-12 11:45:00'),

(6, 'React Hooks 完全指南', 
'React Hooks 改变了我们编写 React 组件的方式，让函数组件拥有了状态管理能力。\n\n## useState Hook\n\n```jsx\nimport React, { useState } from "react";\n\nfunction Counter() {\n  const [count, setCount] = useState(0);\n\n  return (\n    <div>\n      <p>Count: {count}</p>\n      <button onClick={() => setCount(count + 1)}>\n        Increment\n      </button>\n    </div>\n  );\n}\n```\n\n## useEffect Hook\n\n```jsx\nimport React, { useState, useEffect } from "react";\n\nfunction UserProfile({ userId }) {\n  const [user, setUser] = useState(null);\n\n  useEffect(() => {\n    fetchUser(userId).then(setUser);\n  }, [userId]);\n\n  return user ? <div>{user.name}</div> : <div>Loading...</div>;\n}\n```\n\n## 自定义 Hook\n\n```jsx\nfunction useCounter(initialValue = 0) {\n  const [count, setCount] = useState(initialValue);\n\n  const increment = () => setCount(count + 1);\n  const decrement = () => setCount(count - 1);\n  const reset = () => setCount(initialValue);\n\n  return { count, increment, decrement, reset };\n}\n```\n\nHooks 让 React 开发更加简洁和强大。',
'React Hooks 改变了我们编写 React 组件的方式。本文将全面介绍 useState、useEffect 等常用 Hooks 的使用方法和最佳实践。',
'Author2', '前端开发', 'React,Hooks,JavaScript,前端开发', true, 723, 19, '2024-01-07 13:30:00', '2024-01-07 13:30:00'),

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

-- 插入博客标签关联数据
INSERT IGNORE INTO blog_tags (blog_id, tag_id) VALUES
-- Vue 3 Composition API 深入解析
(1, (SELECT id FROM tags WHERE name = 'Vue.js')),
(1, (SELECT id FROM tags WHERE name = 'JavaScript')),
(1, (SELECT id FROM tags WHERE name = '前端开发')),

-- Spring Boot 微服务架构实践
(2, (SELECT id FROM tags WHERE name = 'Spring Boot')),
(2, (SELECT id FROM tags WHERE name = 'Java')),
(2, (SELECT id FROM tags WHERE name = '后端开发')),

-- MySQL 性能优化技巧
(3, (SELECT id FROM tags WHERE name = 'MySQL')),
(3, (SELECT id FROM tags WHERE name = '数据库')),

-- JavaScript ES6+ 新特性详解
(4, (SELECT id FROM tags WHERE name = 'JavaScript')),
(4, (SELECT id FROM tags WHERE name = '前端开发')),

-- Java 并发编程实战
(5, (SELECT id FROM tags WHERE name = 'Java')),
(5, (SELECT id FROM tags WHERE name = '后端开发')),

-- React Hooks 完全指南
(6, (SELECT id FROM tags WHERE name = 'JavaScript')),
(6, (SELECT id FROM tags WHERE name = '前端开发')),

-- Docker 容器化部署实践
(7, (SELECT id FROM tags WHERE name = '后端开发')),

-- TypeScript 进阶技巧
(8, (SELECT id FROM tags WHERE name = 'JavaScript')),
(8, (SELECT id FROM tags WHERE name = '前端开发')),

-- Redis 缓存策略与实践
(9, (SELECT id FROM tags WHERE name = '数据库')),
(9, (SELECT id FROM tags WHERE name = '后端开发')),

-- 前端性能优化实战
(10, (SELECT id FROM tags WHERE name = 'JavaScript')),
(10, (SELECT id FROM tags WHERE name = '前端开发'));

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