<template>
  <div class="blog-detail">
    <!-- 头部导航 -->
    <header class="header">
      <div class="container">
        <div class="header-content">
          <h1 class="logo" @click="goHome">个人博客</h1>
          <nav class="nav">
            <router-link to="/" class="nav-link">首页</router-link>
            <router-link to="/admin" class="nav-link">管理后台</router-link>
          </nav>
        </div>
      </div>
    </header>

    <!-- 主要内容 -->
    <main class="main">
      <div class="container">
        <!-- 返回按钮 -->
        <div class="back-section">
          <el-button @click="goBack" :icon="ArrowLeft">返回</el-button>
        </div>

        <!-- 加载状态 -->
        <div v-if="loading" class="loading">
          <el-skeleton :rows="8" animated />
        </div>

        <!-- 错误状态 -->
        <div v-else-if="error" class="error">
          <el-result
            icon="error"
            title="加载失败"
            :sub-title="error"
          >
            <template #extra>
              <el-button type="primary" @click="fetchBlog">重试</el-button>
            </template>
          </el-result>
        </div>

        <!-- 博客内容 -->
        <article v-else-if="blog" class="blog-article">
          <header class="article-header">
            <h1 class="article-title">{{ blog.title }}</h1>
            <div class="article-meta">
              <span class="meta-item">
                <el-icon><User /></el-icon>
                {{ blog.authorName || blog.author }}
              </span>
              <span class="meta-item">
                <el-icon><Calendar /></el-icon>
                {{ formatDate(blog.createdAt) }}
              </span>
              <span class="meta-item">
                <el-icon><TrendCharts /></el-icon>
                热度 {{ blog.viewCount || blog.views || 0 }}
              </span>
              <span class="meta-item">
                <el-icon><Star /></el-icon>
                {{ blog.likeCount || 0 }} 点赞
              </span>
            </div>
          </header>

          <div class="article-content" v-html="formattedContent"></div>

          <!-- 分享和操作 -->
          <footer class="article-footer">
            <div class="article-actions">
              <el-button 
                @click="likeBlog" 
                :icon="Star" 
                :loading="liking"
                type="primary"
                :disabled="hasLiked"
              >
                {{ hasLiked ? '已点赞' : '点赞' }} ({{ blog.likeCount || 0 }})
              </el-button>
              <el-button @click="shareBlog" :icon="Share">分享</el-button>
              <el-button @click="goBack">返回列表</el-button>
            </div>
          </footer>
        </article>

        <!-- 相关文章 -->
        <section v-if="relatedBlogs.length > 0" class="related-section">
          <h2 class="section-title">相关文章</h2>
          <div class="related-grid">
            <div
              v-for="relatedBlog in relatedBlogs"
              :key="relatedBlog.id"
              class="related-card"
              @click="goToBlogDetail(relatedBlog.id)"
            >
              <h3 class="related-title">{{ relatedBlog.title }}</h3>
              <p class="related-summary">{{ relatedBlog.summary || relatedBlog.content.substring(0, 100) + '...' }}</p>
              <div class="related-meta">
                <span>{{ formatDate(relatedBlog.createdAt) }}</span>
              </div>
            </div>
          </div>
        </section>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { ArrowLeft, User, Calendar, View, Share, Star } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import axios from 'axios'

const router = useRouter()
const route = useRoute()

// 响应式数据
const blog = ref(null)
const relatedBlogs = ref([])
const loading = ref(false)
const error = ref('')
const liking = ref(false)
const hasLiked = ref(false)

// 计算属性
const formattedContent = computed(() => {
  if (!blog.value?.content) return ''
  // 简单的内容格式化，将换行转换为段落
  return blog.value.content
    .split('\n')
    .filter(line => line.trim())
    .map(line => `<p>${line}</p>`)
    .join('')
})

