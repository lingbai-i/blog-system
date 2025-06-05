-- 博客系统初始化数据
-- 插入基础数据

-- 插入系统配置
INSERT IGNORE INTO system_configs (config_key, config_value, config_type, description, is_public) VALUES
('site_title', '个人博客系统', 'string', '网站标题', true),
('site_description', '基于Spring Boot + Vue.js的现代化博客系统', 'string', '网站描述', true),
('site_keywords', 'blog,博客,Spring Boot,Vue.js,技术分享', 'string', '网站关键词', true),
('site_author', '博客管理员', 'string', '网站作者', true),
('site_email', 'admin@blog.com', 'string', '联系邮箱', true),
('posts_per_page', '10', 'number', '每页文章数量', true),
('comments_per_page', '20', 'number', '每页评论数量', true),
('allow_comments', 'true', 'boolean', '是否允许评论', true),
('comment_approval', 'false', 'boolean', '评论是否需要审核', true),
('site_logo', '/images/logo.png', 'string', '网站Logo', true),
('site_favicon', '/images/favicon.ico', 'string', '网站图标', true),
('analytics_code', '', 'text', '统计代码', false),
('seo_enabled', 'true', 'boolean', '是否启用SEO优化', true),
('cache_enabled', 'true', 'boolean', '是否启用缓存', false),
('backup_enabled', 'false', 'boolean', '是否启用自动备份', false);

-- 插入默认分类
INSERT IGNORE INTO categories (name, slug, description, sort_order, is_active, blog_count) VALUES
('技术教程', 'tech-tutorial', '技术相关的教程和指南', 1, true, 0),
('编程语言', 'programming', '各种编程语言的学习和实践', 2, true, 0),
('框架技术', 'framework', '主流开发框架的使用和原理', 3, true, 0),
('数据库', 'database', '数据库设计、优化和管理', 4, true, 0),
('前端开发', 'frontend', '前端技术和用户体验', 5, true, 0),
('后端开发', 'backend', '后端架构和服务开发', 6, true, 0),
('DevOps', 'devops', '运维、部署和持续集成', 7, true, 0),
('算法数据结构', 'algorithm', '算法学习和数据结构', 8, true, 0),
('系统设计', 'system-design', '系统架构和设计模式', 9, true, 0),
('工具软件', 'tools', '开发工具和效率软件', 10, true, 0),
('职业发展', 'career', '程序员职业规划和成长', 11, true, 0),
('技术分享', 'sharing', '技术心得和经验分享', 12, true, 0),
('项目实战', 'project', '实际项目开发经验', 13, true, 0),
('学习笔记', 'notes', '学习过程中的笔记和总结', 14, true, 0),
('其他', 'others', '其他技术相关内容', 15, true, 0);

-- 插入常用标签
INSERT IGNORE INTO tags (name, slug, description, color, usage_count) VALUES
('Java', 'java', 'Java编程语言', '#f89820', 0),
('Spring Boot', 'spring-boot', 'Spring Boot框架', '#6db33f', 0),
('Spring', 'spring', 'Spring框架', '#6db33f', 0),
('MySQL', 'mysql', 'MySQL数据库', '#4479a1', 0),
('Vue.js', 'vuejs', 'Vue.js前端框架', '#4fc08d', 0),
('JavaScript', 'javascript', 'JavaScript编程语言', '#f7df1e', 0),
('HTML', 'html', 'HTML标记语言', '#e34f26', 0),
('CSS', 'css', 'CSS样式表', '#1572b6', 0),
('React', 'react', 'React前端框架', '#61dafb', 0),
('Node.js', 'nodejs', 'Node.js运行环境', '#339933', 0),
('Python', 'python', 'Python编程语言', '#3776ab', 0),
('Docker', 'docker', 'Docker容器技术', '#2496ed', 0),
('Kubernetes', 'kubernetes', 'Kubernetes容器编排', '#326ce5', 0),
('Redis', 'redis', 'Redis缓存数据库', '#dc382d', 0),
('MongoDB', 'mongodb', 'MongoDB文档数据库', '#47a248', 0),
('Git', 'git', 'Git版本控制', '#f05032', 0),
('Linux', 'linux', 'Linux操作系统', '#fcc624', 0),
('算法', 'algorithm', '算法和数据结构', '#ff6b6b', 0),
('设计模式', 'design-pattern', '软件设计模式', '#4ecdc4', 0),
('微服务', 'microservice', '微服务架构', '#45b7d1', 0),
('性能优化', 'performance', '性能优化技术', '#96ceb4', 0),
('安全', 'security', '信息安全技术', '#ffeaa7', 0),
('测试', 'testing', '软件测试技术', '#fd79a8', 0),
('CI/CD', 'cicd', '持续集成和部署', '#a29bfe', 0),
('API', 'api', 'API设计和开发', '#6c5ce7', 0),
('数据结构', 'data-structure', '数据结构', '#fd79a8', 0),
('网络编程', 'network', '网络编程技术', '#00b894', 0),
('并发编程', 'concurrent', '并发和多线程编程', '#e17055', 0),
('函数式编程', 'functional', '函数式编程', '#0984e3', 0),
('机器学习', 'machine-learning', '机器学习和AI', '#00cec9', 0);

