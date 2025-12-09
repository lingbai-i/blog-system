<template>
  <div class="user-dashboard">
    <!-- 头部导航 -->
    <header class="header">
      <div class="container">
        <div class="header-content">
          <h1 class="logo">个人博客 - 用户后台</h1>
          <div class="user-info">
            <span class="welcome">欢迎，{{ userInfo.username }}</span>
          </div>
        </div>
      </div>
    </header>

    <!-- 主要内容 -->
    <main class="main">
      <div class="container">
        <div class="dashboard-content">
          <!-- 侧边栏 -->
          <aside class="sidebar">
            <el-menu
              :default-active="activeMenu"
              class="sidebar-menu"
              @select="handleMenuSelect"
            >
              <el-menu-item index="home">
                <el-icon><House /></el-icon>
                <span>首页</span>
              </el-menu-item>
              <el-menu-item index="my-blogs">
                <el-icon><Document /></el-icon>
                <span>我的发布</span>
              </el-menu-item>
              <el-menu-item index="statistics">
                <el-icon><DataAnalysis /></el-icon>
                <span>个人统计</span>
              </el-menu-item>
              <el-menu-item index="create-blog">
                <el-icon><EditPen /></el-icon>
                <span>写文章</span>
              </el-menu-item>
              <el-menu-item index="profile">
                <el-icon><User /></el-icon>
                <span>个人资料</span>
              </el-menu-item>
            </el-menu>
          </aside>

          <!-- 内容区域 -->
          <div class="content">
            <!-- 我的文章 -->
            <div v-if="activeMenu === 'my-blogs'" class="content-section">
              <div class="section-header">
                <h2>我的发布</h2>
                <el-button type="primary" @click="activeMenu = 'create-blog'">
                  <el-icon><Plus /></el-icon>
                  写新文章
                </el-button>
              </div>
              
              <div v-if="loading" class="loading">
                <el-skeleton :rows="3" animated />
              </div>
              
              <div v-else-if="myBlogs.length === 0" class="empty">
                <el-empty description="还没有发布，快去写一篇吧！" />
              </div>
              
              <div v-else class="blog-list">
                <div v-for="blog in myBlogs" :key="blog.id" class="blog-item">
                  <div class="blog-info">
                    <h3 
                      class="blog-title" 
                      :class="{ 'clickable': blog.status === 'PUBLISHED' }"
                      @click="blog.status === 'PUBLISHED' ? goToBlogDetail(blog.id) : null"
                    >
                      {{ blog.title }}
                    </h3>
                    <p class="blog-summary">{{ blog.summary }}</p>
                    <div class="blog-meta">
                      <span class="meta-item">
                        <el-icon><Calendar /></el-icon>
                        {{ formatDate(blog.status === 'PUBLISHED' ? (blog.publishedAt || blog.createdAt) : blog.createdAt) }}
                      </span>
                      <span class="meta-item">
                        <el-icon><View /></el-icon>
                        {{ blog.viewCount || 0 }}
                      </span>
                      <el-tag :type="blog.status === 'PUBLISHED' ? 'success' : 'warning'" size="small">
                        {{ blog.status === 'PUBLISHED' ? '已发布' : '草稿' }}
                      </el-tag>
                    </div>
                  </div>
                  <div class="blog-actions">
                    <el-button 
                      v-if="blog.status === 'PUBLISHED'" 
                      size="small" 
                      type="primary" 
                      @click="goToBlogDetail(blog.id)"
                    >
                      查看
                    </el-button>
                    <el-button size="small" @click="editBlog(blog)">编辑</el-button>
                    <el-button 
                      size="small" 
                      :type="blog.status === 'PUBLISHED' ? 'warning' : 'success'"
                      @click="togglePublish(blog)"
                    >
                      {{ blog.status === 'PUBLISHED' ? '取消发布' : '发布' }}
                    </el-button>
                    <el-button size="small" type="danger" @click="deleteBlog(blog)">删除</el-button>
                  </div>
                </div>
              </div>
            </div>

            <!-- 写文章 -->
            <div v-if="activeMenu === 'create-blog'" class="content-section">
              <div class="redirect-section">
                <div class="redirect-card">
                  <el-icon class="redirect-icon"><EditPen /></el-icon>
                  <h2>写新文章</h2>
                  <p>点击下方按钮跳转到专业的文章编辑页面</p>
                  <el-button type="primary" size="large" @click="goToPublish">
                    <el-icon><EditPen /></el-icon>
                    开始写作
                  </el-button>
                </div>
              </div>
            </div>

            <!-- 个人统计 -->
            <div v-if="activeMenu === 'statistics'" class="content-section">
              <div class="section-header">
                <h2>个人统计</h2>
              </div>
              
              <div v-if="statisticsLoading" class="loading">
                <el-skeleton :rows="5" animated />
              </div>
              
              <div v-else class="statistics-content">
                <!-- 发布统计 -->
                <div class="stats-card">
                  <h3>发布统计</h3>
                  <div class="stats-grid">
                    <div class="stat-item">
                      <div class="stat-number">{{ publishStats.totalPublished }}</div>
                      <div class="stat-label">已发布文章</div>
                    </div>
                    <div class="stat-item">
                      <div class="stat-number">{{ publishStats.totalDrafts }}</div>
                      <div class="stat-label">草稿文章</div>
                    </div>
                    <div class="stat-item">
                      <div class="stat-number">{{ publishStats.thisMonthCount }}</div>
                      <div class="stat-label">本月发布</div>
                    </div>
                  </div>
                  
                  <!-- 分类统计 -->
                  <div v-if="publishStats.categoryStats && publishStats.categoryStats.length > 0" class="category-stats">
                    <h4>分类统计</h4>
                    <div class="category-list">
                      <div v-for="category in publishStats.categoryStats" :key="category.category" class="category-item">
                        <span class="category-name">{{ category.category || '未分类' }}</span>
                        <span class="category-count">{{ category.count }}篇</span>
                      </div>
                    </div>
                  </div>
                </div>
                
                <!-- 热度统计 -->
                <div class="stats-card">
                  <h3>热度统计</h3>
                  <div class="stats-grid">
                    <div class="stat-item">
                      <div class="stat-number">{{ popularityStats.totalViews }}</div>
                      <div class="stat-label">总浏览量</div>
                    </div>
                    <div class="stat-item">
                      <div class="stat-number">{{ popularityStats.totalLikes }}</div>
                      <div class="stat-label">总点赞数</div>
                    </div>
                    <div class="stat-item">
                      <div class="stat-number">{{ popularityStats.avgViews }}</div>
                      <div class="stat-label">平均浏览量</div>
                    </div>
                    <div class="stat-item">
                      <div class="stat-number">{{ popularityStats.avgLikes }}</div>
                      <div class="stat-label">平均点赞数</div>
                    </div>
                  </div>
                  
                  <!-- 最受欢迎文章 -->
                  <div v-if="popularityStats.topViewedArticles && popularityStats.topViewedArticles.length > 0" class="top-articles">
                    <h4>最受欢迎文章（按浏览量）</h4>
                    <div class="article-list">
                      <div v-for="article in popularityStats.topViewedArticles" :key="article.id" class="article-item">
                        <span class="article-title" @click="goToBlogDetail(article.id)">{{ article.title }}</span>
                        <span class="article-views">{{ article.viewCount }}次浏览</span>
                      </div>
                    </div>
                  </div>
                  
                  <div v-if="popularityStats.topLikedArticles && popularityStats.topLikedArticles.length > 0" class="top-articles">
                    <h4>最受欢迎文章（按点赞数）</h4>
                    <div class="article-list">
                      <div v-for="article in popularityStats.topLikedArticles" :key="article.id" class="article-item">
                        <span class="article-title" @click="goToBlogDetail(article.id)">{{ article.title }}</span>
                        <span class="article-likes">{{ article.likeCount }}个赞</span>
                      </div>
                    </div>
                  </div>
                </div>
                
                <!-- 点赞统计 -->
                <div class="stats-card">
                  <h3>我的点赞</h3>
                  <div class="stats-grid">
                    <div class="stat-item">
                      <div class="stat-number">{{ likeStats.totalLikedArticles }}</div>
                      <div class="stat-label">点赞文章数</div>
                    </div>
                  </div>
                  
                  <!-- 我点赞的文章列表 -->
                  <div v-if="likedArticles && likedArticles.length > 0" class="liked-articles">
                    <h4>我点赞的文章</h4>
                    <div class="article-list">
                      <div v-for="article in likedArticles.slice(0, 10)" :key="article.id" class="article-item">
                        <span class="article-title" @click="goToBlogDetail(article.id)">{{ article.title }}</span>
                        <span class="article-author">作者：{{ article.authorName }}</span>
                        <span class="article-date">{{ formatDate(article.likedAt) }}</span>
                      </div>
                    </div>
                    <div v-if="likedArticles.length > 10" class="show-more">
                      <el-button text @click="showAllLikedArticles = !showAllLikedArticles">
                        {{ showAllLikedArticles ? '收起' : `查看全部${likedArticles.length}篇` }}
                      </el-button>
                    </div>
                    <div v-if="showAllLikedArticles" class="article-list">
                      <div v-for="article in likedArticles.slice(10)" :key="article.id" class="article-item">
                        <span class="article-title" @click="goToBlogDetail(article.id)">{{ article.title }}</span>
                        <span class="article-author">作者：{{ article.authorName }}</span>
                        <span class="article-date">{{ formatDate(article.likedAt) }}</span>
                      </div>
                    </div>
                  </div>
                  
                  <div v-else class="empty-liked">
                    <el-empty description="还没有点赞任何文章" />
                  </div>
                </div>
                

              </div>
            </div>

            <!-- 个人资料 -->
            <div v-if="activeMenu === 'profile'" class="content-section">
              <h2>个人资料</h2>
              <el-form
                ref="profileFormRef"
                :model="profileForm"
                :rules="profileRules"
                label-width="80px"
                class="profile-form"
              >
                <el-form-item label="头像">
                  <div class="avatar-upload">
                    <el-avatar 
                      :size="80" 
                      :src="profileForm.avatar || '/default-avatar.png'"
                      class="avatar-preview"
                    >
                      <el-icon><User /></el-icon>
                    </el-avatar>
                    <div class="upload-actions">
                      <el-upload
                        :action="'/api/upload/avatar'"
                        :headers="uploadHeaders"
                        :show-file-list="false"
                        :on-success="handleAvatarSuccess"
                        :on-error="handleAvatarError"
                        :before-upload="beforeAvatarUpload"
                        name="file"
                        accept="image/*"
                      >
                        <el-button size="small" type="primary">上传头像</el-button>
                      </el-upload>
                      <el-button 
                        v-if="profileForm.avatar" 
                        size="small" 
                        type="danger" 
                        @click="removeAvatar"
                      >
                        删除头像
                      </el-button>
                    </div>
                  </div>
                </el-form-item>
                <el-form-item label="用户名" prop="username">
                  <el-input 
                    v-model="profileForm.username" 
                    placeholder="请输入用户名"
                    clearable
                  />
                </el-form-item>
                <el-form-item label="邮箱" prop="email">
                  <el-input 
                    v-model="profileForm.email" 
                    placeholder="请输入邮箱地址（可选）"
                    clearable
                  />
                </el-form-item>
                <el-form-item label="简介" prop="bio">
                  <el-input 
                    v-model="profileForm.bio" 
                    type="textarea"
                    :rows="4"
                    placeholder="请输入个人简介（可选，最多500字）"
                    maxlength="500"
                    show-word-limit
                    clearable
                  />
                </el-form-item>
                <el-form-item label="注册时间">
                  <span>{{ formatDate(userInfo.createdAt) }}</span>
                </el-form-item>
                <el-form-item>
                  <el-button 
                    type="primary" 
                    @click="updateProfile"
                    :loading="updatingProfile"
                  >
                    保存资料
                  </el-button>
                </el-form-item>
              </el-form>
            </div>
          </div>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  Document,
  EditPen,
  User,
  Plus,
  Calendar,
  View,
  House,
  DataAnalysis
} from '@element-plus/icons-vue'
import axios from 'axios'

