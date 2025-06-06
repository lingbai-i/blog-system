<template>
  <div class="admin-page">
    <!-- 头部导航 -->
    <header class="admin-header">
      <div class="header-content">
        <div class="header-left">
          <h1 class="admin-title">博客管理后台</h1>
        </div>
        <div class="header-right">
          <span class="admin-info">
            <el-icon><User /></el-icon>
            欢迎，{{ adminInfo.username }}
          </span>
          <el-button @click="goToHomepage" :icon="SwitchButton">返回首页</el-button>
        </div>
      </div>
    </header>

    <!-- 主要内容 -->
    <main class="admin-main">
      <div class="admin-container">
        <!-- 统计卡片 -->
        <section class="stats-section">
          <div class="stats-grid">
            <div class="stat-card">
              <div class="stat-icon total">
                <el-icon><Document /></el-icon>
              </div>
              <div class="stat-content">
                <p class="stat-label">总文章数</p>
                <h3 class="stat-number">{{ stats.totalBlogs }}</h3>
              </div>
            </div>
            
            <div class="stat-card">
              <div class="stat-icon views">
                <el-icon><View /></el-icon>
              </div>
              <div class="stat-content">
                <p class="stat-label">总浏览量</p>
                <h3 class="stat-number">{{ stats.totalViews }}</h3>
              </div>
            </div>
            
            <div class="stat-card">
              <div class="stat-icon today">
                <el-icon><Calendar /></el-icon>
              </div>
              <div class="stat-content">
                <p class="stat-label">今日发布</p>
                <h3 class="stat-number">{{ stats.todayPosts }}</h3>
              </div>
            </div>
          </div>
        </section>

        <!-- 管理标签页 -->
        <div class="admin-tabs">
          <el-tabs v-model="activeTab" @tab-change="handleTabChange">
            <el-tab-pane label="文章管理" name="blogs">
              <!-- 文章管理部分 -->
              <div class="section-header">
                <h2 class="section-title">文章列表</h2>
                <el-button type="primary" @click="showCreateDialog" :icon="Plus">新建文章</el-button>
              </div>

              <div class="search-filters">
                <div class="search-row">
                  <div class="search-input">
                    <el-input
                      v-model="searchKeyword"
                      placeholder="搜索文章标题"
                      :prefix-icon="Search"
                      clearable
                      @keyup.enter="fetchBlogs"
                    />
                  </div>
                  <!-- 移除状态过滤器，只显示已发布文章 -->
                  <el-button type="primary" @click="fetchBlogs">搜索</el-button>
                </div>
              </div>

              <el-table :data="blogs" stripe border class="blog-table" v-loading="loading">
                <el-table-column prop="id" label="ID" width="80" />
                <el-table-column prop="title" label="标题" min-width="200">
                  <template #default="{ row }">
                    <div class="blog-title-cell">
                      <span class="blog-title-text">{{ row.title }}</span>
                    </div>
                  </template>
                </el-table-column>
                <el-table-column prop="authorName" label="作者" width="120" />
                <el-table-column prop="createdAt" label="创建时间" width="180" />
                <el-table-column prop="viewCount" label="浏览量" width="100" />
                <el-table-column prop="isPublished" label="状态" width="100">
                  <template #default="{ row }">
                    <el-tag :type="row.isPublished ? 'success' : 'info'">
                      {{ row.isPublished ? '已发布' : '草稿' }}
                    </el-tag>
                  </template>
                </el-table-column>
                <el-table-column label="操作" width="200" fixed="right">
                  <template #default="{ row }">
                    <div class="action-buttons">
                      <el-button size="small" @click="viewBlog(row.id)" :icon="View">查看</el-button>
                      <el-button size="small" type="danger" @click="confirmDelete(row.id)" :icon="Delete">删除</el-button>
                    </div>
                  </template>
                </el-table-column>
              </el-table>

              <div class="pagination">
                <el-pagination
                  v-model:current-page="currentPage"
                  v-model:page-size="pageSize"
                  :page-sizes="[10, 20, 50, 100]"
                  layout="total, sizes, prev, pager, next, jumper"
                  :total="total"
                  @size-change="fetchBlogs"
                  @current-change="fetchBlogs"
                />
              </div>
            </el-tab-pane>

            <el-tab-pane label="分类管理" name="categories">
              <CategoryManagement />
            </el-tab-pane>

            <el-tab-pane label="标签管理" name="tags">
              <TagManagement />
            </el-tab-pane>
          </el-tabs>
        </div>
      </div>
    </main>

    <!-- 创建/编辑文章对话框 -->
    <el-dialog
      v-model="dialogVisible"
      title="创建文章"
      width="70%"
      destroy-on-close
    >
      <el-form ref="blogFormRef" :model="blogForm" label-width="80px">
        <el-form-item label="标题" prop="title">
          <el-input v-model="blogForm.title" placeholder="请输入文章标题" />
        </el-form-item>
        <el-form-item label="内容" prop="content">
          <el-input
            v-model="blogForm.content"
            type="textarea"
            :rows="10"
            placeholder="请输入文章内容"
          />
        </el-form-item>

      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button type="primary" @click="saveBlog" :loading="saving">发布</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, watch } from 'vue'