// 获取博客详情
const fetchBlog = async () => {
  const blogId = route.params.id
  if (!blogId) {
    error.value = '博客ID无效'
    return
  }

  loading.value = true
  error.value = ''
  
  try {
    const response = await axios.get(`/api/blogs/${blogId}`)
    
    // 后端直接返回Blog对象
    if (response.data && response.data.id) {
      blog.value = response.data
      // 检查点赞状态
      checkLikeStatus()
      // 获取相关文章
      fetchRelatedBlogs()
    } else {
      // 如果API不可用，使用模拟数据
      blog.value = getMockBlog(blogId)
      // 检查点赞状态
      checkLikeStatus()
      relatedBlogs.value = getMockRelatedBlogs()
    }
  } catch (err) {
    console.error('获取博客详情失败:', err)
    // 使用模拟数据
    blog.value = getMockBlog(blogId)
    // 检查点赞状态
    checkLikeStatus()
    relatedBlogs.value = getMockRelatedBlogs()
  } finally {
    loading.value = false
  }
}

// 获取相关文章
const fetchRelatedBlogs = async () => {
  try {
    // 使用最新博客接口获取相关文章
    const response = await axios.get('/api/blogs/latest', {
      params: { limit: 3 }
    })
    
    // 后端直接返回List<Blog>
    if (response.data && Array.isArray(response.data)) {
      relatedBlogs.value = response.data.filter(blog => blog.id != route.params.id)
    }
  } catch (err) {
    console.error('获取相关文章失败:', err)
    relatedBlogs.value = getMockRelatedBlogs()
  }
}

// 模拟数据
const getMockBlog = (id) => {
  const mockBlogs = {
    '1': {
      id: 1,
      title: 'Vue 3 Composition API 深入解析',
      content: `Vue 3 引入了 Composition API，这是一个全新的 API 设计，让我们能够更好地组织和复用代码逻辑。\n\nComposition API 的核心思想是将组件的逻辑按照功能进行组织，而不是按照选项类型（data、methods、computed等）进行组织。\n\n## 主要特性\n\n1. **更好的逻辑复用**：通过组合函数，我们可以轻松地在不同组件间共享逻辑。\n\n2. **更好的类型推导**：TypeScript 支持更加完善。\n\n3. **更灵活的代码组织**：相关的逻辑可以组织在一起。\n\n## 基本用法\n\n使用 setup() 函数作为组件的入口点，在这里定义响应式数据、计算属性、方法等。\n\n## 响应式 API\n\n- ref()：创建响应式引用\n- reactive()：创建响应式对象\n- computed()：创建计算属性\n- watch()：创建侦听器\n\nComposition API 为 Vue 3 带来了更强大的功能和更好的开发体验。`,
      summary: 'Vue 3 引入了 Composition API，这是一个全新的 API 设计，让我们能够更好地组织和复用代码逻辑',
      authorName: 'Admin',
      createdAt: '2024-01-15T10:00:00',
      viewCount: 1250,
      likeCount: 25,
      isPublished: true,
      category: '前端开发',
      tags: 'Vue3,JavaScript'
    },
    '2': {
      id: 2,
      title: 'Spring Boot 微服务架构实践',
      content: `在现代软件开发中，微服务架构已经成为了主流的架构模式。Spring Boot 为我们提供了强大的工具来构建微服务应用。\n\n## 微服务架构的优势\n\n1. **独立部署**：每个服务可以独立部署和扩展\n2. **技术多样性**：不同服务可以使用不同的技术栈\n3. **故障隔离**：单个服务的故障不会影响整个系统\n4. **团队独立性**：不同团队可以独立开发不同的服务\n\n## Spring Boot 在微服务中的应用\n\nSpring Boot 提供了许多特性来简化微服务的开发：\n\n- **自动配置**：减少样板代码\n- **内嵌服务器**：简化部署\n- **健康检查**：监控服务状态\n- **配置管理**：外部化配置\n\n## 最佳实践\n\n1. 服务拆分要合理，避免过度拆分\n2. 使用 API 网关统一入口\n3. 实现服务发现和负载均衡\n4. 做好监控和日志管理\n5. 考虑数据一致性问题`,
      summary: '在现代软件开发中，微服务架构已经成为了主流的架构模式。Spring Boot 为我们提供了强大的工具',
      authorName: 'Admin',
      createdAt: '2024-01-10T14:30:00',
      viewCount: 980,
      likeCount: 18,
      isPublished: true,
      category: '后端开发',
      tags: 'Spring Boot,微服务'
    },
    '3': {
      id: 3,
      title: 'MySQL 性能优化技巧',
      content: `数据库性能优化是后端开发中的重要技能。本文将介绍一些实用的 MySQL 性能优化技巧。\n\n## 索引优化\n\n索引是提高查询性能的最重要手段：\n\n1. **选择合适的索引类型**\n   - B-Tree 索引：最常用的索引类型\n   - Hash 索引：适用于等值查询\n   - 全文索引：适用于文本搜索\n\n2. **索引设计原则**\n   - 在经常查询的列上建立索引\n   - 避免在频繁更新的列上建立索引\n   - 复合索引的列顺序很重要\n\n## 查询优化\n\n1. **使用 EXPLAIN 分析查询计划**\n2. **避免 SELECT ***\n3. **合理使用 WHERE 条件**\n4. **优化 JOIN 操作**\n\n## 配置优化\n\n1. **调整缓冲池大小**\n2. **优化连接数设置**\n3. **配置查询缓存**\n\n## 架构优化\n\n1. **读写分离**\n2. **分库分表**\n3. **使用缓存**\n\n通过这些优化技巧，可以显著提升 MySQL 的性能。`,
      summary: '数据库性能优化是后端开发中的重要技能。本文将介绍一些实用的 MySQL 性能优化技巧',
      authorName: 'Admin',
      createdAt: '2024-01-05T09:15:00',
      viewCount: 756,
      likeCount: 12,
      isPublished: true,
      category: '数据库',
      tags: 'MySQL,性能优化'
    }
  }
  
  return mockBlogs[id] || null
}