const router = useRouter()
const activeMenu = ref('my-blogs')
const loading = ref(false)
const profileFormRef = ref()
const updatingProfile = ref(false)

// 用户信息
const userInfo = reactive({
  username: '',
  email: '',
  role: 'user',
  createdAt: ''
})

// 个人资料表单
const profileForm = reactive({
  username: '',
  email: '',
  bio: '',
  avatar: ''
})

// 上传头像的请求头
const uploadHeaders = computed(() => {
  const token = localStorage.getItem('userToken') || localStorage.getItem('adminToken')
  return token ? {
    'Authorization': `Bearer ${token}`
  } : {}
})

// 个人资料验证规则
const profileRules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' },
    { min: 2, max: 20, message: '用户名长度在 2 到 20 个字符', trigger: 'blur' }
  ],
  email: [
    { type: 'email', message: '请输入正确的邮箱格式', trigger: 'blur' }
  ],
  bio: [
    { max: 100, message: '简介长度不能超过个字符', trigger: 'blur' }
  ]
}

// 我的文章列表
const myBlogs = ref([])

// 个人统计相关数据
const statisticsLoading = ref(false)
const showAllLikedArticles = ref(false)

// 发布统计
const publishStats = reactive({
  totalPublished: 0,
  totalDrafts: 0,
  thisMonthCount: 0,
  categoryStats: []
})

