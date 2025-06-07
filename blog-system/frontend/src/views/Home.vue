<template>
  <div class="home">
    <!-- 顶部导航 -->
    <header class="header">
      <div class="header-content">
        <div class="logo">
          <h1>📝 个人博客系统</h1>
        </div>
        <div class="search-container">
          <div class="search-wrapper">
            <el-input
              v-model="searchKeyword"
              placeholder="搜索文章..."
              class="search-input"
              @keyup.enter="performSearch"
              clearable
            />
            <el-button 
              type="primary" 
              class="search-button"
              @click="performSearch"
              :icon="Search"
            >
              搜索
            </el-button>
          </div>
        </div>
        <div class="user-section">
          <template v-if="isLoggedIn">
            <el-dropdown trigger="hover" placement="bottom-end">
              <div class="user-info">
                <el-avatar 
                  :size="32" 
                  :src="userAvatar" 
                  :icon="UserFilled"
                  class="user-avatar"
                />
                <span class="username">{{ username }}</span>
              </div>
              <template #dropdown>
                <el-dropdown-menu>
                  <el-dropdown-item v-if="userRole === 'admin'" @click="goToAdmin">
                    <el-icon><Setting /></el-icon>
                    管理后台
                  </el-dropdown-item>
                  <el-dropdown-item v-else @click="goToUserCenter">
                    <el-icon><User /></el-icon>
                    个人中心
                  </el-dropdown-item>
                  <el-dropdown-item divided @click="handleLogout">
                    <el-icon><SwitchButton /></el-icon>
                    退出
                  </el-dropdown-item>
                </el-dropdown-menu>
              </template>
            </el-dropdown>
          </template>
          <template v-else>
            <div class="auth-buttons">
              <el-button @click="goToLogin" size="small">登录</el-button>
              <el-button type="primary" @click="goToRegister" size="small">注册</el-button>
            </div>
          </template>
        </div>
        <nav class="nav" style="display: none;">
          <div class="nav-right">
            <div class="auth-buttons">
            <template v-if="isLoggedIn">
              <el-dropdown trigger="hover" placement="bottom-end">
                <div class="user-info">
                  <el-avatar 
                    :size="32" 
                    :src="userAvatar" 
                    :icon="UserFilled"
                    class="user-avatar"
                  />
                  <span class="username">{{ username }}</span>
                </div>
                <template #dropdown>
                  <el-dropdown-menu>
                    <el-dropdown-item v-if="userRole === 'admin'" @click="goToAdmin">
                      <el-icon><Setting /></el-icon>
                      管理后台
                    </el-dropdown-item>
                    <el-dropdown-item v-else @click="goToUserCenter">
                      <el-icon><User /></el-icon>
                      个人中心
                    </el-dropdown-item>
                    <el-dropdown-item divided @click="handleLogout">
                      <el-icon><SwitchButton /></el-icon>
                      退出
                    </el-dropdown-item>
                  </el-dropdown-menu>
                </template>
              </el-dropdown>
            </template>
            </div>
          </div>
        </nav>
      </div>
    </header>

    <!-- 主要内容 -->
    <main class="main">
      <div class="layout-container">
        <!-- 左侧导航栏 -->
        <aside class="sidebar">
          <div class="sidebar-content">
            <div class="sidebar-section">
              <h3 class="sidebar-title">导航菜单</h3>
              <ul class="sidebar-menu">
                <li class="menu-item active">
                  <el-icon><House /></el-icon>
                  <span>首页</span>
                </li>
                <li class="menu-item" @click="$router.push('/articles')">
                  <el-icon><Document /></el-icon>
                  <span>文章</span>
                </li>
                <li class="menu-item" @click="openSearchDialog">
                  <el-icon><Search /></el-icon>
                  <span>搜索</span>
                </li>
                <li class="menu-item" v-if="isLoggedIn && userRole === 'admin'" @click="goToAdmin">
                  <el-icon><Setting /></el-icon>
                  <span>管理后台</span>
                </li>
                <li class="menu-item" v-if="isLoggedIn && userRole !== 'admin'" @click="goToUserCenter">
                  <el-icon><User /></el-icon>
                  <span>个人中心</span>
                </li>
              </ul>
            </div>
            

          </div>
        </aside>

        <!-- 中间内容区 -->
        <div class="main-content">
          <!-- 系统介绍横幅 -->
          <section class="hero-banner">
            <div class="hero-content">
              <h1>📝 现代化博客系统</h1>
              <p>基于 Spring Boot + Vue.js 的全栈博客平台，支持文章管理、用户系统、评论互动、搜索排序等完整功能</p>
              <div class="hero-features">
                <div class="feature-tag">✅ 完整评论系统</div>
                <div class="feature-tag">✅ 用户权限管理</div>
                <div class="feature-tag">✅ 文章搜索排序</div>
                <div class="feature-tag">✅ 响应式设计</div>
              </div>
              <div class="hero-actions" v-if="isLoggedIn">
                <el-button type="primary" @click="loadStats" :loading="statsLoading" size="small">查看系统统计</el-button>
              </div>
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

          <!-- 博客列表 -->
          <div class="blog-section">
            <div class="section-header">
              <h2 class="section-title">最新文章</h2>
            </div>
            
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
                  <p class="blog-summary">{{ blog.summary || blog.content.substring(0, 120) + '...' }}</p>
                  <div class="blog-meta">
                    <span class="blog-author">
                      <el-avatar 
                        :size="18" 
                        :src="blog.authorAvatar" 
                        :icon="UserFilled"
                        class="author-avatar"
                      />
                      {{ blog.authorName || blog.author }}
                    </span>
                    <span class="blog-date">
                      <el-icon><Calendar /></el-icon>
                      {{ formatDate(blog.publishedAt || blog.createdAt) }}
                    </span>
                    <span class="blog-views">
                      <el-icon><TrendCharts /></el-icon>
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
                layout="prev, pager, next"
                @size-change="handleSizeChange"
                @current-change="handleCurrentChange"
                small
              />
            </div>
          </div>
        </div>

        <!-- 右侧边栏 -->
        <aside class="right-sidebar">
          <div class="sidebar-content">
            <!-- 热门文章 -->
            <div class="sidebar-section">
              <h3 class="sidebar-title">热门文章</h3>
              <div class="hot-articles">
                <div 
                  v-for="(blog, index) in blogs.slice(0, 5)" 
                  :key="'hot-' + blog.id"
                  class="hot-article-item"
                  @click="goToBlogDetail(blog.id)"
                >
                  <span class="hot-rank">{{ index + 1 }}</span>
                  <div class="hot-article-content">
                    <h4 class="hot-article-title">{{ blog.title }}</h4>
                    <div class="hot-article-meta">
                      <span class="hot-views">{{ blog.viewCount || 0 }} 阅读</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- 功能特色 -->
            <div class="sidebar-section">
              <h3 class="sidebar-title">功能特色</h3>
              <div class="feature-list">
                <div class="feature-item">
                  <div class="feature-icon">📚</div>
                  <div class="feature-text">
                    <h4>文章管理</h4>
                    <p>支持创建、编辑、删除文章，分类标签管理</p>
                  </div>
                </div>
                <div class="feature-item">
                  <div class="feature-icon">👥</div>
                  <div class="feature-text">
                    <h4>用户系统</h4>
                    <p>双重角色权限，安全认证机制</p>
                  </div>
                </div>
                <div class="feature-item">
                  <div class="feature-icon">💬</div>
                  <div class="feature-text">
                    <h4>评论系统</h4>
                    <p>支持评论回复，级联删除，权限控制</p>
                  </div>
                </div>
                <div class="feature-item">
                  <div class="feature-icon">🔍</div>
                  <div class="feature-text">
                    <h4>搜索排序</h4>
                    <p>多条件搜索，按时间热度点赞排序</p>
                  </div>
                </div>
                <div class="feature-item">
                  <div class="feature-icon">📊</div>
                  <div class="feature-text">
                    <h4>数据统计</h4>
                    <p>文章浏览量，评论统计，用户数据</p>
                  </div>
                </div>
                <div class="feature-item">
                  <div class="feature-icon">🎨</div>
                  <div class="feature-text">
                    <h4>现代UI</h4>
                    <p>响应式设计，Element Plus组件</p>
                  </div>
                </div>
              </div>
            </div>

            <!-- 系统信息 -->
            <div class="sidebar-section">
              <h3 class="sidebar-title">系统信息</h3>
              <div class="system-info">
                <div class="info-item">
                  <span class="info-label">技术栈</span>
                  <span class="info-value">Spring Boot + Vue 3</span>
                </div>
                <div class="info-item">
                  <span class="info-label">版本</span>
                  <span class="info-value">v1.0.0</span>
                </div>
                <div class="info-item">
                  <span class="info-label">更新时间</span>
                  <span class="info-value">2025-01-01</span>
                </div>
              </div>
            </div>
          </div>
        </aside>
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
              <el-option label="发布时间" value="publishTime">
                <div class="option-content">
                  <el-icon><Calendar /></el-icon>
                  <span>发布时间</span>
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
import { Search, User, Calendar, View, Folder, TrendCharts, Star, Delete, ChatDotRound, UserFilled, Setting, SwitchButton, House, Document } from '@element-plus/icons-vue'
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
const userAvatar = ref('')
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
const sortBy = ref('publishTime')
const categories = ref([])
const tags = ref([])
const searchSuggestions = ref([
  "Vue.js",
  "Spring Boot",
  "JavaScript",
  "Java",
  "MySQL",
  "前端开发",
  "后端开发",
  "数据库",
  "算法",
  "架构设计"
])

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
      
      // 处理博客作者头像路径
      blogs.value.forEach(blog => {
        if (blog.authorAvatar && !blog.authorAvatar.startsWith('http')) {
          blog.authorAvatar = `http://localhost:8080${blog.authorAvatar}`
        }
      })
      
      // 为每个博客获取评论数量
      await fetchCommentCounts()
    } else {
      blogs.value = []
      total.value = 0
    }
  } catch (error) {
    console.error('获取博客列表失败:', error)
    blogs.value = []
    total.value = 0
  } finally {
    loading.value = false
  }
}

