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
            欢迎，{{ adminInfo?.username || 'Admin' }}
          </span>
          <el-button @click="goToHomepage">返回首页</el-button>
          <el-button @click="handleLogout" type="danger" plain :icon="SwitchButton">注销登录</el-button>
        </div>
      </div>
    </header>

    <!-- 主要内容 -->
    <main class="admin-main">
      <div class="admin-container">
        <!-- 统计卡片 -->
        <section class="stats-section">
          <div class="stats-header">
            <h2>数据统计</h2>
            <el-button @click="() => fetchStats(true)" :icon="Refresh" size="small" type="primary" plain :loading="statsLoading">
              刷新数据
            </el-button>
          </div>
          <div class="stats-grid">
            <div class="stat-card">
              <div class="stat-icon total">
                <el-icon><Document /></el-icon>
              </div>
              <div class="stat-content">
                <p class="stat-label">总文章数</p>
                <h3 class="stat-number">{{ stats?.totalBlogs || 0 }}</h3>
              </div>
            </div>
            
            <div class="stat-card">
              <div class="stat-icon views">
                <el-icon><View /></el-icon>
              </div>
              <div class="stat-content">
                <p class="stat-label">总浏览量</p>
                <h3 class="stat-number">{{ stats?.totalViews || 0 }}</h3>
              </div>
            </div>
            
            <div class="stat-card">
              <div class="stat-icon today">
                <el-icon><Calendar /></el-icon>
              </div>
              <div class="stat-content">
                <p class="stat-label">今日发布</p>
                <h3 class="stat-number">{{ stats?.todayPosts || 0 }}</h3>
              </div>
            </div>
            
            <div class="stat-card">
              <div class="stat-icon announcements">
                <el-icon><Bell /></el-icon>
              </div>
              <div class="stat-content">
                <p class="stat-label">总公告数</p>
                <h3 class="stat-number">{{ stats?.totalAnnouncements || 0 }}</h3>
              </div>
            </div>
            
            <div class="stat-card">
              <div class="stat-icon published">
                <el-icon><Check /></el-icon>
              </div>
              <div class="stat-content">
                <p class="stat-label">已发布公告</p>
                <h3 class="stat-number">{{ stats?.publishedAnnouncements || 0 }}</h3>
              </div>
            </div>
            
            <div class="stat-card">
              <div class="stat-icon pinned">
                <el-icon><Top /></el-icon>
              </div>
              <div class="stat-content">
                <p class="stat-label">置顶公告</p>
                <h3 class="stat-number">{{ stats?.pinnedAnnouncements || 0 }}</h3>
              </div>
            </div>

          </div>
        </section>

        <!-- 管理标签页 -->
        <div class="admin-tabs">
          <el-tabs v-model="activeTab" @tab-change="handleTabChange">

            
            <el-tab-pane label="公告管理" name="announcements">
              <!-- 公告管理部分 -->
              <div class="announcement-management">
                <!-- 头部操作区 -->
                <div class="section-header">
                  <div class="header-left">
                    <h2 class="section-title">
                      <el-icon><Bell /></el-icon>
                      公告管理
                    </h2>
                    <div class="stats-summary">
                      <span class="stat-item">总计: {{ announcementTotal }}</span>
                      <span class="stat-item">已发布: {{ announcements.filter(a => a.isPublished).length }}</span>
                      <span class="stat-item">置顶: {{ announcements.filter(a => a.isPinned).length }}</span>
                    </div>
                  </div>
                  <div class="header-actions">
                    <el-button type="primary" @click="showCreateAnnouncementDialog" :icon="Plus" size="default">
                      新建公告
                    </el-button>
                    <el-button @click="fetchAnnouncements" :icon="Refresh" size="default">
                      刷新
                    </el-button>
                  </div>
                </div>

                <!-- 搜索和筛选区 -->
                <div class="search-filters">
                  <div class="filter-row">
                    <div class="search-group">
                      <el-input
                        v-model="announcementSearchKeyword"
                        placeholder="搜索公告标题或内容"
                        :prefix-icon="Search"
                        clearable
                        @keyup.enter="fetchAnnouncements"
                        class="search-input"
                      />
                      <el-button type="primary" @click="fetchAnnouncements" :icon="Search">
                        搜索
                      </el-button>
                    </div>
                    <div class="filter-group">
                      <el-select v-model="announcementStatusFilter" placeholder="状态筛选" @change="fetchAnnouncements" clearable>
                        <el-option label="全部" value="" />
                        <el-option label="已发布" value="published" />
                        <el-option label="草稿" value="draft" />
                        <el-option label="置顶" value="pinned" />
                      </el-select>
                    </div>
                  </div>
                </div>

                <!-- 批量操作区 -->
                <div class="batch-actions" v-if="selectedAnnouncements.length > 0">
                  <div class="batch-info">
                    <span>已选择 {{ selectedAnnouncements.length }} 项</span>
                  </div>
                  <div class="batch-buttons">
                    <el-button size="small" @click="batchPublishAnnouncements" :icon="Check">
                      批量发布
                    </el-button>
                    <el-button size="small" @click="batchUnpublishAnnouncements" :icon="Close">
                      批量取消发布
                    </el-button>
                    <el-button size="small" type="danger" @click="batchDeleteAnnouncements" :icon="Delete">
                      批量删除
                    </el-button>
                  </div>
                </div>

                <!-- 公告表格 -->
                <div class="table-container">
                  <el-table 
                    :data="announcements" 
                    stripe 
                    border 
                    class="announcement-table" 
                    v-loading="announcementLoading"
                    @selection-change="handleAnnouncementSelectionChange"
                    empty-text="暂无公告数据"
                  >
                    <el-table-column type="selection" width="55" />
                    <el-table-column prop="id" label="ID" width="80" sortable />
                    <el-table-column prop="title" label="标题" min-width="250">
                      <template #default="{ row }">
                        <div class="announcement-title-cell">
                          <div class="title-content">
                            <span class="title-text" :title="row.title">{{ row.title }}</span>
                            <div class="title-tags">
                              <el-tag v-if="row.isPinned" type="danger" size="small" effect="dark">
                                <el-icon><Top /></el-icon>
                                置顶
                              </el-tag>
                              <el-tag v-if="row.isPublished" type="success" size="small">
                                已发布
                              </el-tag>
                              <el-tag v-else type="info" size="small">
                                草稿
                              </el-tag>
                            </div>
                          </div>
                        </div>
                      </template>
                    </el-table-column>
                    <el-table-column prop="content" label="内容预览" width="200">
                      <template #default="{ row }">
                        <div class="content-preview" :title="row.content">
                          {{ row.content ? row.content.substring(0, 50) + (row.content.length > 50 ? '...' : '') : '-' }}
                        </div>
                      </template>
                    </el-table-column>
                    <el-table-column prop="authorName" label="发布者" width="120" />
                    <el-table-column prop="createdAt" label="创建时间" width="160" sortable>
                      <template #default="{ row }">
                        <div class="time-cell">
                          <el-icon><Calendar /></el-icon>
                          {{ formatDateTime(row.createdAt) }}
                        </div>
                      </template>
                    </el-table-column>
                    <el-table-column prop="publishedAt" label="发布时间" width="160">
                      <template #default="{ row }">
                        <div class="time-cell" v-if="row.publishedAt">
                          <el-icon><Calendar /></el-icon>
                          {{ formatDateTime(row.publishedAt) }}
                        </div>
                        <span v-else class="not-published">未发布</span>
                      </template>
                    </el-table-column>
                    <el-table-column label="操作" width="280" fixed="right">
                      <template #default="{ row }">
                        <div class="action-buttons">
                          <el-tooltip content="编辑公告" placement="top">
                            <el-button size="small" @click="editAnnouncement(row)" :icon="Edit" circle />
                          </el-tooltip>
                          
                          <el-tooltip :content="row.isPublished ? '取消发布' : '发布公告'" placement="top">
                            <el-button 
                              size="small" 
                              :type="row.isPublished ? 'warning' : 'success'"
                              @click="togglePublishAnnouncement(row)"
                              :icon="row.isPublished ? 'Hide' : 'View'"
                              circle
                            />
                          </el-tooltip>
                          
                          <el-tooltip :content="row.isPinned ? '取消置顶' : '置顶公告'" placement="top" v-if="row.isPublished">
                            <el-button 
                              size="small" 
                              :type="row.isPinned ? 'info' : 'primary'"
                              @click="togglePinAnnouncement(row)"
                              :icon="Top"
                              circle
                            />
                          </el-tooltip>
                          
                          <el-tooltip content="预览公告" placement="top" v-if="row.isPublished">
                            <el-button size="small" @click="previewAnnouncement(row)" :icon="View" circle />
                          </el-tooltip>
                          
                          <el-tooltip content="删除公告" placement="top">
                            <el-button 
                              size="small" 
                              type="danger" 
                              @click="confirmDeleteAnnouncement(row.id)" 
                              :icon="Delete" 
                              circle
                            />
                          </el-tooltip>
                        </div>
                      </template>
                    </el-table-column>
                  </el-table>
                </div>

                <!-- 分页 -->
                <div class="pagination-container">
                  <el-pagination
                    v-model:current-page="announcementCurrentPage"
                    v-model:page-size="announcementPageSize"
                    :page-sizes="[10, 20, 50, 100]"
                    layout="total, sizes, prev, pager, next, jumper"
                    :total="announcementTotal"
                    @size-change="fetchAnnouncements"
                    @current-change="fetchAnnouncements"
                    background
                  />
                </div>
              </div>
            </el-tab-pane>
            
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

    <!-- End of blog dialog -->
    
    <!-- 公告编辑对话框 -->
    <el-dialog
      v-model="announcementDialogVisible"
      :title="announcementForm.id ? '编辑公告' : '新建公告'"
      width="600px"
      :close-on-click-modal="false"
    >
      <el-form
        ref="announcementFormRef"
        :model="announcementForm"
        :rules="announcementRules"
        label-width="80px"
      >
        <el-form-item label="标题" prop="title">
          <el-input
            v-model="announcementForm.title"
            placeholder="请输入公告标题"
            maxlength="200"
            show-word-limit
          />
        </el-form-item>
        
        <el-form-item label="内容" prop="content">
          <el-input
            v-model="announcementForm.content"
            type="textarea"
            placeholder="请输入公告内容"
            :rows="6"
            maxlength="2000"
            show-word-limit
          />
        </el-form-item>
        
        <el-form-item label="设置">
          <div class="announcement-settings">
            <el-checkbox v-model="announcementForm.isPublished">立即发布</el-checkbox>
            <el-checkbox v-model="announcementForm.isPinned" :disabled="!announcementForm.isPublished">置顶显示</el-checkbox>
          </div>
        </el-form-item>
      </el-form>
      
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="announcementDialogVisible = false">取消</el-button>
          <el-button type="primary" @click="saveAnnouncement" :loading="announcementSaving">
            {{ announcementForm.id ? '更新' : '创建' }}
          </el-button>
        </div>
      </template>
    </el-dialog>

  </div>