// 热度统计
const popularityStats = reactive({
  totalViews: 0,
  totalLikes: 0,
  averageViews: 0,
  averageLikes: 0,
  topViewedArticles: [],
  topLikedArticles: []
})

// 点赞统计
const likeStats = reactive({
  totalLikedArticles: 0
})

// 我点赞的文章列表
const likedArticles = ref([])





// 菜单选择
const handleMenuSelect = (index) => {
  if (index === 'home') {
    router.push('/')
    return
  }
  activeMenu.value = index
  if (index === 'my-blogs') {
    fetchMyBlogs()
  } else if (index === 'statistics') {
    fetchStatistics()
  }
}

// 获取用户信息
const fetchUserInfo = async () => {
  try {
    const token = localStorage.getItem('userToken') || localStorage.getItem('adminToken')
    console.log('Token found:', !!token)
    
    const config = token ? {
      headers: {
        'Authorization': `Bearer ${token}`
      }
    } : {}
    
    const response = await axios.get('/api/auth/profile', config)
    Object.assign(userInfo, response.data)
    console.log('User info from API:', response.data)
    // 初始化个人资料表单
    profileForm.username = response.data.username || ''
    profileForm.email = response.data.email || ''
    profileForm.bio = response.data.bio || ''
    // 确保头像URL包含完整的服务器地址
    const avatarUrl = response.data.avatar_url || ''
    profileForm.avatar = avatarUrl && !avatarUrl.startsWith('http') ? `http://localhost:8080${avatarUrl}` : avatarUrl
  } catch (error) {
    console.warn('获取用户信息失败:', error)
    // 从localStorage获取基本信息
    const username = localStorage.getItem('username')
    const userRole = localStorage.getItem('userRole')
    console.log('Username from localStorage:', username)
    console.log('UserRole from localStorage:', userRole)
    
    if (username) {
      const userData = {
        username: username,
        email: '',
        bio: '',
        role: userRole || 'user',
        createdAt: ''
      }
      Object.assign(userInfo, userData)
      console.log('User info set from localStorage:', userData)
      // 初始化个人资料表单
      profileForm.username = username
      profileForm.email = ''
      profileForm.bio = ''
      profileForm.avatar = ''
    } else {
      console.error('No username found in localStorage')
      // 初始化个人资料表单
      profileForm.email = ''
      profileForm.bio = ''
    }
  }
}