const getMockRelatedBlogs = () => {
    return [
      {
        id: 2,
        title: 'Spring Boot 微服务架构实践',
        content: '在现代软件开发中，微服务架构已经成为了主流的架构模式...',
        summary: '在现代软件开发中，微服务架构已经成为了主流的架构模式',
        authorName: 'Admin',
        createdAt: '2024-01-10T14:30:00',
        viewCount: 980,
        likeCount: 18,
        isPublished: true,
        category: '后端开发',
        tags: 'Spring Boot,微服务'
      },
      {
        id: 3,
        title: 'MySQL 性能优化技巧',
        content: '数据库性能优化是后端开发中的重要技能...',
        summary: '数据库性能优化是后端开发中的重要技能',
        authorName: 'Admin',
        createdAt: '2024-01-05T09:15:00',
        viewCount: 756,
        likeCount: 12,
        isPublished: true,
        category: '数据库',
        tags: 'MySQL,性能优化'
      }
    ]
  }

// 导航方法
const goHome = () => {
  router.push('/')
}

const goBack = () => {
  router.go(-1)
}

const goToBlogDetail = (id) => {
  router.push(`/blog/${id}`)
}

// 点赞博客
const likeBlog = async () => {
  if (!blog.value || liking.value || hasLiked.value) return
  
  liking.value = true
  try {
    const response = await axios.post(`/api/blogs/${blog.value.id}/like`)
    if (response.data) {
      blog.value.likeCount = response.data.likeCount
      hasLiked.value = true
      // 将点赞状态保存到本地存储
      const likedBlogs = JSON.parse(localStorage.getItem('likedBlogs') || '[]')
      if (!likedBlogs.includes(blog.value.id)) {
        likedBlogs.push(blog.value.id)
        localStorage.setItem('likedBlogs', JSON.stringify(likedBlogs))
      }
      ElMessage.success('点赞成功！')
    }
  } catch (error) {
    console.error('点赞失败:', error)
    ElMessage.error('点赞失败，请稍后重试')
  } finally {
    liking.value = false
  }
}

// 检查是否已点赞
const checkLikeStatus = () => {
  if (!blog.value) return
  const likedBlogs = JSON.parse(localStorage.getItem('likedBlogs') || '[]')
  hasLiked.value = likedBlogs.includes(blog.value.id)
}

// 分享博客
const shareBlog = () => {
  if (navigator.share && blog.value) {
    navigator.share({
      title: blog.value.title,
      text: blog.value.content.substring(0, 100) + '...',
      url: window.location.href
    })
  } else {
    // 复制链接到剪贴板
    navigator.clipboard.writeText(window.location.href).then(() => {
      ElMessage.success('链接已复制到剪贴板')
    }).catch(() => {
      ElMessage.error('复制失败')
    })
  }
}