</template>

<script setup>
import { ref, reactive, onMounted, watch, onBeforeUnmount, nextTick } from 'vue'
import { useRouter } from 'vue-router'
import {
  User, SwitchButton, Document, View, Calendar,
  Plus, Search, Delete, Bell, Edit, Check, Top, Refresh, Close
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

// 文章管理相关数据
const blogs = ref([])
const loading = ref(false)
const searchKeyword = ref('')
const statusFilter = ref('published') // 默认只显示已发布文章
const currentPage = ref(1)
const pageSize = ref(10)
const total = ref(0)

// 公告管理相关数据
const announcements = ref([])
const announcementLoading = ref(false)
const announcementSearchKeyword = ref('')
const announcementStatusFilter = ref('')
const announcementCurrentPage = ref(1)
const announcementPageSize = ref(10)
const announcementTotal = ref(0)
const announcementDialogVisible = ref(false)
const announcementSaving = ref(false)
const announcementFormRef = ref()
const selectedAnnouncements = ref([])
const announcementForm = reactive({
  id: null,
  title: '',
  content: '',
  isPublished: false,
  isPinned: false
})
const announcementRules = {
  title: [
    { required: true, message: '请输入公告标题', trigger: 'blur' },
    { min: 1, max: 200, message: '标题长度在 1 到 200 个字符', trigger: 'blur' }
  ],
  content: [
    { required: true, message: '请输入公告内容', trigger: 'blur' },
    { min: 10, message: '内容至少需要 10 个字符', trigger: 'blur' }
  ]
}

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
    const token = localStorage.getItem('userToken') || localStorage.getItem('adminToken')
    const config = {
      params: {
        page: 0,
        size: 1000, // 获取足够多的数据用于统计
        keyword: '',
        status: ''
      },
      ...(token ? {
        headers: {
          'Authorization': `Bearer ${token}`
        }
      } : {})
    }
    
    const response = await axios.get('/api/admin/blogs', config)
    
    let allBlogs = []
    if (response.data.success) {
      allBlogs = response.data.data.content || []
    } else {
      allBlogs = []
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
      todayPosts,
      totalAnnouncements: 0,
      publishedAnnouncements: 0,
      pinnedAnnouncements: 0
    }
  } catch (error) {
    console.error('计算统计数据失败:', error)
    // 设置默认统计数据
    stats.value = {
      totalBlogs: 0,
      totalViews: 0,
      todayPosts: 0,
      totalAnnouncements: 0,
      publishedAnnouncements: 0,
      pinnedAnnouncements: 0
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
    
    const token = localStorage.getItem('userToken') || localStorage.getItem('adminToken')
    const config = {
      params,
      ...(token ? {
        headers: {
          'Authorization': `Bearer ${token}`
        }
      } : {})
    }
    
    const response = await axios.get('/api/admin/blogs', config)
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
  // 设置标记，表明是从管理员页面跳转的
  sessionStorage.setItem('fromAdmin', 'true')
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
      fetchStats() // 刷新统计数据
    } else {
      ElMessage.success('文章发布成功')
      // 如果没有返回数据，则重新获取列表
      fetchBlogs()
      fetchStats() // 刷新统计数据
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
    const token = localStorage.getItem('userToken') || localStorage.getItem('adminToken')
    const config = token ? {
      headers: {
        'Authorization': `Bearer ${token}`
      }
    } : {}
    
    await axios.delete(`/api/admin/blogs/${id}`, config)
    ElMessage.success('博客删除成功')
    fetchBlogs()
    fetchStats() // 刷新统计数据
  } catch (error) {
    console.error('删除博客失败:', error)
    ElMessage.error('删除博客失败')
  }
}