import { useRouter } from 'vue-router'
import {
  User, SwitchButton, Document, View, Calendar,
  Plus, Search, Delete
} from '@element-plus/icons-vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import axios from 'axios'

// 导入分类和标签管理组件
import CategoryManagement from '../components/CategoryManagement.vue'
import TagManagement from '../components/TagManagement.vue'

const router = useRouter()

// 响应式数据
const adminInfo = ref({ username: 'Admin' })
const stats = ref({
  totalBlogs: 0,
  totalViews: 0,
  todayPosts: 0
})

// 标签页相关
const activeTab = ref('blogs')

const blogs = ref([])
const loading = ref(false)
const searchKeyword = ref('')
const statusFilter = ref('published') // 默认只显示已发布文章
const currentPage = ref(1)
const pageSize = ref(10)
const total = ref(0)

// 对话框相关
const dialogVisible = ref(false)

const saving = ref(false)
const blogFormRef = ref()

const blogForm = reactive({
  title: '',
  author: '',
  content: '',
  status: 'published'
})

const blogRules = {
  title: [
    { required: true, message: '请输入文章标题', trigger: 'blur' },
    { min: 1, max: 200, message: '标题长度在 1 到 200 个字符', trigger: 'blur' }
  ],
  author: [
    { required: true, message: '请输入作者', trigger: 'blur' }
  ],
  content: [
    { required: true, message: '请输入文章内容', trigger: 'blur' },
    { min: 10, message: '内容至少需要 10 个字符', trigger: 'blur' }
  ]
}

// 获取统计数据
// const fetchStats = async () => {
//   try {
//     const response = await axios.get('/api/admin/stats')
//     if (response.data.success) {
//       stats.value = response.data.data
//     }
//   } catch (error) {
//     console.error('获取统计数据失败:', error)
//     // 基于实际博客数据计算统计信息
//     await calculateStatsFromBlogs()
//   }
// }

