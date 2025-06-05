<template>
  <div class="home">
    <!-- 头部导航 -->
    <header class="header">
      <div class="container">
        <div class="header-content">
          <h1 class="logo">个人博客</h1>
          <nav class="nav">
            <router-link to="/" class="nav-link">首页</router-link>
            <div class="auth-buttons" v-if="!isLoggedIn">
              <el-button type="primary" plain @click="goToLogin">登录</el-button>
              <el-button type="primary" @click="goToRegister">注册</el-button>
            </div>
            <div class="user-nav" v-else>
              <span class="welcome-text">欢迎，{{ username }}</span>
              <el-button type="primary" plain @click="goToUserCenter">个人中心</el-button>
              <el-button type="danger" plain @click="handleLogout">注销</el-button>
            </div>
          </nav>
        </div>
      </div>
    </header>

    <!-- 主要内容 -->
    <main class="main">
      <div class="container">
        <!-- 搜索栏 -->
        <div class="search-section">
          <el-input
            v-model="searchKeyword"
            placeholder="搜索博客文章..."
            class="search-input"
            @keyup.enter="searchBlogs"
          >
            <template #append>
              <el-button @click="searchBlogs" :icon="Search">搜索</el-button>
            </template>
          </el-input>
        </div>

        <!-- 博客列表 -->
        <div class="blog-section">
          <h2 class="section-title">最新文章</h2>
          
          <!-- 加载状态 -->
          <div v-if="loading" class="loading">
            <el-skeleton :rows="3" animated />
          </div>

          <!-- 空状态 -->
          <div v-else-if="blogs.length === 0" class="empty">
            <el-empty description="暂无文章" />
          </div>

          <!-- 博客网格 -->
          <div v-else class="blog-grid">
            <div
              v-for="blog in blogs"
              :key="blog.id"
              class="blog-card"
              @click="goToBlogDetail(blog.id)"
            >
              <div class="blog-card-content">
                <h3 class="blog-title">{{ blog.title }}</h3>
                <p class="blog-summary">{{ blog.summary || blog.content.substring(0, 150) + '...' }}</p>
                <div class="blog-meta">
                  <span class="blog-author">
                    <el-icon><User /></el-icon>
                    {{ blog.authorName || blog.author }}
                  </span>
                  <span class="blog-date">
                    <el-icon><Calendar /></el-icon>
                    {{ formatDate(blog.createdAt) }}
                  </span>
                  <span class="blog-views">
                    <el-icon><View /></el-icon>
                    {{ blog.viewCount || blog.views || 0 }}
                  </span>
                </div>
              </div>
            </div>
          </div>

          <!-- 分页 -->
          <div v-if="total > pageSize" class="pagination">
            <el-pagination
              v-model:current-page="currentPage"
              v-model:page-size="pageSize"
              :total="total"
              :page-sizes="[10, 20, 50]"
              layout="total, sizes, prev, pager, next, jumper"
              @size-change="handleSizeChange"
              @current-change="handleCurrentChange"
            />
          </div>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { Search, User, Calendar, View } from '@element-plus/icons-vue'
import axios from 'axios'

const router = useRouter()

// 响应式数据
const blogs = ref([])
const loading = ref(false)
const searchKeyword = ref('')
const currentPage = ref(1)
const pageSize = ref(10)
const total = ref(0)
const isLoggedIn = ref(false)
const username = ref('')

// 获取博客列表
const fetchBlogs = async () => {
  loading.value = true
  try {
    const response = await axios.get('/api/blogs', {
      params: {
        page: currentPage.value - 1,
        size: pageSize.value,
        keyword: searchKeyword.value
      }
    })
    
    // 后端直接返回Page<Blog>对象
    if (response.data && response.data.content) {
      blogs.value = response.data.content
      total.value = response.data.totalElements
    } else {
      // 如果API不可用，使用模拟数据
      blogs.value = getMockBlogs()
      total.value = blogs.value.length
    }
  } catch (error) {
    console.error('获取博客列表失败:', error)
    // 使用模拟数据
    blogs.value = getMockBlogs()
    total.value = blogs.value.length
  } finally {
    loading.value = false
  }
}