-- 插入示例用户（密码需要在应用中加密）
-- 注意：这里的密码是明文，实际应用中会通过DataInitializer进行加密处理
INSERT IGNORE INTO users (account, username, email, password, full_name, bio, is_admin, is_active) VALUES
('admin', 'admin', 'admin@blog.com', 'admin123', '系统管理员', '博客系统管理员，负责系统维护和内容管理', true, true),
('blogger', 'blogger', 'blogger@blog.com', 'blogger123', '博客作者', '热爱写作的程序员，专注于技术分享和知识传播', false, true),
('reader', 'reader', 'reader@blog.com', 'reader123', '博客读者', '喜欢阅读技术文章，关注最新技术动态', false, true),
('developer', 'developer', 'developer@blog.com', 'dev123', '开发者', '全栈开发工程师，擅长Java和前端技术', false, true),
('student', 'student', 'student@blog.com', 'student123', '技术学生', '计算机专业学生，正在学习各种编程技术', false, true);

-- 插入示例博客文章
INSERT IGNORE INTO blogs (title, content, summary, author_name, category, tags, is_published, view_count, like_count, featured_image, meta_description, published_at) VALUES
('Spring Boot 快速入门指南', 
'# Spring Boot 快速入门指南\n\nSpring Boot 是一个基于 Spring 框架的快速开发框架，它简化了 Spring 应用的配置和部署。\n\n## 主要特性\n\n### 1. 自动配置\nSpring Boot 可以根据类路径中的依赖自动配置应用，大大减少了手动配置的工作量。\n\n### 2. 起步依赖\n提供了一系列的起步依赖（Starter），简化了依赖管理，避免了版本冲突。\n\n### 3. 内嵌服务器\n内置了 Tomcat、Jetty 等服务器，可以直接运行 jar 包，无需外部服务器。\n\n### 4. 生产就绪\n提供了健康检查、指标监控、外部化配置等生产环境功能。\n\n## 快速开始\n\n### 创建项目\n\n```bash\n# 使用 Spring Initializr 创建项目\ncurl https://start.spring.io/starter.zip \\\n  -d dependencies=web,data-jpa,mysql \\\n  -d name=demo \\\n  -o demo.zip\n```\n\n### 编写控制器\n\n```java\n@RestController\npublic class HelloController {\n    \n    @GetMapping("/hello")\n    public String hello() {\n        return "Hello, Spring Boot!";\n    }\n}\n```\n\n### 运行应用\n\n```bash\n# 运行应用\nmvn spring-boot:run\n\n# 或者打包后运行\nmvn package\njava -jar target/demo-0.0.1-SNAPSHOT.jar\n```\n\n## 总结\n\nSpring Boot 通过约定优于配置的理念，大大简化了 Spring 应用的开发过程。它是现代 Java 开发的首选框架之一。',
'Spring Boot 是一个强大的 Java 开发框架，本文详细介绍了其主要特性、快速开始方法和最佳实践。',
'博客作者', '技术教程', 'Spring Boot,Java,后端开发,框架', true, 256, 42, '/images/spring-boot-guide.jpg', 
'学习 Spring Boot 框架的完整指南，包括自动配置、起步依赖、内嵌服务器等核心特性', NOW()),