// 获取我的文章
const fetchMyBlogs = async () => {
  loading.value = true
  try {
    const token = localStorage.getItem('userToken') || localStorage.getItem('adminToken')
    const config = token ? {
      headers: {
        'Authorization': `Bearer ${token}`
      }
    } : {}
    
    const response = await axios.get('/api/blogs/my', config)
    myBlogs.value = response.data.content || response.data || []
  } catch (error) {
    console.warn('获取文章列表失败:', error)
    myBlogs.value = []
  } finally {
    loading.value = false
  }
}

// 编辑文章 - 跳转到发布页面
const editBlog = (blog) => {
  // 将文章数据存储到sessionStorage，供Publish页面使用
  sessionStorage.setItem('editingBlog', JSON.stringify(blog))
  router.push('/publish')
}

// 跳转到发布页面
const goToPublish = () => {
  router.push('/publish')
}

// 切换发布状态
const togglePublish = async (blog) => {
  try {
    const token = localStorage.getItem('userToken') || localStorage.getItem('adminToken')
    const config = token ? {
      headers: {
        'Authorization': `Bearer ${token}`
      }
    } : {}
    
    const action = blog.status === 'PUBLISHED' ? 'unpublish' : 'publish'
    await axios.put(`/api/blogs/${blog.id}/${action}`, {}, config)
    blog.status = blog.status === 'PUBLISHED' ? 'DRAFT' : 'PUBLISHED'
    ElMessage.success(blog.status === 'PUBLISHED' ? '文章已发布' : '文章已取消发布')
  } catch (error) {
    ElMessage.error('操作失败，请稍后重试')
  }
}