// 统计数据加载状态
const statsLoading = ref(false)

// 获取统计数据
const fetchStats = async (showMessage = false) => {
  try {
    statsLoading.value = true
    if (showMessage) {
      ElMessage.info('正在刷新统计数据...')
    }
    
    const response = await axios.get('/api/admin/stats')
    if (response.data.success) {
      const data = response.data.data
      stats.value = {
        totalBlogs: data.totalBlogs || 0,
        totalViews: data.totalViews || 0,
        todayPosts: data.todayPosts || 0,
        totalAnnouncements: data.totalAnnouncements || 0,
        publishedAnnouncements: data.publishedAnnouncements || 0,
        pinnedAnnouncements: data.pinnedAnnouncements || 0
      }
      
      if (showMessage) {
        ElMessage.success('统计数据已更新')
      }
    }
  } catch (error) {
    console.error('获取统计数据失败:', error)
    if (showMessage) {
      ElMessage.error('获取统计数据失败')
    }
    // 如果API失败，使用计算方式
    await calculateStatsFromBlogs()
  } finally {
    statsLoading.value = false
  }
}

// 公告管理相关方法
// 获取公告列表
const fetchAnnouncements = async () => {
  announcementLoading.value = true
  try {
    const token = localStorage.getItem('userToken') || localStorage.getItem('adminToken')
    const config = token ? {
      headers: {
        'Authorization': `Bearer ${token}`
      }
    } : {}
    
    const params = {
      page: announcementCurrentPage.value - 1,
      size: announcementPageSize.value
    }
    
    if (announcementSearchKeyword.value) {
      params.keyword = announcementSearchKeyword.value
    }
    
    // 添加状态筛选
    if (announcementStatusFilter.value) {
      switch (announcementStatusFilter.value) {
        case 'published':
          params.isPublished = true
          break
        case 'draft':
          params.isPublished = false
          break
        case 'pinned':
          params.isPinned = true
          break
      }
    }
    
    const response = await axios.get('/api/admin/announcements', { ...config, params })
    
    if (response.data.success) {
      announcements.value = response.data.data.content || []
      announcementTotal.value = response.data.data.totalElements || 0
    } else {
      ElMessage.error('获取公告列表失败')
    }
  } catch (error) {
    console.error('获取公告列表失败:', error)
    ElMessage.error('获取公告列表失败')
  } finally {
    announcementLoading.value = false
  }
}