('MySQL 数据库性能优化实战', 
'# MySQL 数据库性能优化实战\n\n数据库优化是提高应用性能的重要手段，本文将介绍一些实用的 MySQL 优化技巧。\n\n## 索引优化\n\n### 1. 选择合适的索引类型\n\n- **B-Tree 索引**：适用于范围查询和排序\n- **Hash 索引**：适用于等值查询\n- **全文索引**：适用于文本搜索\n\n### 2. 复合索引设计\n\n```sql\n-- 创建复合索引\nCREATE INDEX idx_user_status_time ON users(status, created_at);\n\n-- 查询时会使用索引\nSELECT * FROM users \nWHERE status = 1 \nAND created_at > \'2023-01-01\';\n```\n\n### 3. 避免索引失效\n\n```sql\n-- 错误：在索引列上使用函数\nSELECT * FROM users WHERE YEAR(created_at) = 2023;\n\n-- 正确：使用范围查询\nSELECT * FROM users \nWHERE created_at >= \'2023-01-01\' \nAND created_at < \'2024-01-01\';\n```\n\n## 查询优化\n\n### 1. 避免 SELECT *\n\n```sql\n-- 错误\nSELECT * FROM users WHERE id = 1;\n\n-- 正确\nSELECT id, username, email FROM users WHERE id = 1;\n```\n\n### 2. 使用 LIMIT 分页\n\n```sql\n-- 分页查询\nSELECT * FROM blogs \nORDER BY created_at DESC \nLIMIT 10 OFFSET 20;\n```\n\n### 3. 优化 JOIN 查询\n\n```sql\n-- 使用适当的 JOIN 类型\nSELECT b.title, u.username\nFROM blogs b\nINNER JOIN users u ON b.author_id = u.id\nWHERE b.is_published = 1;\n```\n\n## 配置优化\n\n### 1. 内存配置\n\n```ini\n# my.cnf\ninnodb_buffer_pool_size = 1G\nquery_cache_size = 256M\ntmp_table_size = 64M\n```\n\n### 2. 连接配置\n\n```ini\nmax_connections = 200\nconnect_timeout = 10\nwait_timeout = 600\n```\n\n## 监控和分析\n\n### 1. 慢查询日志\n\n```sql\n-- 开启慢查询日志\nSET GLOBAL slow_query_log = 1;\nSET GLOBAL long_query_time = 2;\n```\n\n### 2. 执行计划分析\n\n```sql\n-- 分析查询执行计划\nEXPLAIN SELECT * FROM blogs WHERE title LIKE \'%Spring%\';\n```\n\n## 总结\n\n数据库优化是一个持续的过程，需要根据实际业务场景进行调整。定期监控和分析是保持数据库高性能的关键。',
'深入介绍 MySQL 数据库的各种优化技巧，包括索引优化、查询优化、配置调优等实战经验。',
'博客作者', '数据库', 'MySQL,数据库,性能优化,索引', true, 189, 28, '/images/mysql-optimization.jpg',
'MySQL 数据库性能优化的完整指南，涵盖索引设计、查询优化、配置调优等方面', NOW()),