// 基于博客数据计算统计信息
const calculateStatsFromBlogs = async () => {
  try {
    // 获取所有博客数据用于统计
    const response = await axios.get('/api/admin/blogs', {
      params: {
        page: 0,
        size: 1000, // 获取足够多的数据用于统计
        keyword: '',
        status: ''
      }
    })
    
    let allBlogs = []
    if (response.data.success) {
      allBlogs = response.data.data.content || []
    } else {
      // 如果API失败，使用模拟数据
      allBlogs = getMockBlogs()
    }
    
    // 计算统计数据
    const totalBlogs = allBlogs.length
    const totalViews = allBlogs.reduce((sum, blog) => sum + (blog.views || 0), 0)
    
    // 计算今日发布的文章数
    const today = new Date()
    const todayStart = new Date(today.getFullYear(), today.getMonth(), today.getDate())
    const todayPosts = allBlogs.filter(blog => {
      const blogDate = new Date(blog.createdAt)
      return blogDate >= todayStart && blog.status === 'published'
    }).length
    
    stats.value = {
      totalBlogs,
      totalViews,
      todayPosts
    }
  } catch (error) {
    console.error('计算统计数据失败:', error)
    // 使用默认的模拟数据
    const mockBlogs = getMockBlogs()
    stats.value = {
      totalBlogs: mockBlogs.length,
      totalViews: mockBlogs.reduce((sum, blog) => sum + (blog.views || 0), 0),
      todayPosts: 0
    }
  }
}

// 获取博客列表
const fetchBlogs = async () => {
  loading.value = true
  try {
    const params = {
      page: currentPage.value - 1,
      size: pageSize.value
    }
    
    if (searchKeyword.value) {
      params.keyword = searchKeyword.value
    }
    
    // 始终只显示已发布的文章
    params.status = 'published'
    
    const response = await axios.get('/api/admin/blogs', { params })
    if (response.data.success && response.data.data) {
      blogs.value = response.data.data.content
      total.value = response.data.data.totalElements
    } else {
      blogs.value = []
      total.value = 0
    }
  } catch (error) {
    console.error('获取博客列表失败:', error)
    ElMessage.error('获取博客列表失败')
  } finally {
    loading.value = false
  }
}

// 查看博客
const viewBlog = (id) => {
  router.push(`/blog/${id}`)
}

// 显示创建对话框
const showCreateDialog = () => {
  resetBlogForm()
  dialogVisible.value = true
}

// 重置表单
const resetBlogForm = () => {
  blogForm.title = ''
  blogForm.author = adminInfo.value.username || 'Admin'
  blogForm.content = ''
  blogForm.status = 'published'
}

// 保存博客
const saveBlog = async () => {
  saving.value = true
  try {
    const blogData = { 
      ...blogForm,
      isPublished: true // 确保发布状态为true
    }
    const response = await axios.post('/api/blogs', blogData)
    
    if (response.data.success && response.data.data) {
      // 将新创建的文章插入到列表开头
      const newBlog = response.data.data
      blogs.value.unshift(newBlog)
      total.value += 1
      
      ElMessage.success('文章发布成功')
    } else {
      ElMessage.success('文章发布成功')
      // 如果没有返回数据，则重新获取列表
      fetchBlogs()
    }
    
    dialogVisible.value = false
  } catch (error) {
    console.error('发布文章失败:', error)
    ElMessage.error('发布文章失败')
  } finally {
    saving.value = false
  }
}

// 确认删除
const confirmDelete = (id) => {
  ElMessageBox.confirm(
    '确定要删除这篇博客吗？此操作不可逆。',
    '删除确认',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning',
    }
  )
    .then(() => {
      deleteBlog(id)
    })
    .catch(() => {
      // 用户取消删除
    })
}

// 删除博客
const deleteBlog = async (id) => {
  try {
    await axios.delete(`/api/admin/blogs/${id}`)
    ElMessage.success('博客删除成功')
    fetchBlogs()
  } catch (error) {
    console.error('删除博客失败:', error)
    ElMessage.error('删除博客失败')
  }
}

// 获取统计数据
const fetchStats = async () => {
  try {
    const response = await axios.get('/api/admin/stats')
    if (response.data.success) {
      const data = response.data.data
      stats.value = {
        totalBlogs: data.totalBlogs || 0,
        totalViews: data.totalViews || 0,
        todayPosts: data.todayPosts || 0
      }
    }
  } catch (error) {
    console.error('获取统计数据失败:', error)
    // 如果API失败，使用计算方式
    await calculateStatsFromBlogs()
  }
}

