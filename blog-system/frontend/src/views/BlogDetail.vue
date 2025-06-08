<template>
  <div class="blog-detail">
    <!-- 头部导航 -->
    <header class="header">
      <div class="container">
        <div class="header-content">
          <h1 class="logo" @click="goHome">文章详情</h1>
          <nav class="nav">
            <router-link to="/" class="nav-link">首页</router-link>
            <router-link to="/announcements" class="nav-link">公告</router-link>
            <router-link to="/dashboard" class="nav-link">个人中心</router-link>
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
              <span class="meta-item author-item">
                <el-avatar 
                  :size="32" 
                  :src="blog.authorAvatar" 
                  :icon="User"
                  class="author-avatar"
                />
                <span class="author-name">{{ blog.authorName || blog.author }}</span>
              </span>
              <span class="meta-item">
                <el-icon><Calendar /></el-icon>
                {{ formatDate(blog.publishedAt || blog.createdAt) }}
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
            <!-- 标签显示 -->
            <div class="article-tags" v-if="blog.tags && getTagsArray(blog.tags).length > 0">
              <el-tag
                v-for="tag in getTagsArray(blog.tags)"
                :key="tag"
                size="small"
                class="tag"
              >
                {{ tag.trim() }}
              </el-tag>
            </div>
          </header>

          <div class="article-content" v-html="formattedContent"></div>

          <!-- 分享和操作 -->
          <footer class="article-footer">
            <div class="article-actions">
              <el-button 
                @click="toggleLike" 
                :icon="Star" 
                :loading="liking"
                :type="hasLiked ? 'danger' : 'primary'"
                :disabled="!checkLoginStatus()"
              >
                {{ hasLiked ? '取消点赞' : (checkLoginStatus() ? '点赞' : '登录后点赞') }} ({{ blog.likeCount || 0 }})
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
              @click.stop="goToBlogDetail(relatedBlog.id)"
              role="button"
              tabindex="0"
              @keyup.enter="goToBlogDetail(relatedBlog.id)"
            >
              <h3 class="related-title">{{ relatedBlog.title }}</h3>
              <p class="related-summary">{{ relatedBlog.summary || relatedBlog.content.substring(0, 100) + '...' }}</p>
              <div class="related-meta">
                <span>{{ formatDate(relatedBlog.publishedAt || relatedBlog.createdAt) }}</span>
              </div>
            </div>
          </div>
        </section>

        <!-- 评论区域 -->
        <section v-if="blog" class="comment-section">
          <CommentSection :blog-id="blog.id" :blog-author-id="blog.userId" />
        </section>
      </div>
    </main>
    
    <!-- 图片预览对话框 -->
    <el-dialog
      v-model="imagePreviewVisible"
      title="图片预览"
      width="80%"
      :show-close="true"
      center
    >
      <div class="image-preview-container">
        <img 
          :src="currentPreviewImage" 
          alt="预览图片" 
          class="preview-image"
        />
      </div>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted, computed, watch, nextTick } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { ArrowLeft, User, Calendar, View, Share, Star, TrendCharts } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import axios from 'axios'
import CommentSection from '@/components/CommentSection.vue'

const router = useRouter()
const route = useRoute()

// 响应式数据
const blog = ref(null)
const relatedBlogs = ref([])
const loading = ref(false)
const error = ref('')
const liking = ref(false)
const hasLiked = ref(false)

// 图片预览相关
const imagePreviewVisible = ref(false)
const currentPreviewImage = ref('')

// 计算属性
const formattedContent = computed(() => {
  if (!blog.value?.content) return ''
  
  // 简单的内容格式化，将换行转换为段落
  let content = blog.value.content
    .split('\n')
    .filter(line => line.trim())
    .map(line => `<p>${line}</p>`)
    .join('')
  
  // 如果有图片，在内容后面添加图片
  if (blog.value.images) {
    try {
      const images = typeof blog.value.images === 'string' 
        ? JSON.parse(blog.value.images) 
        : blog.value.images
      
      if (Array.isArray(images) && images.length > 0) {
        const imageHtml = images.map((imageUrl, index) => 
          `<div class="article-image" data-image-url="${imageUrl}" data-image-index="${index}"><img src="${imageUrl}" alt="文章图片" class="preview-thumbnail" style="cursor: pointer;"/></div>`
        ).join('')
        content += imageHtml
      }
    } catch (error) {
      console.error('解析图片数据失败:', error)
    }
  }
  
  return content
})

// 处理图片点击事件
const handleImageClick = (imageUrl) => {
  currentPreviewImage.value = imageUrl
  imagePreviewVisible.value = true
}

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
      // 处理作者头像路径
      if (blog.value.authorAvatar && !blog.value.authorAvatar.startsWith('http')) {
        blog.value.authorAvatar = `http://localhost:8080${blog.value.authorAvatar}`
      }
      // 检查点赞状态
      checkLikeStatus()
      // 获取相关文章
      fetchRelatedBlogs()
    } else {
      error.value = '博客不存在或已被删除'
    }
  } catch (err) {
    console.error('获取博客详情失败:', err)
    error.value = '获取博客详情失败，请稍后重试'
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
    relatedBlogs.value = []
  }
}



