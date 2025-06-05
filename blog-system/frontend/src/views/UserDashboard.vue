<template>
  <div class="user-dashboard">
    <!-- 头部导航 -->
    <header class="header">
      <div class="container">
        <div class="header-content">
          <h1 class="logo">个人博客 - 用户后台</h1>
          <div class="user-info">
            <span class="welcome">欢迎，{{ userInfo.username }}</span>
            <el-button type="danger" plain @click="handleLogout">退出登录</el-button>
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
                    <h3 class="blog-title">{{ blog.title }}</h3>
                    <p class="blog-summary">{{ blog.summary }}</p>
                    <div class="blog-meta">
                      <span class="meta-item">
                        <el-icon><Calendar /></el-icon>
                        {{ formatDate(blog.createdAt) }}
                      </span>
                      <span class="meta-item">
                        <el-icon><View /></el-icon>
                        {{ blog.viewCount || 0 }}
                      </span>
                      <el-tag :type="blog.isPublished ? 'success' : 'warning'" size="small">
                        {{ blog.isPublished ? '已发布' : '草稿' }}
                      </el-tag>
                    </div>
                  </div>
                  <div class="blog-actions">
                    <el-button size="small" @click="editBlog(blog)">编辑</el-button>
                    <el-button 
                      size="small" 
                      :type="blog.isPublished ? 'warning' : 'success'"
                      @click="togglePublish(blog)"
                    >
                      {{ blog.isPublished ? '取消发布' : '发布' }}
                    </el-button>
                    <el-button size="small" type="danger" @click="deleteBlog(blog)">删除</el-button>
                  </div>
                </div>
              </div>
            </div>

            <!-- 写文章 -->
            <div v-if="activeMenu === 'create-blog'" class="content-section">
              <h2>{{ editingBlog ? '编辑文章' : '写新文章' }}</h2>
              <el-form
                ref="blogFormRef"
                :model="blogForm"
                :rules="blogRules"
                label-width="80px"
                class="blog-form"
              >
                <el-form-item label="标题" prop="title">
                  <el-input v-model="blogForm.title" placeholder="请输入文章标题" />
                </el-form-item>
                <el-form-item label="摘要" prop="summary">
                  <el-input
                    v-model="blogForm.summary"
                    type="textarea"
                    :rows="3"
                    placeholder="请输入文章摘要"
                  />
                </el-form-item>
                <el-form-item label="分类" prop="category">
                  <el-input v-model="blogForm.category" placeholder="请输入文章分类" />
                </el-form-item>
                <el-form-item label="标签" prop="tags">
                  <el-input v-model="blogForm.tags" placeholder="请输入标签，用逗号分隔" />
                </el-form-item>
                <el-form-item label="内容" prop="content">
                  <el-input
                    v-model="blogForm.content"
                    type="textarea"
                    :rows="15"
                    placeholder="请输入文章内容（支持 Markdown）"
                  />
                </el-form-item>
                <el-form-item>
                  <el-button type="primary" @click="saveBlog(false)" :loading="saving">
                    保存草稿
                  </el-button>
                  <el-button type="success" @click="saveBlog(true)" :loading="saving">
                    发布文章
                  </el-button>
                  <el-button @click="cancelEdit">取消</el-button>
                </el-form-item>
              </el-form>
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
                <el-form-item label="用户名">
                  <el-input v-model="userInfo.username" disabled />
                </el-form-item>
                <el-form-item label="邮箱" prop="email">
                  <el-input 
                    v-model="profileForm.email" 
                    placeholder="请输入邮箱地址（可选）"
                    clearable
                  />
                </el-form-item>
                <el-form-item label="角色">
                  <el-tag :type="userInfo.role === 'admin' ? 'danger' : 'primary'">
                    {{ userInfo.role === 'admin' ? '管理员' : '普通用户' }}
                  </el-tag>
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
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  Document,
  EditPen,
  User,
  Plus,
  Calendar,
  View,
  House
} from '@element-plus/icons-vue'
import axios from 'axios'