// 显示创建公告对话框
const showCreateAnnouncementDialog = () => {
  Object.assign(announcementForm, {
    id: null,
    title: '',
    content: '',
    isPublished: false,
    isPinned: false
  })
  announcementDialogVisible.value = true
}

// 编辑公告
const editAnnouncement = (announcement) => {
  Object.assign(announcementForm, {
    id: announcement.id,
    title: announcement.title,
    content: announcement.content,
    isPublished: announcement.isPublished,
    isPinned: announcement.isPinned
  })
  announcementDialogVisible.value = true
}

// 保存公告
const saveAnnouncement = async () => {
  if (!announcementFormRef.value) return
  
  try {
    await announcementFormRef.value.validate()
  } catch (error) {
    return
  }
  
  announcementSaving.value = true
  
  try {
    const token = localStorage.getItem('userToken') || localStorage.getItem('adminToken')
    const config = token ? {
      headers: {
        'Authorization': `Bearer ${token}`
      }
    } : {}
    
    const announcementData = {
      title: announcementForm.title,
      content: announcementForm.content,
      isPublished: announcementForm.isPublished,
      isPinned: announcementForm.isPinned
    }
    
    let response
    if (announcementForm.id) {
      // 更新公告
      response = await axios.put(`/api/admin/announcements/${announcementForm.id}`, announcementData, config)
    } else {
      // 创建公告
      response = await axios.post('/api/admin/announcements', announcementData, config)
    }
    
    if (response.data.success) {
      ElMessage.success(announcementForm.id ? '公告更新成功' : '公告创建成功')
      fetchAnnouncements()
      announcementDialogVisible.value = false
    } else {
      ElMessage.error(announcementForm.id ? '公告更新失败' : '公告创建失败')
    }
  } catch (error) {
    console.error('保存公告失败:', error)
    ElMessage.error('保存公告失败')
  } finally {
    announcementSaving.value = false
  }
}