// 导航方法
const goHome = () => {
  router.push('/')
}

const goBack = () => {
  // 检查是否从管理员页面来的
  const referrer = document.referrer
  const fromAdmin = referrer.includes('/admin') || 
                   sessionStorage.getItem('fromAdmin') === 'true'
  
  if (fromAdmin) {
    // 如果是从管理员页面来的，返回到管理员页面
    router.push('/admin')
    // 清除标记
    sessionStorage.removeItem('fromAdmin')
  } else {
    // 否则返回上一页
    router.go(-1)
  }
}

const goToBlogDetail = (id) => {
  console.log('点击相关文章，ID:', id)
  // 如果当前是从管理员页面来的，保持这个标记
  const fromAdmin = sessionStorage.getItem('fromAdmin') === 'true'
  if (fromAdmin) {
    sessionStorage.setItem('fromAdmin', 'true')
  }
  
  // 如果跳转到当前页面，强制重新加载
  if (route.params.id === id.toString()) {
    console.log('跳转到当前页面，强制重新加载')
    window.location.reload()
    return
  }
  
  // 跳转到不同页面，watch会自动处理数据重新加载
  router.push(`/blog/${id}`).then(() => {
    console.log('路由跳转成功')
  }).catch(err => {
    console.error('路由跳转失败:', err)
  })
}

// 检查登录状态
const checkLoginStatus = () => {
  const userToken = localStorage.getItem('userToken')
  const adminToken = localStorage.getItem('adminToken')
  const token = userToken || adminToken
  
  if (!token) {
    return false
  }
  
  // 检查token格式和有效性
  if (token.startsWith('token_')) {
    // 真实token格式: token_userId_timestamp
    const parts = token.split('_')
    if (parts.length >= 3) {
      const timestamp = parseInt(parts[2])
      const currentTime = Date.now()
      // 检查token是否过期（假设token有效期为24小时）
      const tokenExpiry = 24 * 60 * 60 * 1000 // 24小时
      if (currentTime - timestamp > tokenExpiry) {
        // token已过期，清理localStorage
        localStorage.removeItem('userToken')
        localStorage.removeItem('adminToken')
        return false
      }
      return true
    }
  }
  
  // 对于其他格式的token，暂时认为有效
  // 在实际使用时会通过API调用验证
  return true
}

// 切换点赞状态
const toggleLike = async () => {
  if (!blog.value || liking.value) return
  
  // 检查登录状态
  if (!checkLoginStatus()) {
    ElMessage.warning('请先登录后再操作')
    router.push('/login')
    return
  }
  
  // 再次验证token有效性
  const token = localStorage.getItem('userToken') || localStorage.getItem('adminToken')
  if (token && token.startsWith('token_')) {
    const parts = token.split('_')
    if (parts.length >= 3) {
      const timestamp = parseInt(parts[2])
      const currentTime = Date.now()
      const tokenExpiry = 24 * 60 * 60 * 1000 // 24小时
      if (currentTime - timestamp > tokenExpiry) {
        ElMessage.error('登录已过期，请重新登录')
        localStorage.removeItem('userToken')
        localStorage.removeItem('adminToken')
        router.push('/login')
        return
      }
    }
  }
  
  liking.value = true
  try {
    // 获取用户token
    const token = localStorage.getItem('userToken') || localStorage.getItem('adminToken')
    if (!token) {
      ElMessage.error('请先登录')
      return
    }
    
    const config = {
      headers: {
        'Authorization': `Bearer ${token}`
      }
    }
    
    let response
    if (hasLiked.value) {
      // 取消点赞
      response = await axios.delete(`/api/blogs/${blog.value.id}/like`, config)
      if (response.data) {
        blog.value.likeCount = response.data.likeCount
        hasLiked.value = false
        // 从本地存储中移除点赞状态
        const likedBlogs = JSON.parse(localStorage.getItem('likedBlogs') || '[]')
        const index = likedBlogs.indexOf(blog.value.id)
        if (index > -1) {
          likedBlogs.splice(index, 1)
          localStorage.setItem('likedBlogs', JSON.stringify(likedBlogs))
        }
        ElMessage.success('取消点赞成功！')
      }
    } else {
      // 点赞
      response = await axios.post(`/api/blogs/${blog.value.id}/like`, {}, config)
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
    }
  } catch (error) {
    console.error('操作失败:', error)
    ElMessage.error('操作失败，请稍后重试')
  } finally {
    liking.value = false
  }
}

