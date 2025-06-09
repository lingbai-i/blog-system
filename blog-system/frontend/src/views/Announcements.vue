<template>
  <div class="announcements-page">
    <!-- 头部导航 -->
    <header class="header">
      <div class="header-content">
        <div class="logo">
          <h1 @click="goHome">📝 个人博客系统</h1>
        </div>

        <nav class="nav">
          <router-link to="/" class="nav-link">首页</router-link>
          <router-link to="/articles" class="nav-link">文章</router-link>
          <router-link to="/announcements" class="nav-link active">公告</router-link>
          <router-link to="/publish" class="nav-link" v-if="isLoggedIn">发布文章</router-link>
        </nav>

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
                <span class="username">{{ username || '用户' }}</span>
              </div>
              <template #dropdown>
                <el-dropdown-menu>
                  <el-dropdown-item @click="goToUserCenter">
                    <el-icon><User /></el-icon>
                    个人中心
                  </el-dropdown-item>
                  <el-dropdown-item @click="goToPublish">
                    <el-icon><EditPen /></el-icon>
                    发布文章
                  </el-dropdown-item>
                  <el-dropdown-item @click="handleSwitchAccount">
                    <el-icon><RefreshRight /></el-icon>
                    切换账号
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
      </div>
    </header>

    <div class="page-header">
      <h1>公告列表</h1>
      <p class="subtitle">查看所有已发布的公告信息</p>
    </div>

    <div class="announcements-container">
      <!-- 加载状态 -->
      <div v-if="loading" class="loading-container">
        <el-skeleton :rows="5" animated />
      </div>

      <!-- 公告列表 -->
      <div v-else-if="announcements.length > 0" class="announcements-list">
        <div 
          v-for="announcement in announcements" 
          :key="announcement.id"
          class="announcement-card"
          @click="viewAnnouncement(announcement.id)"
        >
          <div class="card-header">
            <h3 class="announcement-title">
              <el-icon v-if="announcement.isPinned" class="pin-icon"><Top /></el-icon>
              {{ announcement.title }}
            </h3>
            <span class="publish-date">{{ formatDate(announcement.publishedAt) }}</span>
          </div>
          
          <div class="card-content">
            <p class="announcement-preview">{{ getPreview(announcement.content) }}</p>
          </div>
          
          <div class="card-footer">
            <span class="author">发布者：{{ announcement.authorName }}</span>
            <el-button type="primary" size="small" plain>
              查看详情
              <el-icon><ArrowRight /></el-icon>
            </el-button>
          </div>
        </div>
      </div>

      <!-- 空状态 -->
      <div v-else class="empty-state">
        <el-empty description="暂无公告">
          <el-button type="primary" @click="refreshAnnouncements">刷新</el-button>
        </el-empty>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import axios from 'axios'
import { ElMessage, ElSkeleton, ElEmpty, ElButton, ElIcon, ElDropdown, ElDropdownMenu, ElDropdownItem, ElAvatar } from 'element-plus'
import { Top, ArrowRight, UserFilled, User, EditPen, SwitchButton, House, RefreshRight } from '@element-plus/icons-vue'

const router = useRouter()
const announcements = ref([])
const loading = ref(true)

// 用户相关数据
const isLoggedIn = ref(false)
const username = ref('')
const userRole = ref('')
const userAvatar = ref('')

// 获取公告列表
const fetchAnnouncements = async () => {
  try {
    loading.value = true
    const response = await axios.get('/api/announcements/published')
    if (response.data.success) {
      announcements.value = response.data.data
    } else {
      ElMessage.error('获取公告列表失败')
    }
  } catch (error) {
    console.error('获取公告列表失败:', error)
    ElMessage.error('获取公告列表失败，请稍后重试')
  } finally {
    loading.value = false
  }
}

// 查看公告详情
const viewAnnouncement = (id) => {
  router.push(`/announcements/${id}`)
}

// 刷新公告列表
const refreshAnnouncements = () => {
  fetchAnnouncements()
}

// 格式化日期
const formatDate = (dateString) => {
  if (!dateString) return ''
  const date = new Date(dateString)
  return date.toLocaleDateString('zh-CN', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit'
  })
}

// 获取内容预览
const getPreview = (content) => {
  if (!content) return ''
  // 移除HTML标签并截取前100个字符
  const plainText = content.replace(/<[^>]*>/g, '')
  return plainText.length > 100 ? plainText.substring(0, 100) + '...' : plainText
}

// 用户登录状态检查（使用ref版本的isLoggedIn）