// 切换公告发布状态
const togglePublishAnnouncement = async (announcement) => {
  try {
    const token = localStorage.getItem('userToken') || localStorage.getItem('adminToken')
    const config = token ? {
      headers: {
        'Authorization': `Bearer ${token}`
      }
    } : {}
    
    const newStatus = !announcement.isPublished
    await axios.put(`/api/admin/announcements/${announcement.id}/publish`, 
      { isPublished: newStatus }, config)
    
    announcement.isPublished = newStatus
    if (!newStatus) {
      announcement.isPinned = false // 取消发布时同时取消置顶
    }
    
    ElMessage.success(newStatus ? '公告已发布' : '公告已取消发布')
  } catch (error) {
    console.error('切换发布状态失败:', error)
    ElMessage.error('操作失败')
  }
}

// 切换公告置顶状态
const togglePinAnnouncement = async (announcement) => {
  try {
    const token = localStorage.getItem('userToken') || localStorage.getItem('adminToken')
    const config = token ? {
      headers: {
        'Authorization': `Bearer ${token}`
      }
    } : {}
    
    const newPinStatus = !announcement.isPinned
    await axios.put(`/api/admin/announcements/${announcement.id}/pin`, 
      { isPinned: newPinStatus }, config)
    
    announcement.isPinned = newPinStatus
    ElMessage.success(newPinStatus ? '公告已置顶' : '公告已取消置顶')
  } catch (error) {
    console.error('切换置顶状态失败:', error)
    ElMessage.error('操作失败')
  }
}

