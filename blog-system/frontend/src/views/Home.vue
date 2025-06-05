<template>
  <div class="home">
    <!-- 顶部导航 -->
    <header class="header">
      <div class="header-content">
        <div class="logo">
          <h1>📝 个人博客系统</h1>
        </div>
        <nav class="nav">
          <div class="nav-links">
            <a href="#home" class="nav-link">首页</a>
            <router-link to="/articles" class="nav-link">文章</router-link>
            <a @click="openSearchDialog" class="nav-link search-nav-link">搜索</a>
            <a href="#features" class="nav-link">功能</a>
            <a href="#api" class="nav-link">API</a>
          </div>
          <div class="auth-buttons">
            <template v-if="isLoggedIn">
              <span class="username">{{ username }}</span>
              <el-button v-if="userRole === 'admin'" @click="goToAdmin" size="small">管理后台</el-button>
              <el-button v-else @click="goToUserCenter" size="small">个人中心</el-button>
              <el-button @click="handleLogout" size="small">退出</el-button>
            </template>
          </div>
        </nav>
      </div>
    </header>

    <!-- 主要内容 -->
    <main class="main">
      <div class="container">
        <!-- 系统介绍 -->
        <section id="home" class="hero">
          <h1>欢迎来到个人博客系统</h1>
          <p>一个功能完整的Spring Boot博客系统，支持文章管理、用户系统、评论功能等</p>
          <div class="hero-buttons">
            <template v-if="isLoggedIn">
              <el-button type="primary" @click="loadStats" :loading="statsLoading">查看系统统计</el-button>
              <el-button @click="goToAdmin">进入管理系统</el-button>
            </template>
            <template v-else>
              <el-button type="primary" @click="goToLogin">登录</el-button>
              <el-button @click="goToRegister">注册</el-button>
            </template>
          </div>
        </section>

        <!-- 系统统计 -->
        <section v-if="showStats" class="stats-section">
          <div class="stats-grid">
            <div class="stat-card">
              <div class="stat-number">{{ systemStats.totalBlogs }}</div>
              <div class="stat-label">已发布文章</div>
            </div>
            <div class="stat-card">
              <div class="stat-number">{{ systemStats.totalComments }}</div>
              <div class="stat-label">评论总数</div>
            </div>
            <div class="stat-card">
              <div class="stat-number">{{ systemStats.totalUsers }}</div>
              <div class="stat-label">注册用户</div>
            </div>
          </div>
        </section>

        <!-- 搜索按钮 -->
        <section id="blogs" class="search-section">
          <h2>文章列表</h2>
          <div class="search-bar">
            <el-button 
              type="primary" 
              size="large" 
              @click="openSearchDialog" 
              :icon="Search"
              class="search-trigger-btn"
            >
              点击搜索文章
            </el-button>
          </div>
        </section>

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

        <!-- 功能特色 -->
        <section id="features" class="features">
          <h2>功能特色</h2>
          <div class="features-grid">
            <div class="feature-card">
              <div class="feature-icon">📚</div>
              <h3>文章管理</h3>
              <p>支持文章的创建、编辑、发布、分类和标签管理，提供丰富的内容管理功能</p>
            </div>
            <div class="feature-card">
              <div class="feature-icon">👥</div>
              <h3>用户系统</h3>
              <p>完整的用户注册、登录、权限管理系统，支持管理员和普通用户角色</p>
            </div>
            <div class="feature-card">
              <div class="feature-icon">💬</div>
              <h3>评论功能</h3>
              <p>支持文章评论、回复评论、评论审核等功能，促进用户互动</p>
            </div>
            <div class="feature-card">
              <div class="feature-icon">🔍</div>
              <h3>搜索功能</h3>
              <p>支持按标题、分类、标签搜索文章，快速找到感兴趣的内容</p>
            </div>
            <div class="feature-card">
              <div class="feature-icon">📊</div>
              <h3>统计分析</h3>
              <p>提供文章浏览量、点赞数、评论数等统计功能，了解内容表现</p>
            </div>
            <div class="feature-card">
              <div class="feature-icon">🎨</div>
              <h3>响应式设计</h3>
              <p>现代化的响应式界面设计，支持PC和移动设备访问</p>
            </div>
          </div>
        </section>

        <!-- API文档 -->
        <section id="api" class="api-section">
          <h2>API 接口文档</h2>
          <p>以下是系统提供的主要API接口：</p>
          
          <div class="api-group">
            <h3>博客相关接口</h3>
            <div class="api-endpoint">
              <span class="method get">GET</span>
              <strong>/api/blogs</strong> - 获取所有已发布的博客（分页）
            </div>
            <div class="api-endpoint">
              <span class="method get">GET</span>
              <strong>/api/blogs/{id}</strong> - 获取指定博客详情
            </div>
            <div class="api-endpoint">
              <span class="method post">POST</span>
              <strong>/api/blogs</strong> - 创建新博客
            </div>
            <div class="api-endpoint">
              <span class="method put">PUT</span>
              <strong>/api/blogs/{id}</strong> - 更新博客
            </div>
            <div class="api-endpoint">
              <span class="method delete">DELETE</span>
              <strong>/api/blogs/{id}</strong> - 删除博客
            </div>
          </div>

          <div class="api-group">
            <h3>用户相关接口</h3>
            <div class="api-endpoint">
              <span class="method post">POST</span>
              <strong>/api/users/register</strong> - 用户注册
            </div>
            <div class="api-endpoint">
              <span class="method post">POST</span>
              <strong>/api/users/login</strong> - 用户登录
            </div>
            <div class="api-endpoint">
              <span class="method get">GET</span>
              <strong>/api/users/{id}</strong> - 获取用户信息
            </div>
          </div>

          <div class="api-group">
            <h3>评论相关接口</h3>
            <div class="api-endpoint">
              <span class="method post">POST</span>
              <strong>/api/comments</strong> - 创建评论
            </div>
            <div class="api-endpoint">
              <span class="method get">GET</span>
              <strong>/api/comments/blog/{blogId}</strong> - 获取博客的所有评论
            </div>
            <div class="api-endpoint">
              <span class="method put">PUT</span>
              <strong>/api/comments/{id}/approve</strong> - 审核通过评论
            </div>
          </div>
        </section>
      </div>
    </main>

    <!-- 页脚 -->
    <footer class="footer">
      <div class="container">
        <p>&copy; 2025 个人博客系统. 基于 Spring Boot 开发.</p>
      </div>
    </footer>

    <!-- 搜索弹窗 -->
    <el-dialog
      v-model="searchDialogVisible"
      title="搜索文章"
      width="600px"
      :before-close="handleSearchDialogClose"
      class="search-dialog"
    >
      <div class="search-dialog-content">
        <!-- 搜索表单 -->
        <div class="search-form">
          <el-input
            v-model="searchKeyword"
            placeholder="请输入关键词搜索文章..."
            size="large"
            class="search-input"
            @keyup.enter="performSearch"
            clearable
            autofocus
          >
            <template #prefix>
              <el-icon class="search-icon"><Search /></el-icon>
            </template>
          </el-input>
        </div>

        <!-- 分类和标签筛选 -->
        <div class="filter-section">
          <div class="filter-group">
            <label class="filter-label">
              <el-icon><Folder /></el-icon>
              分类筛选
            </label>
            <el-select
              v-model="selectedCategory"
              placeholder="选择分类"
              clearable
              class="category-select"
            >
              <el-option
                v-for="category in categories"
                :key="category.id || category"
                :label="category.name || category"
                :value="category.name || category"
              >
                <div class="option-content">
                  <el-icon><Folder /></el-icon>
                  <span>{{ category.name || category }}</span>
                </div>
              </el-option>
            </el-select>
          </div>

          <div class="filter-group">
            <label class="filter-label">
              <el-icon><Star /></el-icon>
              标签筛选
            </label>
            <el-select
              v-model="selectedTag"
              placeholder="选择标签"
              clearable
              class="tag-select"
            >
              <el-option
                v-for="tag in tags"
                :key="tag.id || tag"
                :label="tag.name || tag"
                :value="tag.name || tag"
              >
                <div class="option-content">
                  <el-icon><Star /></el-icon>
                  <span>{{ tag.name || tag }}</span>
                </div>
              </el-option>
            </el-select>
          </div>

          <div class="filter-group">
            <label class="filter-label">
              <el-icon><TrendCharts /></el-icon>
              排序方式
            </label>
            <el-select
              v-model="sortBy"
              placeholder="选择排序"
              class="sort-select"
            >
              <el-option label="最新发布" value="createTime">
                <div class="option-content">
                  <el-icon><Calendar /></el-icon>
                  <span>最新发布</span>
                </div>
              </el-option>
              <el-option label="最受欢迎" value="popularity">
                <div class="option-content">
                  <el-icon><Star /></el-icon>
                  <span>最受欢迎</span>
                </div>
              </el-option>
              <el-option label="浏览最多" value="views">
                <div class="option-content">
                  <el-icon><View /></el-icon>
                  <span>浏览最多</span>
                </div>
              </el-option>
            </el-select>
          </div>
        </div>

        <!-- 搜索建议 -->
        <div v-if="!searchKeyword && !selectedCategory" class="search-suggestions">
          <h4>热门搜索</h4>
          <div class="suggestion-tags">
            <el-tag
              v-for="suggestion in searchSuggestions"
              :key="suggestion"
              @click="selectSuggestion(suggestion)"
              class="suggestion-tag"
              effect="plain"
            >
              {{ suggestion }}
            </el-tag>
          </div>
        </div>
      </div>

      <template #footer>
        <div class="dialog-footer">
          <el-button @click="clearSearch" :icon="Delete">清除</el-button>
          <el-button type="primary" @click="performSearch" :icon="Search">
            搜索
          </el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { Search, User, Calendar, View, Folder, TrendCharts, Star, Delete } from '@element-plus/icons-vue'
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
const userRole = ref('')
const showStats = ref(false)
const statsLoading = ref(false)
const systemStats = ref({
  totalBlogs: 0,
  totalComments: 0,
  totalUsers: 0
})