// 初始化用户信息
const initUserInfo = () => {
  const token = localStorage.getItem('userToken') || localStorage.getItem('adminToken')
  if (token) {
    isLoggedIn.value = true
    username.value = localStorage.getItem('username') || ''
    userRole.value = localStorage.getItem('userRole') || ''
    fetchUserAvatar()
  }
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

// 导航方法
const goHome = () => {
  router.push('/')
}

const goToLogin = () => {
  router.push('/login')
}

const goToRegister = () => {
  router.push('/register')
}

const goToUserCenter = () => {
  router.push('/dashboard')
}

const goToPublish = () => {
  router.push('/publish')
}

const handleSwitchAccount = () => {
  // 清除登录状态
  localStorage.removeItem('token')
  localStorage.removeItem('userInfo')
  localStorage.removeItem('userToken')
  localStorage.removeItem('adminToken')
  localStorage.removeItem('userRole')
  localStorage.removeItem('username')
  ElMessage.success('切换账号成功')
  router.push('/login')
}

const handleLogout = () => {
  // 清除登录状态
  localStorage.removeItem('token')
  localStorage.removeItem('userInfo')
  ElMessage.success('退出成功')
  router.push('/')
}

onMounted(() => {
  initUserInfo()
  fetchAnnouncements()
})
</script>

<style scoped>
.announcements-page {
  min-height: 100vh;
}

/* 头部导航样式 */
.header {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 1rem 0;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
  position: sticky;
  top: 0;
  z-index: 1000;
}

.header-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  width: 100%;
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 1rem;
  gap: 1rem;
}

.logo {
  font-size: 1.8rem;
  font-weight: bold;
  margin: 0;
}

.logo h1 {
  color: white;
  font-size: 1.8rem;
  font-weight: 600;
  cursor: pointer;
  margin: 0;
  transition: opacity 0.3s ease;
}

.logo h1:hover {
  opacity: 0.8;
}

.nav {
  display: flex;
  gap: 20px;
  align-items: center;
  flex: 1;
  justify-content: flex-end;
  margin-right: 2rem;
}

.home-btn {
  background: rgba(255, 255, 255, 0.2) !important;
  border: 1px solid rgba(255, 255, 255, 0.3) !important;
  color: white !important;
  font-weight: 600;
  border-radius: 20px;
  transition: all 0.3s ease;
}

.home-btn:hover {
  background: rgba(255, 255, 255, 0.3) !important;
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.nav-link {
  color: white;
  text-decoration: none;
  padding: 0.5rem 1rem;
  border-radius: 5px;
  transition: background-color 0.3s;
  font-weight: 500;
}

.nav-link:hover {
  background-color: rgba(255, 255, 255, 0.1);
}

.nav-link.active {
  background-color: rgba(255, 255, 255, 0.2);
  font-weight: 600;
}

.user-section {
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

.auth-buttons {
  display: flex;
  gap: 0.5rem;
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

.announcements-page .page-header {
  max-width: 1200px;
  margin: 0 auto;
  padding: 40px 20px;
}

.announcements-page .announcements-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px 20px;
}

.page-header {
  text-align: center;
  margin-bottom: 40px;
  padding: 40px 0;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border-radius: 12px;
}

.page-header h1 {
  font-size: 2.5rem;
  margin: 0 0 10px 0;
  font-weight: 600;
}

.subtitle {
  font-size: 1.1rem;
  margin: 0;
  opacity: 0.9;
}

.announcements-container {
  min-height: 400px;
}

.loading-container {
  padding: 20px;
}

.announcements-list {
  display: grid;
  gap: 20px;
}

.announcement-card {
  background: white;
  border-radius: 12px;
  padding: 24px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
  transition: all 0.3s ease;
  cursor: pointer;
  border: 1px solid #f0f0f0;
}

.announcement-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
  border-color: #409eff;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 16px;
}

.announcement-title {
  font-size: 1.3rem;
  font-weight: 600;
  color: #303133;
  margin: 0;
  display: flex;
  align-items: center;
  gap: 8px;
  flex: 1;
}

.pin-icon {
  color: #f56c6c;
  font-size: 1.1rem;
}

.publish-date {
  color: #909399;
  font-size: 0.9rem;
  white-space: nowrap;
  margin-left: 16px;
}

.card-content {
  margin-bottom: 20px;
}

.announcement-preview {
  color: #606266;
  line-height: 1.6;
  margin: 0;
  font-size: 0.95rem;
}

.card-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 16px;
  border-top: 1px solid #f5f5f5;
}

.author {
  color: #909399;
  font-size: 0.9rem;
}

.empty-state {
  padding: 60px 20px;
  text-align: center;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .announcements-page {
    padding: 10px;
  }
  
  .page-header {
    padding: 30px 20px;
    margin-bottom: 20px;
  }
  
  .page-header h1 {
    font-size: 2rem;
  }
  
  .announcement-card {
    padding: 20px;
  }
  
  .card-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 8px;
  }
  
  .publish-date {
    margin-left: 0;
  }
  
  .card-footer {
    flex-direction: column;
    align-items: flex-start;
    gap: 12px;
  }
}
</style>