// 确认删除公告
const confirmDeleteAnnouncement = (id) => {
  ElMessageBox.confirm(
    '确定要删除这条公告吗？此操作不可逆。',
    '删除确认',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning',
    }
  )
    .then(() => {
      deleteAnnouncement(id)
    })
    .catch(() => {
      // 用户取消删除
    })
}

// 删除公告
const deleteAnnouncement = async (id) => {
  try {
    const token = localStorage.getItem('userToken') || localStorage.getItem('adminToken')
    const config = token ? {
      headers: {
        'Authorization': `Bearer ${token}`
      }
    } : {}
    
    await axios.delete(`/api/admin/announcements/${id}`, config)
    ElMessage.success('公告删除成功')
    fetchAnnouncements()
  } catch (error) {
    console.error('删除公告失败:', error)
    ElMessage.error('删除公告失败')
  }
}

// 处理公告选择变化
const handleAnnouncementSelectionChange = (selection) => {
  selectedAnnouncements.value = selection
}

// 批量发布公告
const batchPublishAnnouncements = async () => {
  if (selectedAnnouncements.value.length === 0) {
    ElMessage.warning('请先选择要发布的公告')
    return
  }
  
  try {
    await ElMessageBox.confirm(
      `确定要发布选中的 ${selectedAnnouncements.value.length} 条公告吗？`,
      '批量发布确认',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'info'
      }
    )
    
    const token = localStorage.getItem('userToken') || localStorage.getItem('adminToken')
    const config = token ? {
      headers: {
        'Authorization': `Bearer ${token}`
      }
    } : {}
    
    const promises = selectedAnnouncements.value
      .filter(announcement => !announcement.isPublished)
      .map(announcement => 
        axios.put(`/api/admin/announcements/${announcement.id}/publish`, 
          { isPublished: true }, config)
      )
    
    await Promise.all(promises)
    ElMessage.success('批量发布成功')
    fetchAnnouncements()
    selectedAnnouncements.value = []
  } catch (error) {
    if (error !== 'cancel') {
      console.error('批量发布失败:', error)
      ElMessage.error('批量发布失败')
    }
  }
}

// 批量取消发布公告
const batchUnpublishAnnouncements = async () => {
  if (selectedAnnouncements.value.length === 0) {
    ElMessage.warning('请先选择要取消发布的公告')
    return
  }
  
  try {
    await ElMessageBox.confirm(
      `确定要取消发布选中的 ${selectedAnnouncements.value.length} 条公告吗？`,
      '批量取消发布确认',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }
    )
    
    const token = localStorage.getItem('userToken') || localStorage.getItem('adminToken')
    const config = token ? {
      headers: {
        'Authorization': `Bearer ${token}`
      }
    } : {}
    
    const promises = selectedAnnouncements.value
      .filter(announcement => announcement.isPublished)
      .map(announcement => 
        axios.put(`/api/admin/announcements/${announcement.id}/publish`, 
          { isPublished: false }, config)
      )
    
    await Promise.all(promises)
    ElMessage.success('批量取消发布成功')
    fetchAnnouncements()
    selectedAnnouncements.value = []
  } catch (error) {
    if (error !== 'cancel') {
      console.error('批量取消发布失败:', error)
      ElMessage.error('批量取消发布失败')
    }
  }
}