('Vue.js 3.0 新特性详解', 
'# Vue.js 3.0 新特性详解\n\nVue.js 3.0 带来了许多激动人心的新特性，本文将详细介绍这些改进。\n\n## Composition API\n\n### 1. setup() 函数\n\n```javascript\nimport { ref, reactive, computed, onMounted } from \'vue\';\n\nexport default {\n  setup() {\n    // 响应式数据\n    const count = ref(0);\n    const user = reactive({\n      name: \'张三\',\n      age: 25\n    });\n\n    // 计算属性\n    const doubleCount = computed(() => count.value * 2);\n\n    // 生命周期\n    onMounted(() => {\n      console.log(\'组件已挂载\');\n    });\n\n    // 方法\n    const increment = () => {\n      count.value++;\n    };\n\n    return {\n      count,\n      user,\n      doubleCount,\n      increment\n    };\n  }\n};\n```\n\n### 2. 组合式函数\n\n```javascript\n// useCounter.js\nimport { ref } from \'vue\';\n\nexport function useCounter(initialValue = 0) {\n  const count = ref(initialValue);\n  \n  const increment = () => count.value++;\n  const decrement = () => count.value--;\n  const reset = () => count.value = initialValue;\n  \n  return {\n    count,\n    increment,\n    decrement,\n    reset\n  };\n}\n```\n\n## 性能改进\n\n### 1. 更小的包体积\n- Tree-shaking 支持\n- 按需引入\n- 运行时体积减少 41%\n\n### 2. 更快的渲染\n- 编译时优化\n- Proxy 响应式系统\n- 静态提升\n\n## TypeScript 支持\n\n```typescript\nimport { defineComponent, ref, PropType } from \'vue\';\n\ninterface User {\n  id: number;\n  name: string;\n  email: string;\n}\n\nexport default defineComponent({\n  props: {\n    user: {\n      type: Object as PropType<User>,\n      required: true\n    }\n  },\n  setup(props) {\n    const isEditing = ref(false);\n    \n    const toggleEdit = () => {\n      isEditing.value = !isEditing.value;\n    };\n    \n    return {\n      isEditing,\n      toggleEdit\n    };\n  }\n});\n```\n\n## 新的内置组件\n\n### 1. Fragment\n\n```vue\n<template>\n  <!-- 不需要根元素包装 -->\n  <header>头部</header>\n  <main>主要内容</main>\n  <footer>底部</footer>\n</template>\n```\n\n### 2. Teleport\n\n```vue\n<template>\n  <div>\n    <h1>主要内容</h1>\n    \n    <!-- 传送到 body -->\n    <Teleport to="body">\n      <div class="modal">\n        模态框内容\n      </div>\n    </Teleport>\n  </div>\n</template>\n```\n\n### 3. Suspense\n\n```vue\n<template>\n  <Suspense>\n    <template #default>\n      <AsyncComponent />\n    </template>\n    <template #fallback>\n      <div>加载中...</div>\n    </template>\n  </Suspense>\n</template>\n```\n\n## 总结\n\nVue.js 3.0 在保持易用性的同时，大幅提升了性能和开发体验。Composition API 让代码更加灵活和可复用。',
'详细介绍 Vue.js 3.0 的新特性，包括 Composition API、性能改进、TypeScript 支持等。',
'博客作者', '前端开发', 'Vue.js,前端,JavaScript,框架', true, 324, 56, '/images/vuejs3-features.jpg',
'Vue.js 3.0 新特性完整指南，包括 Composition API、性能优化、TypeScript 支持等', NOW()),

('Docker 容器化部署实践', 
'# Docker 容器化部署实践\n\n容器化技术已经成为现代应用部署的标准，本文介绍 Docker 的实际应用。\n\n## Docker 基础\n\n### 1. 核心概念\n\n- **镜像（Image）**：应用的只读模板\n- **容器（Container）**：镜像的运行实例\n- **仓库（Repository）**：镜像的存储和分发\n\n### 2. 基本命令\n\n```bash\n# 拉取镜像\ndocker pull nginx:latest\n\n# 运行容器\ndocker run -d -p 80:80 --name web nginx\n\n# 查看容器\ndocker ps\n\n# 停止容器\ndocker stop web\n\n# 删除容器\ndocker rm web\n```\n\n## Dockerfile 编写\n\n### 1. Java 应用示例\n\n```dockerfile\n# 多阶段构建\nFROM maven:3.8-openjdk-17 AS builder\n\nWORKDIR /app\nCOPY pom.xml .\nRUN mvn dependency:go-offline\n\nCOPY src ./src\nRUN mvn clean package -DskipTests\n\n# 运行阶段\nFROM openjdk:17-jre-slim\n\nWORKDIR /app\nCOPY --from=builder /app/target/*.jar app.jar\n\nEXPOSE 8080\nENTRYPOINT ["java", "-jar", "app.jar"]\n```\n\n### 2. 前端应用示例\n\n```dockerfile\n# 构建阶段\nFROM node:16-alpine AS builder\n\nWORKDIR /app\nCOPY package*.json ./\nRUN npm ci --only=production\n\nCOPY . .\nRUN npm run build\n\n# 生产阶段\nFROM nginx:alpine\n\nCOPY --from=builder /app/dist /usr/share/nginx/html\nCOPY nginx.conf /etc/nginx/nginx.conf\n\nEXPOSE 80\nCMD ["nginx", "-g", "daemon off;"]\n```\n\n## Docker Compose\n\n### 1. 多服务编排\n\n```yaml\nversion: \'3.8\'\n\nservices:\n  # 数据库\n  mysql:\n    image: mysql:8.0\n    environment:\n      MYSQL_ROOT_PASSWORD: root123\n      MYSQL_DATABASE: blog\n    volumes:\n      - mysql_data:/var/lib/mysql\n    ports:\n      - "3306:3306"\n\n  # 后端服务\n  backend:\n    build: ./backend\n    depends_on:\n      - mysql\n    environment:\n      SPRING_DATASOURCE_URL: jdbc:mysql://mysql:3306/blog\n    ports:\n      - "8080:8080"\n\n  # 前端服务\n  frontend:\n    build: ./frontend\n    depends_on:\n      - backend\n    ports:\n      - "80:80"\n\n  # Redis 缓存\n  redis:\n    image: redis:alpine\n    ports:\n      - "6379:6379"\n\nvolumes:\n  mysql_data:\n```\n\n### 2. 常用命令\n\n```bash\n# 启动所有服务\ndocker-compose up -d\n\n# 查看服务状态\ndocker-compose ps\n\n# 查看日志\ndocker-compose logs -f backend\n\n# 停止服务\ndocker-compose down\n\n# 重新构建\ndocker-compose build --no-cache\n```\n\n## 最佳实践\n\n### 1. 镜像优化\n\n```dockerfile\n# 使用多阶段构建\n# 选择合适的基础镜像\n# 减少层数\n# 清理缓存\nRUN apt-get update && apt-get install -y \\\n    package1 \\\n    package2 \\\n    && rm -rf /var/lib/apt/lists/*\n```\n\n### 2. 安全考虑\n\n```dockerfile\n# 创建非 root 用户\nRUN addgroup -g 1001 -S nodejs\nRUN adduser -S nextjs -u 1001\n\n# 切换用户\nUSER nextjs\n```\n\n### 3. 健康检查\n\n```dockerfile\nHEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \\\n  CMD curl -f http://localhost:8080/health || exit 1\n```\n\n## 总结\n\nDocker 容器化技术简化了应用的部署和管理，通过合理的配置和优化，可以构建高效、安全的容器化应用。',
'全面介绍 Docker 容器化技术的实际应用，包括 Dockerfile 编写、Docker Compose 编排等。',
'博客作者', 'DevOps', 'Docker,容器化,部署,DevOps', true, 167, 31, '/images/docker-practice.jpg',
'Docker 容器化部署的完整实践指南，涵盖镜像构建、服务编排、最佳实践等', NOW()),