// 删除文章
const deleteBlog = async (blog) => {
  try {
    await ElMessageBox.confirm('确定要删除这篇文章吗？', '确认删除', {
      type: 'warning'
    })
    
    const token = localStorage.getItem('userToken') || localStorage.getItem('adminToken')
    const config = token ? {
      headers: {
        'Authorization': `Bearer ${token}`
      }
    } : {}
    
    await axios.delete(`/api/blogs/${blog.id}`, config)
    ElMessage.success('文章删除成功')
    fetchMyBlogs()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('删除失败，请稍后重试')
    }
  }
}





// 更新个人资料
const updateProfile = async () => {
  try {
    await profileFormRef.value.validate()
    updatingProfile.value = true
    
    const token = localStorage.getItem('userToken') || localStorage.getItem('adminToken')
    const config = token ? {
      headers: {
        'Authorization': `Bearer ${token}`
      }
    } : {}
    
    const response = await axios.put('/api/auth/profile', {
      username: profileForm.username,
      email: profileForm.email,
      bio: profileForm.bio,
      avatar: profileForm.avatar
    }, config)
    
    // 更新用户信息
    userInfo.username = profileForm.username
    userInfo.email = profileForm.email
    userInfo.bio = profileForm.bio
    userInfo.avatar = profileForm.avatar
    
    // 更新localStorage中的用户名
    localStorage.setItem('username', profileForm.username)
    
    ElMessage.success('个人资料更新成功')
  } catch (error) {
    if (error.response) {
      ElMessage.error(error.response.data.message || '更新失败')
    } else if (error.errors) {
      // 表单验证错误
      return
    } else {
      ElMessage.error('网络错误，请稍后重试')
    }
  } finally {
    updatingProfile.value = false
  }
}

// 跳转到文章详情页
const goToBlogDetail = (id) => {
  console.log('用户后台点击文章，ID:', id)
  router.push(`/blog/${id}`)
}