// 获取评论数量
const fetchCommentCounts = async () => {
  try {
    const promises = blogs.value.map(async (blog) => {
      try {
        const response = await axios.get(`/api/comments/blog/${blog.id}/count`)
        blog.commentCount = response.data.count || 0
      } catch (error) {
        console.error(`获取博客 ${blog.id} 评论数量失败:`, error)
        blog.commentCount = 0
      }
    })
    await Promise.all(promises)
  } catch (error) {
    console.error('获取评论数量失败:', error)
  }
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
    query.sort = sortBy.value
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
  sortBy.value = 'publishTime'
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
      // 提供默认分类数据（与Articles.vue保持一致）
      categories.value = [
        { id: 1, name: "技术分享" },
        { id: 2, name: "生活随笔" },
        { id: 3, name: "学习笔记" },
        { id: 4, name: "项目经验" }
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
      // 提供默认分类数据（与Articles.vue保持一致）
      categories.value = [
        { id: 1, name: "技术分享" },
        { id: 2, name: "生活随笔" },
        { id: 3, name: "学习笔记" },
        { id: 4, name: "项目经验" }
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
    // 提供默认标签数据（与Articles.vue保持一致）
    tags.value = [
      { id: 1, name: "Vue.js", isActive: true },
      { id: 2, name: "Spring Boot", isActive: true },
      { id: 3, name: "JavaScript", isActive: true },
      { id: 4, name: "Java", isActive: true },
      { id: 5, name: "MySQL", isActive: true },
      { id: 6, name: "前端开发", isActive: true },
      { id: 7, name: "后端开发", isActive: true }
    ]
  }
}

// 跳转到博客详情
const goToBlogDetail = (id) => {
  console.log('首页点击文章，ID:', id)
  router.push(`/blog/${id}`)
}



// 跳转到管理系统
const goToAdmin = () => {
  const userRole = localStorage.getItem('userRole')
  if (userRole === 'admin') {
    router.push('/admin')
  } else {
    router.push('/dashboard')
  }
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
const checkLoginStatus = async () => {
  const userToken = localStorage.getItem('userToken')
  const adminToken = localStorage.getItem('adminToken')
  const token = userToken || adminToken
  const storedUsername = localStorage.getItem('username')
  const storedUserRole = localStorage.getItem('userRole')
  
  let isValidToken = false
  
  if (token) {
    // 检查token格式和有效性
    if (token.startsWith('token_')) {
      // 真实token格式: token_userId_timestamp
      const parts = token.split('_')
      if (parts.length >= 3) {
        const timestamp = parseInt(parts[2])
        const currentTime = Date.now()
        // 检查token是否过期（假设token有效期为24小时）
        const tokenExpiry = 24 * 60 * 60 * 1000 // 24小时
        if (currentTime - timestamp <= tokenExpiry) {
          isValidToken = true
        } else {
          // token已过期，清理localStorage
          localStorage.removeItem('userToken')
          localStorage.removeItem('adminToken')
          localStorage.removeItem('username')
          localStorage.removeItem('userRole')
        }
      }
    } else {
      // 对于其他格式的token，暂时认为有效
      isValidToken = true
    }
  }
  
  if (isValidToken) {
    isLoggedIn.value = true
    username.value = storedUsername || '用户'
    userRole.value = storedUserRole || 'user'
    // 获取用户头像
    await fetchUserAvatar()
  } else {
    isLoggedIn.value = false
    username.value = ''
    userRole.value = ''
    userAvatar.value = ''
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

// 获取文章的第一张图片
const getFirstImage = (blog) => {
  if (!blog.images) return null
  
  try {
    const images = typeof blog.images === 'string' 
      ? JSON.parse(blog.images) 
      : blog.images
    
    if (Array.isArray(images) && images.length > 0) {
      return images[0]
    }
  } catch (error) {
    console.error('解析图片数据失败:', error)
  }
  
  return null
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

// 获取用户头像
const fetchUserAvatar = async () => {
  try {
    const token = localStorage.getItem('userToken') || localStorage.getItem('adminToken')
    if (!token) {
      console.log('没有找到用户token')
      return
    }
    
    console.log('正在获取用户头像，token:', token)
    const response = await axios.get('http://localhost:8080/api/auth/profile', {
      headers: {
        'Authorization': `Bearer ${token}`
      }
    })
    console.log('API响应:', response.data)
    if (response.data && response.data.avatar_url) {
      // 如果是相对路径，添加后端服务器地址前缀
      const avatarUrl = response.data.avatar_url.startsWith('http') 
        ? response.data.avatar_url 
        : `http://localhost:8080${response.data.avatar_url}`
      userAvatar.value = avatarUrl
      console.log('设置用户头像:', avatarUrl)
    } else {
      console.log('API响应中没有头像信息')
    }
  } catch (error) {
    console.error('获取用户头像失败:', error)
  }
}

// 跳转到个人中心
const goToUserCenter = () => {
  router.push('/dashboard')
}

// 跳转到登录页面
const goToLogin = () => {
  router.push('/login')
}

// 跳转到注册页面
const goToRegister = () => {
  router.push('/register')
}

// 组件挂载时获取数据
onMounted(async () => {
  await checkLoginStatus()
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
  align-items: center;
  width: 100%;
  max-width: 1400px;
  margin: 0 auto;
  padding: 0 20px 0 0;
  position: relative;
  height: 60px;
  gap: 20px;
}

.logo {
  flex: 0 0 240px;
  width: 240px;
  margin-left: -20px;
}

.logo h1 {
  margin: 0;
  font-size: 1.5rem;
}

.search-container {
  flex: 1;
  max-width: 700px;
  display: flex;
  justify-content: center;
  align-items: center;
  margin: 0 auto;
}

.search-wrapper {
  display: flex;
  align-items: center;
  gap: 8px;
  max-width: 700px;
  width: 100%;
}

.user-section {
  flex: 0 0 auto;
  display: flex;
  align-items: center;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  padding: 4px 8px;
  border-radius: 6px;
  transition: background-color 0.2s;
}

.user-info:hover {
  background-color: rgba(255, 255, 255, 0.1);
}

.username {
  font-size: 14px;
  font-weight: 500;
}

.auth-buttons {
  display: flex;
  gap: 8px;
}

.nav {
  flex: 0 0 auto;
}

.nav-right {
  display: flex;
  align-items: center;
}

.search-input {
  flex: 1;
  min-width: 0;
}

.search-button {
  height: 40px;
  padding: 0 20px;
  border-radius: 20px;
  font-weight: 500;
  white-space: nowrap;
  flex-shrink: 0;
}

.search-input :deep(.el-input__wrapper) {
  background-color: rgba(255, 255, 255, 0.95);
  border: 1px solid rgba(255, 255, 255, 0.4);
  border-radius: 25px;
  transition: all 0.3s ease;
  padding: 0 16px;
  height: 40px;
}

.search-input :deep(.el-input__wrapper):hover {
  background-color: rgba(255, 255, 255, 1);
  border-color: rgba(255, 255, 255, 0.5);
}

.search-input :deep(.el-input__wrapper.is-focus) {
  background-color: rgba(255, 255, 255, 1);
  border-color: #409eff;
  box-shadow: 0 0 0 2px rgba(64, 158, 255, 0.2);
}

.search-input :deep(.el-input__inner) {
  color: #333;
  font-size: 15px;
  line-height: 40px;
  padding: 0;
}

.search-input :deep(.el-input__inner::placeholder) {
  color: #888;
  font-weight: 400;
}

.search-icon {
  cursor: pointer;
  color: #666;
  transition: color 0.3s ease;
  font-size: 16px;
  padding: 8px;
}

.search-icon:hover {
  color: #409eff;
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

.user-info {
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  padding: 4px 8px;
  border-radius: 6px;
  transition: background-color 0.3s;
}

.user-info:hover {
  background-color: rgba(255, 255, 255, 0.1);
}

.user-avatar {
  border: 2px solid #fff;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  transition: transform 0.3s ease-in-out;
}

.user-info:hover .user-avatar {
  transform: scale(1.15);
}

.username {
  color: white;
  font-weight: 500;
}

.header-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  width: 100%;
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 1rem;
}

.logo {
  font-size: 1.8rem;
  font-weight: bold;
  margin: 0;
}

.nav {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 1rem;
  flex: 1;
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

.layout-container {
  display: flex;
  max-width: 1400px;
  margin: 0 auto;
  gap: 20px;
  padding: 20px;
  min-height: calc(100vh - 160px);
}

/* 左侧导航栏 */
.sidebar {
  width: 240px;
  flex-shrink: 0;
}

.sidebar-content {
  background: white;
  border-radius: 12px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
  overflow: hidden;
  position: sticky;
  top: 100px;
}

.sidebar-section {
  padding: 20px;
  border-bottom: 1px solid #f0f0f0;
}

.sidebar-section:last-child {
  border-bottom: none;
}

.sidebar-title {
  font-size: 16px;
  font-weight: 600;
  color: #333;
  margin: 0 0 15px 0;
}

.sidebar-menu {
  list-style: none;
  padding: 0;
  margin: 0;
}

.menu-item {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 12px 16px;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s ease;
  color: #666;
  font-size: 14px;
}

.menu-item:hover {
  background-color: #f5f7fa;
  color: #409eff;
}

.menu-item.active {
  background-color: #409eff;
  color: white;
}

.quick-actions {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

/* 中间内容区 */
.main-content {
  flex: 1;
  min-width: 0;
}

.hero-banner {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border-radius: 12px;
  padding: 40px;
  margin-bottom: 30px;
  text-align: center;
}

.hero-content h1 {
  font-size: 2.5rem;
  margin-bottom: 15px;
  font-weight: 700;
}

.hero-content p {
  font-size: 1.1rem;
  margin-bottom: 20px;
  opacity: 0.9;
}

.hero-features {
  display: flex;
  gap: 12px;
  justify-content: center;
  flex-wrap: wrap;
  margin-bottom: 25px;
}

.feature-tag {
  background: rgba(255, 255, 255, 0.2);
  color: white;
  padding: 8px 16px;
  border-radius: 20px;
  font-size: 0.9rem;
  font-weight: 500;
  border: 1px solid rgba(255, 255, 255, 0.3);
  backdrop-filter: blur(10px);
  transition: all 0.3s ease;
}

.feature-tag:hover {
  background: rgba(255, 255, 255, 0.3);
  transform: translateY(-2px);
}

.hero-actions {
  display: flex;
  gap: 10px;
  justify-content: center;
  flex-wrap: wrap;
}

/* 右侧边栏 */
.right-sidebar {
  width: 280px;
  flex-shrink: 0;
}

.hot-articles {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.hot-article-item {
  display: flex;
  align-items: flex-start;
  gap: 12px;
  padding: 12px;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s ease;
  border: 1px solid #f0f0f0;
}

.hot-article-item:hover {
  background-color: #f5f7fa;
  border-color: #409eff;
}

.hot-rank {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 24px;
  height: 24px;
  background: linear-gradient(45deg, #409eff, #67c23a);
  color: white;
  border-radius: 50%;
  font-size: 12px;
  font-weight: bold;
  flex-shrink: 0;
}

.hot-article-content {
  flex: 1;
  min-width: 0;
}

.hot-article-title {
  font-size: 14px;
  font-weight: 500;
  color: #333;
  margin: 0 0 6px 0;
  line-height: 1.4;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.hot-article-meta {
  font-size: 12px;
  color: #999;
}

.hot-views {
  display: flex;
  align-items: center;
  gap: 4px;
}

.feature-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.feature-item {
  display: flex;
  align-items: flex-start;
  gap: 12px;
  padding: 16px;
  background: #f8fafc;
  border-radius: 8px;
  border: 1px solid #e2e8f0;
  transition: all 0.3s ease;
}

.feature-item:hover {
  background: #f1f5f9;
  border-color: #cbd5e1;
  transform: translateY(-2px);
}

.feature-icon {
  font-size: 24px;
  flex-shrink: 0;
}

.feature-text h4 {
  font-size: 14px;
  font-weight: 600;
  color: #333;
  margin: 0 0 4px 0;
}

.feature-text p {
  font-size: 12px;
  color: #666;
  margin: 0;
  line-height: 1.4;
}

.system-info {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.info-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 8px 0;
  border-bottom: 1px solid #f0f0f0;
}

.info-item:last-child {
  border-bottom: none;
}

.info-label {
  font-size: 13px;
  color: #666;
  font-weight: 500;
}

.info-value {
  font-size: 13px;
  color: #333;
  font-weight: 600;
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
  margin-bottom: 40px;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 25px;
  padding-bottom: 15px;
  border-bottom: 2px solid #f0f0f0;
}

.section-title {
  font-size: 1.8rem;
  margin: 0;
  color: #333;
  font-weight: 600;
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
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: 20px;
  margin-bottom: 30px;
}

.blog-card {
  background: white;
  border-radius: 12px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
  overflow: hidden;
  transition: all 0.3s ease;
  cursor: pointer;
  border: 1px solid #e8e8e8;
}

.blog-card:hover {
  transform: translateY(-3px);
  box-shadow: 0 6px 24px rgba(0, 0, 0, 0.12);
  border-color: #409eff;
}

.blog-card-content {
  padding: 20px;
}

.blog-title {
  font-size: 1.2rem;
  font-weight: 600;
  color: #333;
  margin-bottom: 12px;
  line-height: 1.4;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.blog-summary {
  color: #666;
  line-height: 1.5;
  margin-bottom: 16px;
  font-size: 14px;
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.blog-meta {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  font-size: 13px;
  color: #888;
}

.blog-image {
  margin-bottom: 1rem;
  border-radius: 8px;
  overflow: hidden;
}

.blog-image img {
  width: 100%;
  height: 200px;
  object-fit: cover;
  transition: transform 0.3s ease;
}

.blog-image:hover img {
  transform: scale(1.05);
}

/* 响应式设计 */
@media (max-width: 768px) {
  .blog-card {
    max-width: 100%;
    padding: 1rem;
  }
  
  .blog-meta {
    gap: 0.5rem;
    font-size: 0.8rem;
  }
  
  .blog-title {
    font-size: 1.1rem;
  }
}

.blog-meta span {
  display: flex;
  align-items: center;
  gap: 0.25rem;
}

.blog-author {
  display: flex;
  align-items: center;
  gap: 6px;
  color: #666;
  font-size: 14px;
}

.author-avatar {
  border: 1px solid #e0e0e0;
  flex-shrink: 0;
}

.blog-comments {
  color: #10b981 !important;
}

.blog-comments:hover {
  color: #059669 !important;
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
  background-color: rgba(255, 255, 255, 0.1);
  color: white;
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
  color: rgba(255, 255, 255, 0.4);
  font-size: 0.9rem;
  transition: all 0.3s ease;
  border-radius: 50%;
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: transparent;
  border: none;
  box-shadow: none;
  opacity: 0.6;
}

:deep(.search-dialog .el-dialog__headerbtn .el-dialog__close:hover) {
  color: rgba(255, 255, 255, 0.9);
  background: rgba(255, 255, 255, 0.08);
  opacity: 1;
  transform: none;
}

:deep(.search-dialog .el-dialog__headerbtn .el-dialog__close:active) {
  background: rgba(255, 255, 255, 0.12);
  transition: all 0.1s ease;
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
  transition: all 0.3s ease;
}

.dialog-footer .el-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);
}

.dialog-footer .el-button--primary:hover {
  box-shadow: 0 6px 20px rgba(79, 70, 229, 0.4);
}

.dialog-footer .el-button:not(.el-button--primary):hover {
  background: #f1f5f9;
  border-color: #cbd5e1;
  color: #475569;
}

/* 响应式设计 */
@media (max-width: 1200px) {
  .layout-container {
    max-width: 100%;
    padding: 15px;
  }
  
  .right-sidebar {
    width: 260px;
  }
}

@media (max-width: 992px) {
  .layout-container {
    flex-direction: column;
    gap: 20px;
  }
  
  .sidebar,
  .right-sidebar {
    width: 100%;
    order: 2;
  }
  
  .main-content {
    order: 1;
  }
  
  .sidebar-content {
    position: static;
  }
  
  .sidebar-section {
    padding: 15px;
  }
  
  .blog-grid {
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
    gap: 15px;
  }
}

@media (max-width: 768px) {
  .header-content {
    flex-direction: column;
    height: auto;
    padding: 15px;
    gap: 1rem;
  }
  
  .logo {
    position: static;
    transform: none;
    width: auto;
    text-align: center;
    left: auto;
    margin-left: 0;
  }
  
  .search-container {
    position: static;
    transform: none;
    width: 100%;
    max-width: 100%;
    left: auto;
    right: auto;
  }
  
  .user-section {
    position: static;
    transform: none;
    order: -1;
    align-self: flex-end;
  }
  
  .search-wrapper {
    max-width: 100%;
  }
  
  .nav {
    flex-direction: column;
    gap: 1rem;
  }
  
  .nav-links {
    flex-wrap: wrap;
    justify-content: center;
  }

  .layout-container {
    padding: 10px;
    gap: 15px;
  }
  
  .hero-banner {
    padding: 30px 20px;
  }

  .hero-content h1 {
    font-size: 2rem;
  }

  .hero-content p {
    font-size: 1rem;
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
    gap: 15px;
  }
  
  .blog-grid {
    grid-template-columns: 1fr;
    gap: 15px;
  }
  
  .section-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 15px;
  }
  
  .sidebar {
    order: 3;
  }
  
  .right-sidebar {
    order: 2;
  }
  
  .feature-list {
    gap: 12px;
  }
  
  .feature-item {
    padding: 12px;
  }
  
  .hot-articles {
    gap: 10px;
  }
  
  .hot-article-item {
    padding: 10px;
  }
  
  .blog-meta {
    flex-direction: column;
    gap: 0.5rem;
  }

  /* 导航栏响应式 */
  .header-content {
    flex-direction: column;
    gap: 1rem;
    align-items: stretch;
  }
  
  .logo {
    text-align: center;
  }
  
  .search-container {
    order: 2;
  }
  
  .search-wrapper {
    max-width: none;
    flex-direction: column;
    gap: 8px;
  }
  
  .search-input {
    width: 100%;
  }
  
  .search-button {
    width: 100%;
    border-radius: 8px;
  }
  
  .nav {
    order: 3;
    justify-content: center;
  }
  
  .nav-right {
     justify-content: center;
     width: 100%;
  }
  
  .nav-search {
    order: -1;
    width: 100%;
  }
  
  .search-input {
    width: 100%;
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

@media (max-width: 480px) {
  .layout-container {
    padding: 8px;
  }
  
  .hero-banner {
    padding: 20px 15px;
  }
  
  .hero-content h1 {
    font-size: 1.8rem;
  }
  
  .blog-card-content {
    padding: 15px;
  }
  
  .sidebar-section {
    padding: 12px;
  }
  
  .menu-item {
    padding: 10px 12px;
    font-size: 13px;
  }
}
</style>