// 格式化日期
const formatDate = (date) => {
  if (!date) return ''
  const d = new Date(date)
  return d.toLocaleDateString('zh-CN', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  })
}

// 组件挂载时获取数据
onMounted(() => {
  fetchBlog()
})
</script>

<style scoped>
.blog-detail {
  min-height: 100vh;
  background-color: #f5f5f5;
}

.header {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  padding: 1rem 0;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 1rem;
}

.header-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.logo {
  font-size: 1.8rem;
  font-weight: bold;
  margin: 0;
  cursor: pointer;
  transition: opacity 0.3s;
}

.logo:hover {
  opacity: 0.8;
}

.nav {
  display: flex;
  gap: 2rem;
}

.nav-link {
  color: white;
  text-decoration: none;
  font-weight: 500;
  transition: opacity 0.3s;
}

.nav-link:hover {
  opacity: 0.8;
}

.main {
  padding: 2rem 0;
}

.back-section {
  margin-bottom: 1rem;
}

.loading {
  background: white;
  border-radius: 8px;
  padding: 2rem;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.error {
  background: white;
  border-radius: 8px;
  padding: 2rem;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  text-align: center;
}

.blog-article {
  background: white;
  border-radius: 8px;
  padding: 2rem;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  margin-bottom: 2rem;
}

.article-header {
  border-bottom: 1px solid #e0e0e0;
  padding-bottom: 1.5rem;
  margin-bottom: 2rem;
}

.article-title {
  font-size: 2rem;
  font-weight: 700;
  color: #333;
  margin-bottom: 1rem;
  line-height: 1.3;
}

.article-meta {
  display: flex;
  gap: 1.5rem;
  color: #666;
  font-size: 0.9rem;
  flex-wrap: wrap;
}

.meta-item {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.article-content {
  line-height: 1.8;
  color: #333;
  font-size: 1rem;
}

.article-content :deep(p) {
  margin-bottom: 1rem;
}

.article-content :deep(h2) {
  font-size: 1.5rem;
  font-weight: 600;
  margin: 2rem 0 1rem 0;
  color: #333;
}

.article-content :deep(h3) {
  font-size: 1.3rem;
  font-weight: 600;
  margin: 1.5rem 0 0.5rem 0;
  color: #333;
}

.article-content :deep(ul), 
.article-content :deep(ol) {
  margin: 1rem 0;
  padding-left: 2rem;
}

.article-content :deep(li) {
  margin-bottom: 0.5rem;
}

.article-footer {
  border-top: 1px solid #e0e0e0;
  padding-top: 1.5rem;
  margin-top: 2rem;
}

.article-actions {
  display: flex;
  gap: 1rem;
  justify-content: center;
}

.related-section {
  background: white;
  border-radius: 8px;
  padding: 2rem;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.section-title {
  font-size: 1.5rem;
  font-weight: 600;
  margin-bottom: 1.5rem;
  color: #333;
}

.related-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 1rem;
}

.related-card {
  border: 1px solid #e0e0e0;
  border-radius: 6px;
  padding: 1rem;
  cursor: pointer;
  transition: all 0.3s ease;
}

.related-card:hover {
  border-color: #409eff;
  box-shadow: 0 2px 8px rgba(64, 158, 255, 0.2);
}

.related-title {
  font-size: 1rem;
  font-weight: 600;
  margin-bottom: 0.5rem;
  color: #333;
}

.related-summary {
  color: #666;
  font-size: 0.9rem;
  line-height: 1.5;
  margin-bottom: 0.5rem;
}

.related-meta {
  color: #888;
  font-size: 0.8rem;
}

@media (max-width: 768px) {
  .header-content {
    flex-direction: column;
    gap: 1rem;
  }
  
  .nav {
    gap: 1rem;
  }
  
  .article-title {
    font-size: 1.5rem;
  }
  
  .article-meta {
    flex-direction: column;
    gap: 0.5rem;
  }
  
  .article-actions {
    flex-direction: column;
    align-items: center;
  }
  
  .related-grid {
    grid-template-columns: 1fr;
  }
}
</style>