// 批量删除公告
const batchDeleteAnnouncements = async () => {
  if (selectedAnnouncements.value.length === 0) {
    ElMessage.warning('请先选择要删除的公告')
    return
  }
  
  try {
    await ElMessageBox.confirm(
      `确定要删除选中的 ${selectedAnnouncements.value.length} 条公告吗？此操作不可逆。`,
      '批量删除确认',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'error'
      }
    )
    
    const token = localStorage.getItem('userToken') || localStorage.getItem('adminToken')
    const config = token ? {
      headers: {
        'Authorization': `Bearer ${token}`
      }
    } : {}
    
    const promises = selectedAnnouncements.value.map(announcement => 
      axios.delete(`/api/admin/announcements/${announcement.id}`, config)
    )
    
    await Promise.all(promises)
    ElMessage.success('批量删除成功')
    fetchAnnouncements()
    selectedAnnouncements.value = []
  } catch (error) {
    if (error !== 'cancel') {
      console.error('批量删除失败:', error)
      ElMessage.error('批量删除失败')
    }
  }
}

// 预览公告
const previewAnnouncement = (announcement) => {
  ElMessageBox.alert(
    announcement.content || '暂无内容',
    announcement.title,
    {
      confirmButtonText: '关闭',
      customClass: 'announcement-preview-dialog',
      dangerouslyUseHTMLString: false
    }
  )
}

// 格式化日期时间
const formatDateTime = (dateTime) => {
  if (!dateTime) return ''
  const date = new Date(dateTime)
  return date.toLocaleString('zh-CN', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit'
  })
}



// 定时器引用
const statsTimer = ref(null)

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
  fetchAnnouncements()
  
  // 设置定时器，每30秒自动刷新统计数据
  statsTimer.value = setInterval(() => {
    fetchStats()
  }, 30000) // 30秒
  
  // 根据路由元信息设置当前标签页
  const { tab } = router.currentRoute.value.meta
  if (tab) {
    activeTab.value = tab
  }
})

// 组件卸载前清理
onBeforeUnmount(() => {
  isUnmounting.value = true
  // 清理定时器
  if (statsTimer.value) {
    clearInterval(statsTimer.value)
    statsTimer.value = null
  }
})