// 格式化日期
const formatDate = (date) => {
  if (!date) return ''
  const d = new Date(date)
  return d.toLocaleDateString('zh-CN')
}



// 头像上传前的验证
const beforeAvatarUpload = (file) => {
  const isImage = file.type.startsWith('image/')
  const isLt2M = file.size / 1024 / 1024 < 2

  if (!isImage) {
    ElMessage.error('只能上传图片文件!')
    return false
  }
  if (!isLt2M) {
    ElMessage.error('上传头像图片大小不能超过 2MB!')
    return false
  }
  return true
}

// 头像上传成功
const handleAvatarSuccess = (response) => {
  if (response.success && response.url) {
    // 确保URL包含完整的服务器地址
    const avatarUrl = response.url.startsWith('http') ? response.url : `http://localhost:8080${response.url}`
    profileForm.avatar = avatarUrl
    ElMessage.success('头像上传成功')
  } else {
    ElMessage.error(response.message || '头像上传失败')
  }
}

// 头像上传失败
const handleAvatarError = (error) => {
  console.error('头像上传失败:', error)
  ElMessage.error('头像上传失败，请稍后重试')
}

// 删除头像
const removeAvatar = async () => {
  try {
    await ElMessageBox.confirm('确定要删除头像吗？', '确认删除', {
      type: 'warning'
    })
    
    if (profileForm.avatar) {
      // 如果有头像URL，尝试删除服务器上的文件
      const token = localStorage.getItem('userToken') || localStorage.getItem('adminToken')
      const config = token ? {
        headers: {
          'Authorization': `Bearer ${token}`
        }
      } : {}
      
      try {
        await axios.delete('/api/upload/delete', {
          ...config,
          data: { url: profileForm.avatar }
        })
      } catch (error) {
        console.warn('删除服务器文件失败:', error)
      }
    }
    
    profileForm.avatar = ''
    ElMessage.success('头像删除成功')
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('删除头像失败')
    }
  }
}



// 获取个人统计数据
const fetchStatistics = async () => {
  statisticsLoading.value = true
  try {
    const token = localStorage.getItem('userToken') || localStorage.getItem('adminToken')
    const config = token ? {
      headers: {
        'Authorization': `Bearer ${token}`
      }
    } : {}
    
    // 使用已经获取的用户信息，如果没有则尝试从API获取
    let currentUser = userInfo
    
    // 如果userInfo中没有用户名，尝试从API获取
    if (!currentUser.username) {
      try {
        const userResponse = await axios.get('/api/auth/profile', config)
        currentUser = userResponse.data
        // 更新userInfo
        Object.assign(userInfo, currentUser)
      } catch (error) {
        console.warn('无法从API获取用户信息，尝试从localStorage获取')
        const username = localStorage.getItem('username')
        const userId = localStorage.getItem('userId')
        if (username) {
          currentUser = {
            username: username,
            id: userId ? parseInt(userId) : null
          }
        } else {
          console.error('无法获取用户信息')
          ElMessage.warning('请先登录以查看统计数据')
          return
        }
      }
    }
    
    // 检查用户名是否有效
    if (!currentUser.username) {
      console.warn('用户名无效，跳过统计数据获取')
      ElMessage.warning('请先登录以查看统计数据')
      return
    }
    
    console.log('获取统计数据的用户信息:', currentUser)
    
    // 并行获取各种统计数据
    const promises = [
      axios.get(`/api/user-statistics/publish/${currentUser.username}`, config),
      axios.get(`/api/user-statistics/popularity/${currentUser.username}`, config)
    ]
    
    // 只有当用户ID存在时才获取基于ID的统计
    if (currentUser.id) {
      promises.push(
        axios.get(`/api/user-statistics/likes/${currentUser.id}`, config),
        axios.get(`/api/user-statistics/liked-articles/${currentUser.id}`, config)
      )
    }
    
    const responses = await Promise.all(promises)
    
    // 更新发布统计
    Object.assign(publishStats, responses[0].data)
    
    // 更新热度统计
    Object.assign(popularityStats, responses[1].data)
    
    // 更新点赞统计（如果有的话）
    if (responses.length > 2) {
      Object.assign(likeStats, responses[2].data)
      likedArticles.value = responses[3].data?.content || []
    } else {
      // 重置点赞统计
      Object.assign(likeStats, { totalLikedArticles: 0 })
      likedArticles.value = []
    }
    
  } catch (error) {
    console.warn('获取统计数据失败:', error)
    ElMessage.error('获取统计数据失败，请稍后重试')
  } finally {
    statisticsLoading.value = false
  }
}