// 页面加载时获取数据
// 监听路由变化，切换标签页
onMounted(() => {
  // 从localStorage获取当前登录用户信息
  const storedUsername = localStorage.getItem('username')
  if (storedUsername) {
    adminInfo.value.username = storedUsername
    blogForm.author = storedUsername
  }
  
  fetchStats()
  fetchBlogs()
  
  // 根据路由元信息设置当前标签页
  const { tab } = router.currentRoute.value.meta
  if (tab) {
    activeTab.value = tab
  }
})

// 监听标签页变化，更新路由
const handleTabChange = (tab) => {
  if (tab === 'blogs') {
    router.push({ name: 'AdminBlogs' })
  } else if (tab === 'categories') {
    router.push({ name: 'AdminCategories' })
  } else if (tab === 'tags') {
    router.push({ name: 'AdminTags' })
  }
}

// 监听activeTab变化
watch(activeTab, (newTab) => {
  handleTabChange(newTab)
})

// 返回首页
const goToHomepage = () => {
  router.push('/')
}
</script>

<style>
#app {
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #2c3e50;
  min-height: 100vh;
}

.admin-page {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}

.admin-header {
  background-color: #fff;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  padding: 0.5rem 1rem;
  position: sticky;
  top: 0;
  z-index: 100;
}

.header-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  max-width: 1400px;
  margin: 0 auto;
  padding: 0.5rem 0;
}

.admin-title {
  font-size: 1.5rem;
  font-weight: 600;
  color: #409EFF;
  margin: 0;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.admin-info {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.admin-main {
  flex: 1;
  padding: 1.5rem;
  background-color: #f5f7fa;
}

.admin-container {
  max-width: 1400px;
  margin: 0 auto;
}

.admin-tabs {
  margin-top: 1.5rem;
  background-color: #fff;
  border-radius: 4px;
  padding: 1rem;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
}

.stats-section {
  margin-bottom: 1.5rem;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 1rem;
}

.stat-card {
  background-color: #fff;
  border-radius: 4px;
  padding: 1.5rem;
  display: flex;
  align-items: center;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
}

.stat-icon {
  width: 48px;
  height: 48px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 1rem;
}

.stat-icon.total {
  background-color: rgba(64, 158, 255, 0.1);
  color: #409EFF;
}

.stat-icon.views {
  background-color: rgba(103, 194, 58, 0.1);
  color: #67C23A;
}

.stat-icon.today {
  background-color: rgba(230, 162, 60, 0.1);
  color: #E6A23C;
}

.stat-icon.published {
  background-color: rgba(144, 147, 153, 0.1);
  color: #909399;
}

.stat-content {
  flex: 1;
}

.stat-number {
  font-size: 1.5rem;
  font-weight: 600;
  margin: 0;
  line-height: 1.2;
}

.stat-label {
  color: #909399;
  margin: 0.25rem 0 0;
  font-size: 0.875rem;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1rem;
}

.section-title {
  font-size: 1.25rem;
  font-weight: 600;
  color: #303133;
  margin: 0;
}

.search-filters {
  margin-bottom: 1rem;
}

.search-row {
  display: flex;
  gap: 1rem;
}

.search-input {
  flex: 1;
}

.blog-table {
  margin-bottom: 1rem;
}

.blog-title-cell {
  display: flex;
  align-items: center;
}

.blog-title-text {
  font-weight: 500;
}

.action-buttons {
  display: flex;
  gap: 0.5rem;
}

.pagination {
  margin-top: 1rem;
  display: flex;
  justify-content: flex-end;
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
  margin-top: 1rem;
}

@media (max-width: 768px) {
  .stats-grid {
    grid-template-columns: 1fr;
  }
  
  .search-row {
    flex-direction: column;
  }
  
  .action-buttons {
    flex-wrap: wrap;
  }
}

@media (max-width: 1024px) and (min-width: 769px) {
  .stats-grid {
    grid-template-columns: repeat(3, 1fr);
  }
}
</style>