// 搜索弹窗相关数据
const searchDialogVisible = ref(false)
const selectedCategory = ref('')
const selectedTag = ref('')
const sortBy = ref('latest')
const categories = ref([])
const tags = ref([])
const searchSuggestions = ref(['Vue.js', 'Spring Boot', 'JavaScript', 'Java', '前端开发', '后端开发', '数据库', 'API设计'])

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

// 打开搜索弹窗
const openSearchDialog = () => {
  searchDialogVisible.value = true
  fetchCategories()
  fetchTags()
}

// 关闭搜索弹窗
const handleSearchDialogClose = () => {
  searchDialogVisible.value = false
}

// 执行搜索
const performSearch = () => {
  const query = {}
  
  if (searchKeyword.value.trim()) {
    query.keyword = searchKeyword.value.trim()
  }
  
  if (selectedCategory.value) {
     query.category = selectedCategory.value
   }
   
   if (selectedTag.value) {
     query.tag = selectedTag.value
   }
  
  if (sortBy.value) {
    query.sortBy = sortBy.value
  }
  
  // 关闭弹窗并跳转到文章页面
  searchDialogVisible.value = false
  router.push({ path: '/articles', query })
}

// 清除搜索条件
const clearSearch = () => {
  searchKeyword.value = ''
  selectedCategory.value = ''
  selectedTag.value = ''
  sortBy.value = 'latest'
}