// 监听标签页变化，更新路由
const handleTabChange = (tab) => {
  if (tab === 'blogs') {
    router.push({ name: 'AdminBlogs' })
  } else if (tab === 'announcements') {
    // 公告管理标签页，不需要路由跳转
    fetchAnnouncements()
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

// 组件卸载标志
const isUnmounting = ref(false)

// 格式化日期
const formatDate = (date) => {
  if (!date) return ''
  const d = new Date(date)
  return d.toLocaleDateString('zh-CN')
}

// 返回首页
const goToHomepage = () => {
  console.log('返回首页按钮被点击')
  // 直接使用 window.location.href 进行页面跳转，避免 Vue Router 的复杂性
  window.location.href = '/'
}

// 注销登录
const handleLogout = async () => {
  try {
    await ElMessageBox.confirm('确定要注销登录吗？', '确认注销', {
      type: 'warning',
      confirmButtonText: '确定',
      cancelButtonText: '取消'
    })
    
    // 清除本地存储的登录信息
    localStorage.removeItem('adminToken')
    localStorage.removeItem('userToken')
    localStorage.removeItem('userRole')
    localStorage.removeItem('username')
    
    ElMessage.success('注销成功')
    
    // 跳转到登录页面
    router.push('/login')
  } catch (error) {
    // 用户取消注销
    if (error !== 'cancel') {
      console.error('注销失败:', error)
    }
  }
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

.stats-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1rem;
  padding: 0 0.5rem;
}

.stats-header h2 {
  margin: 0;
  color: #303133;
  font-size: 1.25rem;
  font-weight: 600;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
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

.stat-icon.announcements {
  background-color: rgba(245, 108, 108, 0.1);
  color: #F56C6C;
}

.stat-icon.published {
  background-color: rgba(103, 194, 58, 0.1);
  color: #67C23A;
}

.stat-icon.pinned {
  background-color: rgba(230, 162, 60, 0.1);
  color: #E6A23C;
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

/* 公告管理样式 */
.announcement-management {
  padding: 1rem;
  background: #f8f9fa;
  border-radius: 8px;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 1.5rem;
  padding: 1rem;
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.header-left {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.section-title {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin: 0;
  font-size: 1.5rem;
  color: #2c3e50;
}

.stats-summary {
  display: flex;
  gap: 1rem;
  font-size: 0.9rem;
  color: #666;
}

.stat-item {
  padding: 0.25rem 0.5rem;
  background: #f0f2f5;
  border-radius: 4px;
}

.header-actions {
  display: flex;
  gap: 0.5rem;
}

.search-filters {
  margin-bottom: 1rem;
  padding: 1rem;
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.filter-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 1rem;
}

.search-group {
  display: flex;
  gap: 0.5rem;
  flex: 1;
}

.search-input {
  flex: 1;
  max-width: 400px;
}

.filter-group {
  display: flex;
  gap: 0.5rem;
}

.batch-actions {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1rem;
  padding: 0.75rem 1rem;
  background: #e3f2fd;
  border: 1px solid #2196f3;
  border-radius: 6px;
}

.batch-info {
  color: #1976d2;
  font-weight: 500;
}

.batch-buttons {
  display: flex;
  gap: 0.5rem;
}

.table-container {
  background: white;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.announcement-table {
  margin: 0;
}

.announcement-title-cell {
  padding: 0.5rem 0;
}

.title-content {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.title-text {
  font-weight: 500;
  color: #2c3e50;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.title-tags {
  display: flex;
  gap: 0.25rem;
  flex-wrap: wrap;
}

.content-preview {
  color: #666;
  font-size: 0.9rem;
  line-height: 1.4;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.time-cell {
  display: flex;
  align-items: center;
  gap: 0.25rem;
  font-size: 0.9rem;
  color: #666;
}

.not-published {
  color: #999;
  font-style: italic;
}

.action-buttons {
  display: flex;
  gap: 0.25rem;
  justify-content: center;
  flex-wrap: wrap;
}

.pagination-container {
  margin-top: 1rem;
  padding: 1rem;
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  display: flex;
  justify-content: center;
}

.announcement-settings {
  display: flex;
  gap: 1rem;
  align-items: center;
}

/* 预览对话框样式 */
.announcement-preview-dialog {
  max-width: 600px;
}

.announcement-preview-dialog .el-message-box__content {
  max-height: 400px;
  overflow-y: auto;
  white-space: pre-wrap;
  word-break: break-word;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .filter-row {
    flex-direction: column;
    align-items: stretch;
  }
  
  .search-group {
    flex-direction: column;
  }
  
  .batch-actions {
    flex-direction: column;
    gap: 0.5rem;
  }
  
  .action-buttons {
    flex-direction: column;
  }
  
  .stats-summary {
    flex-direction: column;
    gap: 0.5rem;
  }
}

.announcement-settings .el-checkbox {
  margin-right: 0;
}

.action-buttons {
  display: flex;
  gap: 0.5rem;
  flex-wrap: wrap;
}

.action-buttons .el-button {
  margin: 0;
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