const router = useRouter()
const activeMenu = ref('my-blogs')
const loading = ref(false)
const saving = ref(false)
const blogFormRef = ref()
const profileFormRef = ref()
const editingBlog = ref(null)
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
  email: ''
})

// 个人资料验证规则
const profileRules = {
  email: [
    { type: 'email', message: '请输入正确的邮箱格式', trigger: 'blur' }
  ]
}

// 我的文章列表
const myBlogs = ref([])

// 文章表单
const blogForm = reactive({
  title: '',
  summary: '',
  content: '',
  category: '',
  tags: ''
})

// 表单验证规则
const blogRules = {
  title: [
    { required: true, message: '请输入文章标题', trigger: 'blur' }
  ],
  summary: [
    { required: true, message: '请输入文章摘要', trigger: 'blur' }
  ],
  content: [
    { required: true, message: '请输入文章内容', trigger: 'blur' }
  ]
}

// 菜单选择
const handleMenuSelect = (index) => {
  if (index === 'home') {
    router.push('/')
    return
  }
  activeMenu.value = index
  if (index === 'my-blogs') {
    fetchMyBlogs()
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
    profileForm.email = response.data.email || ''
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
        role: userRole || 'user',
        createdAt: ''
      }
      Object.assign(userInfo, userData)
      console.log('User info set from localStorage:', userData)
    } else {
      console.error('No username found in localStorage')
    }
    // 初始化个人资料表单
    profileForm.email = ''
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

// 编辑文章
const editBlog = (blog) => {
  editingBlog.value = blog
  Object.assign(blogForm, {
    title: blog.title,
    summary: blog.summary,
    content: blog.content,
    category: blog.category,
    tags: blog.tags
  })
  activeMenu.value = 'create-blog'
}

// 保存文章
const saveBlog = async (publish = false) => {
  if (!blogFormRef.value) return
  
  try {
    await blogFormRef.value.validate()
    saving.value = true
    
    const token = localStorage.getItem('userToken') || localStorage.getItem('adminToken')
    const config = token ? {
      headers: {
        'Authorization': `Bearer ${token}`
      }
    } : {}
    
    const blogData = {
      ...blogForm,
      isPublished: publish
    }
    
    if (editingBlog.value) {
      await axios.put(`/api/blogs/${editingBlog.value.id}`, blogData, config)
      ElMessage.success('文章更新成功')
    } else {
      await axios.post('/api/blogs', blogData, config)
      ElMessage.success(publish ? '文章发布成功' : '草稿保存成功')
    }
    
    resetBlogForm()
    activeMenu.value = 'my-blogs'
    fetchMyBlogs()
  } catch (error) {
    ElMessage.error('保存失败，请稍后重试')
  } finally {
    saving.value = false
  }
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
    
    const action = blog.isPublished ? 'unpublish' : 'publish'
    await axios.put(`/api/blogs/${blog.id}/${action}`, {}, config)
    blog.isPublished = !blog.isPublished
    ElMessage.success(blog.isPublished ? '文章已发布' : '文章已取消发布')
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

// 取消编辑
const cancelEdit = () => {
  resetBlogForm()
  activeMenu.value = 'my-blogs'
}

// 重置表单
const resetBlogForm = () => {
  Object.assign(blogForm, {
    title: '',
    summary: '',
    content: '',
    category: '',
    tags: ''
  })
  editingBlog.value = null
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
      email: profileForm.email
    }, config)
    
    // 更新用户信息
    userInfo.email = profileForm.email
    
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

// 退出登录
const handleLogout = async () => {
  try {
    await ElMessageBox.confirm('确定要退出登录吗？', '确认退出', {
      type: 'warning'
    })
    
    localStorage.removeItem('userToken')
    localStorage.removeItem('userRole')
    localStorage.removeItem('username')
    
    ElMessage.success('已退出登录')
    router.push('/')
  } catch (error) {
    // 用户取消
  }
}

// 格式化日期
const formatDate = (date) => {
  if (!date) return ''
  const d = new Date(date)
  return d.toLocaleDateString('zh-CN')
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
</style>