('算法与数据结构学习笔记', 
'# 算法与数据结构学习笔记\n\n算法和数据结构是程序员的基本功，本文总结了常见的算法和数据结构。\n\n## 数据结构\n\n### 1. 数组（Array）\n\n```java\npublic class ArrayExample {\n    public static void main(String[] args) {\n        // 静态数组\n        int[] arr = {1, 2, 3, 4, 5};\n        \n        // 动态数组\n        List<Integer> list = new ArrayList<>();\n        list.add(1);\n        list.add(2);\n        \n        // 遍历\n        for (int num : arr) {\n            System.out.println(num);\n        }\n    }\n}\n```\n\n### 2. 链表（Linked List）\n\n```java\nclass ListNode {\n    int val;\n    ListNode next;\n    \n    ListNode(int val) {\n        this.val = val;\n    }\n}\n\npublic class LinkedList {\n    private ListNode head;\n    \n    // 插入节点\n    public void insert(int val) {\n        ListNode newNode = new ListNode(val);\n        newNode.next = head;\n        head = newNode;\n    }\n    \n    // 删除节点\n    public void delete(int val) {\n        if (head == null) return;\n        \n        if (head.val == val) {\n            head = head.next;\n            return;\n        }\n        \n        ListNode current = head;\n        while (current.next != null && current.next.val != val) {\n            current = current.next;\n        }\n        \n        if (current.next != null) {\n            current.next = current.next.next;\n        }\n    }\n}\n```\n\n### 3. 栈（Stack）\n\n```java\npublic class StackExample {\n    public static boolean isValidParentheses(String s) {\n        Stack<Character> stack = new Stack<>();\n        \n        for (char c : s.toCharArray()) {\n            if (c == \'(\' || c == \'[\' || c == \'{\') {\n                stack.push(c);\n            } else {\n                if (stack.isEmpty()) return false;\n                \n                char top = stack.pop();\n                if ((c == \')\' && top != \'(\') ||\n                    (c == \']\' && top != \'[\') ||\n                    (c == \'}\' && top != \'{\')) {\n                    return false;\n                }\n            }\n        }\n        \n        return stack.isEmpty();\n    }\n}\n```\n\n## 排序算法\n\n### 1. 快速排序\n\n```java\npublic class QuickSort {\n    public static void quickSort(int[] arr, int low, int high) {\n        if (low < high) {\n            int pi = partition(arr, low, high);\n            \n            quickSort(arr, low, pi - 1);\n            quickSort(arr, pi + 1, high);\n        }\n    }\n    \n    private static int partition(int[] arr, int low, int high) {\n        int pivot = arr[high];\n        int i = low - 1;\n        \n        for (int j = low; j < high; j++) {\n            if (arr[j] < pivot) {\n                i++;\n                swap(arr, i, j);\n            }\n        }\n        \n        swap(arr, i + 1, high);\n        return i + 1;\n    }\n    \n    private static void swap(int[] arr, int i, int j) {\n        int temp = arr[i];\n        arr[i] = arr[j];\n        arr[j] = temp;\n    }\n}\n```\n\n### 2. 归并排序\n\n```java\npublic class MergeSort {\n    public static void mergeSort(int[] arr, int left, int right) {\n        if (left < right) {\n            int mid = left + (right - left) / 2;\n            \n            mergeSort(arr, left, mid);\n            mergeSort(arr, mid + 1, right);\n            \n            merge(arr, left, mid, right);\n        }\n    }\n    \n    private static void merge(int[] arr, int left, int mid, int right) {\n        int[] temp = new int[right - left + 1];\n        int i = left, j = mid + 1, k = 0;\n        \n        while (i <= mid && j <= right) {\n            if (arr[i] <= arr[j]) {\n                temp[k++] = arr[i++];\n            } else {\n                temp[k++] = arr[j++];\n            }\n        }\n        \n        while (i <= mid) temp[k++] = arr[i++];\n        while (j <= right) temp[k++] = arr[j++];\n        \n        System.arraycopy(temp, 0, arr, left, temp.length);\n    }\n}\n```\n\n## 搜索算法\n\n### 1. 二分搜索\n\n```java\npublic class BinarySearch {\n    public static int binarySearch(int[] arr, int target) {\n        int left = 0, right = arr.length - 1;\n        \n        while (left <= right) {\n            int mid = left + (right - left) / 2;\n            \n            if (arr[mid] == target) {\n                return mid;\n            } else if (arr[mid] < target) {\n                left = mid + 1;\n            } else {\n                right = mid - 1;\n            }\n        }\n        \n        return -1;\n    }\n}\n```\n\n### 2. 深度优先搜索（DFS）\n\n```java\npublic class DFS {\n    public static void dfs(int[][] graph, int node, boolean[] visited) {\n        visited[node] = true;\n        System.out.print(node + " ");\n        \n        for (int neighbor : graph[node]) {\n            if (!visited[neighbor]) {\n                dfs(graph, neighbor, visited);\n            }\n        }\n    }\n}\n```\n\n## 动态规划\n\n### 斐波那契数列\n\n```java\npublic class DynamicProgramming {\n    // 递归（效率低）\n    public static int fibRecursive(int n) {\n        if (n <= 1) return n;\n        return fibRecursive(n - 1) + fibRecursive(n - 2);\n    }\n    \n    // 动态规划\n    public static int fibDP(int n) {\n        if (n <= 1) return n;\n        \n        int[] dp = new int[n + 1];\n        dp[0] = 0;\n        dp[1] = 1;\n        \n        for (int i = 2; i <= n; i++) {\n            dp[i] = dp[i - 1] + dp[i - 2];\n        }\n        \n        return dp[n];\n    }\n    \n    // 空间优化\n    public static int fibOptimized(int n) {\n        if (n <= 1) return n;\n        \n        int prev2 = 0, prev1 = 1;\n        \n        for (int i = 2; i <= n; i++) {\n            int current = prev1 + prev2;\n            prev2 = prev1;\n            prev1 = current;\n        }\n        \n        return prev1;\n    }\n}\n```\n\n## 总结\n\n算法和数据结构的学习需要理论与实践相结合，多做练习题，逐步提高编程能力和问题解决能力。',
'系统总结常见的算法和数据结构，包括排序、搜索、动态规划等核心内容。',
'博客作者', '算法数据结构', '算法,数据结构,编程,Java', true, 298, 47, '/images/algorithm-notes.jpg',
'算法与数据结构学习笔记，涵盖常见算法实现和数据结构应用', NOW());

-- 更新分类的文章数量
UPDATE categories SET blog_count = (
    SELECT COUNT(*) FROM blogs WHERE category = categories.name AND is_published = true
);

-- 更新标签的使用次数（这里简化处理，实际应用中会通过应用程序处理）
UPDATE tags SET usage_count = (
    SELECT COUNT(*) FROM blogs 
    WHERE is_published = true 
    AND FIND_IN_SET(tags.name, blogs.tags) > 0
);