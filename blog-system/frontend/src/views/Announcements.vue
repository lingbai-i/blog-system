<template>
  <div class="announcements-page">
    <!-- 头部导航 -->
    <header class="header">
      <div class="header-content">
        <div class="logo">
          <h1 @click="goHome">📝 个人博客系统</h1>
        </div>

        <div class="user-section">
          <template v-if="isLoggedIn">
            <el-dropdown trigger="hover" placement="bottom-end">
              <div class="user-info">
                <el-avatar 
                  :size="32" 
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
        <nav class="nav">
           <el-button @click="goHome" type="primary" size="small" class="home-btn">
             <el-icon><House /></el-icon>
             返回首页
           </el-button>
           <router-link to="/" class="nav-link">首页</router-link>
           <router-link to="/articles" class="nav-link">文章</router-link>
           <router-link to="/announcements" class="nav-link active">公告</router-link>
           <router-link to="/publish" class="nav-link" v-if="isLoggedIn">发布文章</router-link>
         </nav>
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

// 检查用户登录状态
const isLoggedIn = computed(() => {
  return localStorage.getItem('token') !== null
})

// 获取用户名
const username = computed(() => {
  const userInfo = localStorage.getItem('userInfo')
  if (userInfo) {
    const user = JSON.parse(userInfo)
    return user.username || user.name || '用户'
  }
  return '用户'
})

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
  router.push('/user-center')
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
  color: white;
  position: sticky;
  top: 0;
  z-index: 1000;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.header-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 70px;
}

.logo h1 {
  margin: 0;
  font-size: 1.5rem;
  font-weight: 600;
  cursor: pointer;
  transition: opacity 0.3s ease;
}

.logo h1:hover {
  opacity: 0.8;
}

.nav {
  display: flex;
  gap: 20px;
  align-items: center;
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
  font-weight: 500;
  padding: 8px 16px;
  border-radius: 20px;
  transition: all 0.3s ease;
  position: relative;
}

.nav-link:hover {
  background: rgba(255, 255, 255, 0.1);
  transform: translateY(-1px);
}

.nav-link.active {
  background: rgba(255, 255, 255, 0.2);
  font-weight: 600;
}

.user-section {
  display: flex;
  align-items: center;
  gap: 15px;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  padding: 8px 12px;
  border-radius: 20px;
  transition: background 0.3s ease;
}

.user-info:hover {
  background: rgba(255, 255, 255, 0.1);
}

.user-avatar {
  border: 2px solid rgba(255, 255, 255, 0.3);
}

.username {
  font-weight: 500;
  font-size: 14px;
}

.auth-buttons {
  display: flex;
  gap: 10px;
}

.auth-buttons .el-button {
  border-radius: 20px;
  font-weight: 500;
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