// 组件挂载
onMounted(() => {
  fetchUserInfo()
  fetchMyBlogs()
})
</script>

<style scoped>
.user-dashboard {
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
  font-size: 1.5rem;
  font-weight: bold;
  margin: 0;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.welcome {
  font-weight: 500;
}

.main {
  padding: 2rem 0;
}

.dashboard-content {
  display: flex;
  gap: 2rem;
  min-height: 600px;
}

.sidebar {
  width: 200px;
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  overflow: hidden;
}

.sidebar-menu {
  border: none;
}

.content {
  flex: 1;
  background: white;
  border-radius: 8px;
  padding: 2rem;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.content-section h2 {
  margin-bottom: 1.5rem;
  color: #333;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1.5rem;
}

.section-header h2 {
  margin: 0;
}

.blog-list {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.blog-item {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  padding: 1.5rem;
  border: 1px solid #e0e0e0;
  border-radius: 8px;
  transition: box-shadow 0.3s;
}

.blog-item:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.blog-info {
  flex: 1;
}

.blog-title {
  margin: 0 0 0.5rem 0;
  font-size: 1.2rem;
  color: #333;
}

.blog-title.clickable {
  cursor: pointer;
  transition: color 0.3s ease;
}

.blog-title.clickable:hover {
  color: #409eff;
  text-decoration: underline;
}

.blog-summary {
  margin: 0 0 1rem 0;
  color: #666;
  line-height: 1.5;
}

.blog-meta {
  display: flex;
  align-items: center;
  gap: 1rem;
  font-size: 0.9rem;
  color: #999;
}

.meta-item {
  display: flex;
  align-items: center;
  gap: 0.25rem;
}

.blog-actions {
  display: flex;
  gap: 0.5rem;
  margin-left: 1rem;
}

.blog-form {
  max-width: 800px;
}

.profile-form {
  max-width: 400px;
}

.loading,
.empty {
  text-align: center;
  padding: 2rem;
}

/* 个人统计样式 */
.statistics-content {
  display: flex;
  flex-direction: column;
  gap: 2rem;
}

.stats-card {
  background: #f8f9fa;
  border-radius: 8px;
  padding: 1.5rem;
  border: 1px solid #e9ecef;
}

.stats-card h3 {
  margin: 0 0 1rem 0;
  color: #495057;
  font-size: 1.2rem;
  font-weight: 600;
}

.stats-card h4 {
  margin: 1.5rem 0 1rem 0;
  color: #6c757d;
  font-size: 1rem;
  font-weight: 500;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
  gap: 1rem;
  margin-bottom: 1rem;
}

.stat-item {
  background: white;
  padding: 1rem;
  border-radius: 6px;
  text-align: center;
  border: 1px solid #dee2e6;
}

.stat-number {
  font-size: 2rem;
  font-weight: bold;
  color: #007bff;
  margin-bottom: 0.5rem;
}

.stat-label {
  color: #6c757d;
  font-size: 0.9rem;
}

.category-stats,
.top-articles,
.liked-articles {
  margin-top: 1rem;
}

.category-list,
.article-list {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.category-item,
.article-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0.75rem;
  background: white;
  border-radius: 4px;
  border: 1px solid #dee2e6;
}

.category-name,
.article-title {
  font-weight: 500;
  color: #495057;
}

.article-title {
  cursor: pointer;
  transition: color 0.2s;
}

.article-title:hover {
  color: #007bff;
}

.category-count,
.article-views,
.article-likes,
.article-author,
.article-date {
  color: #6c757d;
  font-size: 0.9rem;
}

.show-more {
  text-align: center;
  margin: 1rem 0;
}

.empty-liked {
  text-align: center;
  padding: 2rem;
  color: #6c757d;
}

/* 标签统计样式 */
.tag-usage-list {
  margin-top: 1.5rem;
}

.tag-list {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.tag-item {
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 0.75rem;
  background: #ffffff;
  border: 1px solid #e9ecef;
  border-radius: 6px;
  transition: all 0.2s ease;
}

.tag-item:hover {
  border-color: #409eff;
  box-shadow: 0 2px 8px rgba(64, 158, 255, 0.1);
}

.tag-rank {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 24px;
  height: 24px;
  background: #409eff;
  color: white;
  border-radius: 50%;
  font-size: 0.8rem;
  font-weight: 600;
  flex-shrink: 0;
}

.tag-info {
  flex: 1;
  min-width: 0;
}

.tag-name {
  display: block;
  font-weight: 600;
  color: #333;
  margin-bottom: 0.25rem;
}

.tag-description {
  display: block;
  font-size: 0.85rem;
  color: #666;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.tag-usage {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  min-width: 120px;
}

.usage-bar {
  flex: 1;
  height: 8px;
  background: #f0f0f0;
  border-radius: 4px;
  overflow: hidden;
  min-width: 60px;
}

.usage-fill {
  height: 100%;
  background: linear-gradient(90deg, #409eff, #67c23a);
  border-radius: 4px;
  transition: width 0.3s ease;
}

.usage-count {
  font-size: 0.85rem;
  color: #666;
  white-space: nowrap;
}

.empty-tags {
  text-align: center;
  padding: 2rem;
  color: #6c757d;
}

@media (max-width: 768px) {
  .dashboard-content {
    flex-direction: column;
  }
  
  .sidebar {
    width: 100%;
  }
  
  .blog-item {
    flex-direction: column;
    gap: 1rem;
  }
  
  .blog-actions {
    margin-left: 0;
    justify-content: flex-start;
  }
}

/* 头像上传样式 */
.avatar-upload {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.avatar-preview {
  border: 2px solid #dcdfe6;
}

.upload-actions {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

/* 文章图片上传样式 */
.article-images {
  width: 100%;
}

.image-upload-area {
  width: 100%;
}

.upload-tip {
  margin-top: 0.5rem;
  color: #909399;
  font-size: 12px;
}

.upload-tip p {
  margin: 0;
}

/* Element Plus 上传组件样式调整 */
:deep(.el-upload--picture-card) {
  width: 100px;
  height: 100px;
}

:deep(.el-upload-list--picture-card .el-upload-list__item) {
  width: 100px;
  height: 100px;
}

.avatar-uploader-icon {
  font-size: 28px;
  color: #8c939d;
  width: 100px;
  height: 100px;
  text-align: center;
  line-height: 100px;
}

/* 跳转页面样式 */
.redirect-section {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 400px;
  padding: 2rem;
}

.redirect-card {
  background: #fff;
  border-radius: 12px;
  padding: 3rem 2rem;
  text-align: center;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  border: 1px solid #e4e7ed;
  max-width: 400px;
  width: 100%;
}

.redirect-icon {
  font-size: 48px;
  color: #409eff;
  margin-bottom: 1rem;
}

.redirect-card h2 {
  color: #303133;
  margin-bottom: 1rem;
  font-size: 24px;
  font-weight: 600;
}

.redirect-card p {
  color: #606266;
  margin-bottom: 2rem;
  font-size: 16px;
  line-height: 1.5;
}

.redirect-card .el-button {
  padding: 12px 24px;
  font-size: 16px;
  border-radius: 8px;
}
</style>