// 模拟数据
const getMockBlogs = () => {
  return [
    {
      id: 1,
      title: 'Vue 3 Composition API 深入解析',
      content: 'Vue 3 引入了 Composition API，这是一个全新的 API 设计，让我们能够更好地组织和复用代码逻辑...',
      summary: 'Vue 3 引入了 Composition API，这是一个全新的 API 设计，让我们能够更好地组织和复用代码逻辑',
      authorName: 'Admin',
      createdAt: '2024-01-15T10:00:00',
      viewCount: 1250,
      likeCount: 25,
      isPublished: true,
      category: '前端开发',
      tags: 'Vue3,JavaScript'
    },
    {
      id: 2,
      title: 'Spring Boot 微服务架构实践',
      content: '在现代软件开发中，微服务架构已经成为了主流的架构模式。Spring Boot 为我们提供了强大的工具...',
      summary: '在现代软件开发中，微服务架构已经成为了主流的架构模式。Spring Boot 为我们提供了强大的工具',
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
      content: '数据库性能优化是后端开发中的重要技能。本文将介绍一些实用的 MySQL 性能优化技巧...',
      summary: '数据库性能优化是后端开发中的重要技能。本文将介绍一些实用的 MySQL 性能优化技巧',
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

// 搜索博客
const searchBlogs = () => {
  currentPage.value = 1
  fetchBlogs()
}

// 跳转到博客详情
const goToBlogDetail = (id) => {
  router.push(`/blog/${id}`)
}

// 导航到登录页面
const goToLogin = () => {
  router.push('/login')
}

// 导航到注册页面
const goToRegister = () => {
  router.push('/register')
}

// 检查用户登录状态
const checkLoginStatus = () => {
  const userToken = localStorage.getItem('userToken')
  const adminToken = localStorage.getItem('adminToken')
  const storedUsername = localStorage.getItem('username')
  
  if (userToken || adminToken) {
    isLoggedIn.value = true
    username.value = storedUsername || '用户'
  } else {
    isLoggedIn.value = false
    username.value = ''
  }
}

// 跳转到个人中心
const goToUserCenter = () => {
  const userRole = localStorage.getItem('userRole')
  if (userRole === 'admin') {
    router.push('/admin')
  } else {
    router.push('/dashboard')
  }
}

// 处理注销
const handleLogout = () => {
  localStorage.removeItem('userToken')
  localStorage.removeItem('adminToken')
  localStorage.removeItem('userRole')
  localStorage.removeItem('username')
  isLoggedIn.value = false
  username.value = ''
  // 可以选择刷新页面或显示提示
  location.reload()
}

// 格式化日期
const formatDate = (date) => {
  if (!date) return ''
  const d = new Date(date)
  return d.toLocaleDateString('zh-CN')
}

// 分页处理
const handleSizeChange = (newSize) => {
  pageSize.value = newSize
  currentPage.value = 1
  fetchBlogs()
}

const handleCurrentChange = (newPage) => {
  currentPage.value = newPage
  fetchBlogs()
}

// 组件挂载时获取数据
onMounted(() => {
  checkLoginStatus()
  fetchBlogs()
})
</script>

<style scoped>
.home {
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
}

.nav {
  display: flex;
  align-items: center;
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

.auth-buttons {
  display: flex;
  gap: 0.5rem;
  margin-left: 1rem;
}

.user-nav {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.welcome-text {
  color: white;
  font-weight: 500;
  margin-right: 0.5rem;
}

.auth-buttons .el-button {
  border-color: rgba(255, 255, 255, 0.5);
  color: white;
}

.auth-buttons .el-button:hover {
  border-color: white;
  background-color: rgba(255, 255, 255, 0.1);
}

.auth-buttons .el-button--primary:not(.is-plain) {
  background-color: rgba(255, 255, 255, 0.2);
  border-color: rgba(255, 255, 255, 0.5);
}

.auth-buttons .el-button--primary:not(.is-plain):hover {
  background-color: rgba(255, 255, 255, 0.3);
  border-color: white;
}

.main {
  padding: 2rem 0;
}

.search-section {
  margin-bottom: 2rem;
}

.search-input {
  max-width: 600px;
  margin: 0 auto;
  display: block;
}

.blog-section {
  margin-top: 2rem;
}

.section-title {
  font-size: 1.5rem;
  margin-bottom: 1.5rem;
  color: #333;
  text-align: center;
}

.loading {
  padding: 2rem;
}

.empty {
  text-align: center;
  padding: 3rem;
}

.blog-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
  gap: 1.5rem;
  margin-bottom: 2rem;
}

.blog-card {
  background: white;
  border-radius: 8px;
  padding: 1.5rem;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  cursor: pointer;
  transition: all 0.3s ease;
  border: 1px solid #e0e0e0;
}

.blog-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
}

.blog-title {
  font-size: 1.2rem;
  font-weight: 600;
  margin-bottom: 0.5rem;
  color: #333;
  line-height: 1.4;
}

.blog-summary {
  color: #666;
  line-height: 1.6;
  margin-bottom: 1rem;
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.blog-meta {
  display: flex;
  gap: 1rem;
  font-size: 0.875rem;
  color: #888;
  flex-wrap: wrap;
}

.blog-meta span {
  display: flex;
  align-items: center;
  gap: 0.25rem;
}

.pagination {
  display: flex;
  justify-content: center;
  margin-top: 2rem;
}

@media (max-width: 768px) {
  .header-content {
    flex-direction: column;
    gap: 1rem;
  }
  
  .nav {
    gap: 1rem;
  }
  
  .blog-grid {
    grid-template-columns: 1fr;
  }
  
  .blog-meta {
    flex-direction: column;
    gap: 0.5rem;
  }
}
</style>