// 选择搜索建议
const selectSuggestion = (suggestion) => {
  searchKeyword.value = suggestion
}

// 获取分类列表
const fetchCategories = async () => {
  try {
    const response = await axios.get('/api/categories')
    if (response.data && Array.isArray(response.data)) {
      categories.value = response.data
    } else {
      // 使用模拟分类数据
      categories.value = [
        { id: 1, name: '技术分享' },
        { id: 2, name: '生活随笔' },
        { id: 3, name: '学习笔记' },
        { id: 4, name: '项目经验' }
      ]
    }
  } catch (error) {
    console.error('获取分类失败:', error)
    // 使用旧接口作为备选
    try {
      const fallbackResponse = await axios.get('/api/blogs/categories')
      if (fallbackResponse.data) {
        categories.value = fallbackResponse.data.map(cat => 
          typeof cat === 'string' ? { name: cat } : cat
        )
      }
    } catch (fallbackError) {
      console.error('获取分类失败（备选接口）:', fallbackError)
      // 使用模拟分类数据
      categories.value = [
        { id: 1, name: '技术分享' },
        { id: 2, name: '生活随笔' },
        { id: 3, name: '学习笔记' },
        { id: 4, name: '项目经验' }
      ]
    }
  }
}

// 获取标签列表
const fetchTags = async () => {
  try {
    const response = await axios.get('/api/tags/active')
    if (response.data) {
      tags.value = response.data
    }
  } catch (error) {
    console.error('获取标签失败:', error)
    // 使用模拟数据
    tags.value = [
      { id: 1, name: 'Vue.js' },
      { id: 2, name: 'JavaScript' },
      { id: 3, name: 'Java' },
      { id: 4, name: 'Spring Boot' },
      { id: 5, name: '前端开发' },
      { id: 6, name: '后端开发' }
    ]
  }
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

// 跳转到管理后台
const goToAdmin = () => {
  router.push('/admin')
}

// 加载系统统计
const loadStats = async () => {
  statsLoading.value = true
  try {
    // 获取博客统计
    try {
      const blogResponse = await axios.get('/api/blogs/stats')
      if (blogResponse.data) {
        systemStats.value.totalBlogs = blogResponse.data.totalPublishedBlogs || 0
      }
    } catch (error) {
      console.warn('获取博客统计失败:', error)
      systemStats.value.totalBlogs = blogs.value.length || 0
    }

    // 获取评论统计
    try {
      const commentResponse = await axios.get('/api/comments/stats')
      if (commentResponse.data) {
        systemStats.value.totalComments = commentResponse.data.totalApprovedComments || 0
      }
    } catch (error) {
      console.warn('获取评论统计失败:', error)
      systemStats.value.totalComments = 0
    }

    // 获取用户统计
    try {
      const userResponse = await axios.get('/api/users')
      if (userResponse.data) {
        systemStats.value.totalUsers = Array.isArray(userResponse.data) ? userResponse.data.length : 0
      }
    } catch (error) {
      console.warn('获取用户统计失败:', error)
      systemStats.value.totalUsers = 0
    }

    showStats.value = true
  } catch (error) {
    console.error('加载统计数据失败:', error)
    // 显示默认统计
    systemStats.value = {
      totalBlogs: blogs.value.length || 0,
      totalComments: 0,
      totalUsers: 0
    }
    showStats.value = true
  } finally {
    statsLoading.value = false
  }
}

// 检查用户登录状态
const checkLoginStatus = () => {
  const userToken = localStorage.getItem('userToken')
  const adminToken = localStorage.getItem('adminToken')
  const storedUsername = localStorage.getItem('username')
  const storedUserRole = localStorage.getItem('userRole')
  
  if (userToken || adminToken) {
    isLoggedIn.value = true
    username.value = storedUsername || '用户'
    userRole.value = storedUserRole || 'user'
  } else {
    isLoggedIn.value = false
    username.value = ''
    userRole.value = ''
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
  userRole.value = ''
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
  background: linear-gradient(135deg, #4f46e5 0%, #06b6d4 100%);
  color: white;
  padding: 1rem 0;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  position: sticky;
  top: 0;
  z-index: 100;
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

.logo h1 {
  margin: 0;
  font-size: 1.5rem;
}

.nav {
  display: flex;
  align-items: center;
  gap: 2rem;
}

.nav-links {
  display: flex;
  gap: 1.5rem;
}

.nav-link {
  color: white;
  text-decoration: none;
  padding: 0.5rem 1rem;
  border-radius: 5px;
  transition: background-color 0.3s;
}

.nav-link:hover {
  background-color: rgba(255, 255, 255, 0.1);
}

.auth-buttons {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.username {
  color: white;
  font-weight: 500;
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
  border-color: rgba(255, 255, 255, 0.8);
  color: white;
  background-color: rgba(255, 255, 255, 0.1);
}

.auth-buttons .el-button:hover {
  border-color: white;
  background-color: rgba(255, 255, 255, 0.2);
}

.auth-buttons .el-button--primary:not(.is-plain) {
  background-color: rgba(255, 255, 255, 0.25);
  border-color: rgba(255, 255, 255, 0.8);
}

.auth-buttons .el-button--primary:not(.is-plain):hover {
  background-color: rgba(255, 255, 255, 0.35);
  border-color: white;
}

.main {
  padding: 2rem 0;
}

/* Hero Section */
.hero {
  text-align: center;
  padding: 4rem 0;
  background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
  margin-bottom: 2rem;
  border-radius: 10px;
}

.hero h1 {
  font-size: 2.5rem;
  margin-bottom: 1rem;
  color: #333;
}

.hero p {
  font-size: 1.2rem;
  color: #666;
  margin-bottom: 2rem;
}

.hero-buttons {
  display: flex;
  gap: 1rem;
  justify-content: center;
  flex-wrap: wrap;
}

/* Stats Section */
.stats-section {
  margin: 3rem 0;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1rem;
}

.stat-card {
  background: white;
  padding: 1.5rem;
  border-radius: 10px;
  text-align: center;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  transition: transform 0.3s;
}

.stat-card:hover {
  transform: translateY(-2px);
}

.stat-number {
  font-size: 2rem;
  font-weight: bold;
  color: #4f46e5;
  margin-bottom: 0.5rem;
}

.stat-label {
  color: #666;
  font-size: 0.9rem;
}

.search-section {
  margin: 2rem 0;
}

.search-section h2 {
  margin-bottom: 1rem;
  color: #333;
}

.search-bar {
  text-align: center;
}

.search-input {
  max-width: 600px;
  margin: 0 auto;
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

/* Features Section */
.features {
  margin: 4rem 0;
}

.features h2 {
  text-align: center;
  margin-bottom: 2rem;
  color: #333;
  font-size: 2rem;
}

.features-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 2rem;
}

.feature-card {
  background: white;
  padding: 2rem;
  border-radius: 10px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  text-align: center;
  transition: transform 0.3s;
}

.feature-card:hover {
  transform: translateY(-5px);
}

.feature-icon {
  font-size: 3rem;
  margin-bottom: 1rem;
}

.feature-card h3 {
  margin-bottom: 1rem;
  color: #333;
}

.feature-card p {
  color: #666;
  line-height: 1.6;
}

/* API Section */
.api-section {
  background: white;
  padding: 2rem;
  border-radius: 10px;
  margin: 2rem 0;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.api-section h2 {
  color: #333;
  margin-bottom: 1rem;
}

.api-section p {
  color: #666;
  margin-bottom: 2rem;
}

.api-group {
  margin-bottom: 2rem;
}

.api-group h3 {
  color: #333;
  margin-bottom: 1rem;
  border-bottom: 2px solid #4f46e5;
  padding-bottom: 0.5rem;
}

.api-endpoint {
  background: #f8f9fa;
  padding: 1rem;
  border-radius: 5px;
  margin: 1rem 0;
  border-left: 4px solid #4f46e5;
  display: flex;
  align-items: center;
  gap: 1rem;
}

.method {
  display: inline-block;
  padding: 4px 8px;
  border-radius: 3px;
  color: white;
  font-weight: bold;
  font-size: 0.8rem;
  min-width: 60px;
  text-align: center;
}

.method.get {
  background-color: #28a745;
}

.method.post {
  background-color: #007bff;
}

.method.put {
  background-color: #ffc107;
  color: #333;
}

.method.delete {
  background-color: #dc3545;
}

/* Footer */
.footer {
  background: #333;
  color: white;
  text-align: center;
  padding: 2rem 0;
  margin-top: 3rem;
}

.footer p {
  margin: 0;
}

/* 搜索弹窗样式 */
.search-trigger-btn {
  background: linear-gradient(45deg, #4f46e5, #7c3aed);
  border: none;
  border-radius: 25px;
  padding: 12px 30px;
  font-size: 1.1rem;
  font-weight: 600;
  box-shadow: 0 4px 15px rgba(79, 70, 229, 0.3);
  transition: all 0.3s ease;
}

.search-trigger-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(79, 70, 229, 0.4);
}

.search-nav-link {
  cursor: pointer;
  transition: color 0.3s ease;
}

.search-nav-link:hover {
  color: #4f46e5;
}

:deep(.search-dialog) {
  border-radius: 16px;
  overflow: hidden;
}

:deep(.search-dialog .el-dialog__header) {
  background: linear-gradient(45deg, #4f46e5, #7c3aed);
  color: white;
  padding: 20px 24px;
  margin: 0;
}

:deep(.search-dialog .el-dialog__title) {
  color: white;
  font-weight: 600;
  font-size: 1.2rem;
}

:deep(.search-dialog .el-dialog__headerbtn .el-dialog__close) {
  color: white;
  font-size: 1.2rem;
}

:deep(.search-dialog .el-dialog__body) {
  padding: 30px 24px;
  background: #f8fafc;
}

.search-dialog-content {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.search-form .search-input {
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.search-form :deep(.el-input__wrapper) {
  border: 2px solid #e2e8f0;
  border-radius: 12px;
  transition: all 0.3s ease;
  padding: 0 16px;
}

.search-form :deep(.el-input__wrapper:hover) {
  border-color: #4f46e5;
}

.search-form :deep(.el-input__wrapper.is-focus) {
  border-color: #4f46e5;
  box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
}

.search-icon {
  color: #4f46e5;
  font-size: 1.1rem;
}

.filter-section {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
}

.filter-group {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.filter-label {
  display: flex;
  align-items: center;
  gap: 6px;
  color: #374151;
  font-weight: 500;
  font-size: 0.9rem;
}

.category-select,
.tag-select,
.sort-select {
  border-radius: 8px;
}

.category-select :deep(.el-input__wrapper),
.tag-select :deep(.el-input__wrapper),
.sort-select :deep(.el-input__wrapper) {
  border: 2px solid #e2e8f0;
  border-radius: 8px;
  transition: all 0.3s ease;
}

.category-select :deep(.el-input__wrapper:hover),
.tag-select :deep(.el-input__wrapper:hover),
.sort-select :deep(.el-input__wrapper:hover) {
  border-color: #4f46e5;
}

.category-select :deep(.el-input__wrapper.is-focus),
.tag-select :deep(.el-input__wrapper.is-focus),
.sort-select :deep(.el-input__wrapper.is-focus) {
  border-color: #4f46e5;
  box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
}

.option-content {
  display: flex;
  align-items: center;
  gap: 8px;
}

.search-suggestions {
  background: white;
  padding: 20px;
  border-radius: 12px;
  border: 2px solid #e2e8f0;
}

.search-suggestions h4 {
  margin: 0 0 16px 0;
  color: #374151;
  font-size: 1rem;
  font-weight: 600;
}

.suggestion-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.suggestion-tag {
  cursor: pointer;
  transition: all 0.3s ease;
  border: 1px solid #d1d5db;
  background: #f9fafb;
  color: #374151;
}

.suggestion-tag:hover {
  background: #4f46e5;
  color: white;
  border-color: #4f46e5;
  transform: translateY(-1px);
}

:deep(.search-dialog .el-dialog__footer) {
  background: #f8fafc;
  padding: 20px 24px;
  border-top: 1px solid #e2e8f0;
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
}

.dialog-footer .el-button {
  border-radius: 8px;
  padding: 10px 20px;
  font-weight: 500;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .header-content {
    flex-direction: column;
    gap: 1rem;
  }
  
  .nav {
    flex-direction: column;
    gap: 1rem;
  }
  
  .nav-links {
    flex-wrap: wrap;
    justify-content: center;
  }
  
  .hero h1 {
    font-size: 2rem;
  }
  
  .hero-buttons {
    flex-direction: column;
    align-items: center;
  }
  
  .features-grid {
    grid-template-columns: 1fr;
  }
  
  .stats-grid {
    grid-template-columns: 1fr;
  }
  
  .blog-grid {
    grid-template-columns: 1fr;
  }
  
  .blog-meta {
    flex-direction: column;
    gap: 0.5rem;
  }

  /* 搜索弹窗响应式 */
  :deep(.search-dialog) {
    width: 95% !important;
    margin: 0 auto;
  }

  .filter-section {
    grid-template-columns: 1fr;
    gap: 16px;
  }

  .suggestion-tags {
    justify-content: center;
  }

  .dialog-footer {
    flex-direction: column;
  }

  .dialog-footer .el-button {
    width: 100%;
  }
}
</style>