// 检查是否已点赞
const checkLikeStatus = async () => {
  if (!blog.value) return
  
  // 首先检查localStorage（兼容旧数据）
  const likedBlogs = JSON.parse(localStorage.getItem('likedBlogs') || '[]')
  const localLiked = likedBlogs.includes(blog.value.id)
  
  // 如果用户已登录，从后端获取真实的点赞状态
  const token = localStorage.getItem('userToken') || localStorage.getItem('adminToken')
  if (token) {
    try {
      const config = {
        headers: {
          'Authorization': `Bearer ${token}`
        }
      }
      const response = await axios.get(`/api/blogs/${blog.value.id}/like-status`, config)
      hasLiked.value = response.data.liked
      
      // 同步localStorage状态
      if (response.data.liked && !localLiked) {
        likedBlogs.push(blog.value.id)
        localStorage.setItem('likedBlogs', JSON.stringify(likedBlogs))
      } else if (!response.data.liked && localLiked) {
        const index = likedBlogs.indexOf(blog.value.id)
        if (index > -1) {
          likedBlogs.splice(index, 1)
          localStorage.setItem('likedBlogs', JSON.stringify(likedBlogs))
        }
      }
    } catch (error) {
      // 如果后端接口不存在或出错，使用localStorage状态
      hasLiked.value = localLiked
    }
  } else {
    // 未登录用户使用localStorage状态
    hasLiked.value = localLiked
  }
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

// 监听路由参数变化
watch(
  () => route.params.id,
  (newId, oldId) => {
    if (newId && newId !== oldId) {
      console.log('路由参数变化，重新获取数据:', newId)
      fetchBlog()
    }
  },
  { immediate: true }
)

// 组件挂载时获取数据
// 添加图片点击事件监听器的函数
const addImageClickListeners = () => {
  nextTick(() => {
    const articleImages = document.querySelectorAll('.article-content .preview-thumbnail')
    console.log('找到图片数量:', articleImages.length)
    articleImages.forEach(img => {
      img.addEventListener('click', (e) => {
        console.log('图片被点击:', e.target.src)
        const imageUrl = e.target.src
        handleImageClick(imageUrl)
      })
    })
  })
}

// 监听blog数据变化，在数据加载完成后添加事件监听器
watch(blog, (newBlog) => {
  if (newBlog && newBlog.images) {
    addImageClickListeners()
  }
}, { immediate: true })

// 获取标签数组
const getTagsArray = (tags) => {
  if (!tags) return []
  
  try {
    // 如果是JSON字符串格式，先解析
    if (typeof tags === 'string') {
      // 检查是否是JSON数组格式
      if (tags.startsWith('[') && tags.endsWith(']')) {
        const parsed = JSON.parse(tags)
        return Array.isArray(parsed) ? parsed.filter(tag => tag && tag.trim()) : []
      }
      // 否则按逗号分割
      return tags.split(',').map(tag => tag.trim()).filter(tag => tag)
    }
    
    // 如果已经是数组
    if (Array.isArray(tags)) {
      return tags.filter(tag => tag && tag.trim())
    }
  } catch (error) {
    console.error('解析标签数据失败:', error)
  }
  
  return []
}

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

.author-item {
  gap: 0.75rem;
}

.author-avatar {
  flex-shrink: 0;
}

.author-name {
  font-weight: 500;
  color: #333;
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
  position: relative;
  z-index: 1;
  outline: none;
}

.related-card:hover, .related-card:focus {
  border-color: #409eff;
  box-shadow: 0 2px 8px rgba(64, 158, 255, 0.2);
  transform: translateY(-2px);
}

.related-card:active {
  transform: translateY(0);
  border-color: #3a8ee6;
  box-shadow: 0 1px 4px rgba(64, 158, 255, 0.3);
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

.comment-section {
  margin-top: 3rem;
  padding-top: 2rem;
  border-top: 1px solid #e0e0e0;
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
    gap: 0.5rem;
  }
  
  .related-grid {
    grid-template-columns: 1fr;
  }
}

/* 图片预览样式 */
.image-preview-container {
  display: flex;
  justify-content: center;
  align-items: center;
  max-height: 80vh;
}

.preview-image {
  max-width: 100%;
  max-height: 80vh;
  object-fit: contain;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

/* 标签样式 */
.article-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
  margin-top: 1rem;
}

.tag {
  background: linear-gradient(45deg, #409eff, #67c23a) !important;
  border: none !important;
  color: white !important;
  border-radius: 16px !important;
  padding: 0.25rem 0.75rem !important;
  font-size: 0.8rem !important;
  font-weight: 500 !important;
  transition: all 0.3s ease !important;
}

.tag:hover {
  transform: translateY(-1px) !important;
  box-shadow: 0 2px 8px rgba(64, 158, 255, 0.3) !important;
}

/* 文章内容中的图片样式优化 */
.article-content :deep(.article-image) {
  text-align: center;
  margin: 20px 0;
}

.article-content :deep(.article-image img) {
  max-width: 30%;
  height: auto;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  cursor: pointer;
  transition: all 0.3s ease;
}

/* 预览缩略图样式 */
.article-content :deep(.preview-thumbnail) {
  max-width: 300px;
  max-height: 200px;
  width: auto;
  height: auto;
  object-fit: cover;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  cursor: pointer;
  transition: all 0.3s ease;
  margin: 10px 0;
}

.article-content :deep(.article-image img:hover) {
  transform: scale(1.02);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}
</style>