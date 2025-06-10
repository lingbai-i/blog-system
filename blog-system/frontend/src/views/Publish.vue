<template>
  <div class="publish-page">
    <!-- 顶部导航 -->
    <header class="publish-header">
      <div class="header-content">
        <div class="header-left">
          <el-button @click="goBack" :icon="ArrowLeft" circle size="large" />
          <h1>{{ isEditMode ? '编辑文章' : '发布文章' }}</h1>
        </div>
        <div class="header-right">
          <el-button @click="saveDraft" :loading="draftLoading">保存草稿</el-button>
          <el-button type="primary" @click="publishBlog" :loading="publishLoading">
            {{ isEditMode ? '更新文章' : '发布文章' }}
          </el-button>
        </div>
      </div>
    </header>

    <!-- 主要内容 -->
    <main class="publish-main">
      <div class="publish-container">
        <!-- 左侧编辑区 -->
        <div class="editor-section">
          <!-- 标题输入 -->
          <div class="title-section">
            <el-input
              v-model="blogForm.title"
              placeholder="请输入文章标题（5-100个字）"
              size="large"
              maxlength="100"
              show-word-limit
              class="title-input"
            />
          </div>

          <!-- 创作灵感提示 -->
          <div class="inspiration-section">
            <h3>💡 创作灵感</h3>
            <div class="inspiration-tags">
              <el-tag
                v-for="tip in inspirationTips"
                :key="tip"
                @click="addInspiration(tip)"
                class="inspiration-tag"
              >
                {{ tip }}
              </el-tag>
            </div>
          </div>

          <!-- 内容编辑器 -->
          <div class="content-section">
            <RichTextEditor
              v-model="blogForm.content"
              placeholder="✨ 开始创作您的精彩文章吧！\n\n📝 编辑技巧：\n• 使用顶部工具栏设置文字样式（粗体、斜体、颜色等）\n• 📷 点击图片图标上传并插入图片，让文章更生动\n• 📋 使用列表功能整理要点，让内容更清晰\n• 🔗 添加链接丰富文章内容\n• 💻 插入代码块分享技术经验\n• 📊 使用标题功能构建文章结构\n\n💡 小贴士：保持段落简洁，适当使用空行提升阅读体验"
              height="500px"
              @image-uploaded="handleContentImageSuccess"
              ref="richTextEditor"
            />
          </div>
        </div>

        <!-- 右侧设置区 -->
        <div class="settings-section">
          <!-- 图片管理 -->
          <div class="setting-card">
            <h3>🖼️ 图片管理</h3>
            <div v-if="blogForm.images.length === 0" class="no-images">
              <p>暂无上传的图片</p>
              <p class="upload-hint">在编辑器中点击图片按钮上传图片</p>
            </div>
            <div v-else class="image-list">
              <div 
                v-for="(image, index) in blogForm.images" 
                :key="index" 
                class="image-item"
                :class="{ 'is-cover': image === coverImageUrl }"
              >
                <img :src="image" class="thumbnail" />
                <div class="image-actions">
                  <el-button 
                    v-if="image !== coverImageUrl"
                    size="small" 
                    type="success" 
                    plain
                    @click="setCoverImage(image)"
                  >
                    设为封面
                  </el-button>
                  <el-button 
                    v-else
                    size="small" 
                    type="success"
                    disabled
                  >
                    当前封面
                  </el-button>
                  <el-button 
                    size="small" 
                    type="primary" 
                    plain
                    @click="copyImageUrl(image)"
                  >
                    复制链接
                  </el-button>
                  <el-button 
                    size="small" 
                    type="danger" 
                    plain
                    @click="deleteImage(image, index)"
                  >
                    删除
                  </el-button>
                </div>
                <div v-if="image === coverImageUrl" class="cover-badge">
                  📷 封面
                </div>
              </div>
            </div>
          </div>

          <!-- 文章摘要 -->
          <div class="setting-card">
            <h3>📝 文章摘要</h3>
            <el-input
              v-model="blogForm.summary"
              type="textarea"
              placeholder="请输入文章摘要（可选）"
              :rows="3"
              maxlength="200"
              show-word-limit
            />
          </div>

          <!-- 分类选择 -->
          <div class="setting-card">
            <h3>📂 选择分类</h3>
            <el-select
              v-model="blogForm.category"
              placeholder="请选择分类"
              style="width: 100%"
            >
              <el-option
                v-for="category in categories"
                :key="category.id"
                :label="category.name"
                :value="category.name"
              />
            </el-select>
          </div>

          <!-- 标签选择 -->
          <div class="setting-card">
            <h3>🏷️ 添加标签</h3>
            <el-select
              v-model="blogForm.tags"
              multiple
              filterable
              allow-create
              placeholder="选择或创建标签"
              style="width: 100%"
            >
              <el-option
                v-for="tag in tags"
                :key="tag.id"
                :label="tag.name"
                :value="tag.name"
              />
            </el-select>
          </div>

          <!-- 发布设置 -->
          <div class="setting-card">
            <h3>⚙️ 发布设置</h3>
            <div class="publish-options">
              <el-radio-group v-model="publishType" class="publish-type">
                <el-radio label="public">全部可见</el-radio>
                <el-radio label="private">仅自己可见</el-radio>
              </el-radio-group>
            </div>
          </div>

          <!-- 预览按钮 -->
          <div class="setting-card">
            <el-button @click="previewBlog" style="width: 100%" size="large">
              👀 预览文章
            </el-button>
          </div>
        </div>
      </div>
    </main>

    <!-- 预览对话框 -->
    <el-dialog
      v-model="previewVisible"
      title="文章预览"
      width="80%"
      class="preview-dialog"
    >
      <div class="preview-content">
        <h1 class="preview-title">{{ blogForm.title || '未设置标题' }}</h1>
        <div class="preview-meta">
          <span>分类：{{ blogForm.category || '未分类' }}</span>
          <span v-if="blogForm.tags.length">标签：{{ blogForm.tags.join(', ') }}</span>
        </div>
        <div class="preview-summary" v-if="blogForm.summary">
          <strong>摘要：</strong>{{ blogForm.summary }}
        </div>
        <div class="preview-body" v-html="blogForm.content || '暂无内容'"></div>
      </div>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { ArrowLeft, Plus } from '@element-plus/icons-vue'
import axios from 'axios'
import RichTextEditor from '../components/RichTextEditor.vue'

const router = useRouter()

// 响应式数据
const blogForm = ref({
  title: '',
  content: '',
  summary: '',
  category: '',
  tags: [],
  images: []
})

// 编辑模式相关
const isEditMode = ref(false)
const editingBlogId = ref(null)

const coverImageUrl = ref('')
const publishType = ref('public')
const previewVisible = ref(false)
const draftLoading = ref(false)
const publishLoading = ref(false)
const richTextEditor = ref(null)

// 上传请求头
const uploadHeaders = ref({
  'Authorization': `Bearer ${localStorage.getItem('userToken') || localStorage.getItem('adminToken')}`
})

// 分类和标签数据
const categories = ref([])
const tags = ref([])

// 创作灵感提示
const inspirationTips = ref([
  '记录工作实践、项目复盘',
  '写技术笔记和问题解决',
  '发表观点和心得',
  '整合日常碎片化学习内容',
  '分享开发经验和技巧',
  '总结学习心得和感悟'
])

// 返回上一页
const goBack = () => {
  router.go(-1)
}

// 添加创作灵感到内容
const addInspiration = (tip) => {
  if (blogForm.value.content) {
    blogForm.value.content += '\n\n' + tip
  } else {
    blogForm.value.content = tip
  }
}



// 内容图片上传成功
const handleContentImageSuccess = (imageUrl) => {
  console.log('图片上传成功:', imageUrl)
  // 确保URL是完整的访问路径
  const fullUrl = imageUrl.startsWith('http') ? imageUrl : `http://localhost:8080${imageUrl}`
  
  // 将图片URL添加到images数组
  if (!blogForm.value.images.includes(fullUrl)) {
    blogForm.value.images.push(fullUrl)
  }
  
  console.log('图片已添加到管理列表:', fullUrl)
}

// 图片上传前验证
const beforeContentImageUpload = (file) => {
  const isImage = file.type.startsWith('image/')
  const isLt5M = file.size / 1024 / 1024 < 5

  if (!isImage) {
    ElMessage.error('只能上传图片文件!')
    return false
  }
  if (!isLt5M) {
    ElMessage.error('图片大小不能超过 5MB!')
    return false
  }
  return true
}

// 设置封面图片
const setCoverImage = (imageUrl) => {
  coverImageUrl.value = imageUrl
  ElMessage.success('封面设置成功')
}

// 删除图片
const deleteImage = async (imageUrl, index) => {
  try {
    // 确认删除
    await ElMessageBox.confirm(
      '确定要删除这张图片吗？删除后无法恢复。',
      '确认删除',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      }
    )
    
    // 调用后端删除API
    const response = await axios.delete('/api/upload/delete', {
      params: { url: imageUrl },
      headers: {
        'Authorization': `Bearer ${localStorage.getItem('userToken') || localStorage.getItem('adminToken')}`
      }
    })
    
    if (response.data.success) {
      // 如果删除的是封面图片，清空封面设置
      if (imageUrl === coverImageUrl.value) {
        coverImageUrl.value = ''
        ElMessage.info('已清除封面设置')
      }
      
      // 从images数组中移除
      blogForm.value.images.splice(index, 1)
      
      // 从内容中移除对应的Markdown图片语法
      const imageMarkdown = `![图片描述](${imageUrl})`
      blogForm.value.content = blogForm.value.content.replace(imageMarkdown, '')
      
      ElMessage.success('图片删除成功')
    } else {
      ElMessage.error(response.data.message || '删除失败')
    }
  } catch (error) {
    if (error !== 'cancel') {
      console.error('删除图片失败:', error)
      ElMessage.error('删除失败，请重试')
    }
  }
}

// 复制图片链接
const copyImageUrl = async (imageUrl) => {
  try {
    await navigator.clipboard.writeText(imageUrl)
    ElMessage.success('图片链接已复制到剪贴板')
  } catch (error) {
    // 降级方案：创建临时输入框
    const textArea = document.createElement('textarea')
    textArea.value = imageUrl
    document.body.appendChild(textArea)
    textArea.select()
    document.execCommand('copy')
    document.body.removeChild(textArea)
    ElMessage.success('图片链接已复制到剪贴板')
  }
}

// 保存草稿
const saveDraft = async () => {
  if (!blogForm.value.title.trim()) {
    ElMessage.warning('请输入文章标题')
    return
  }

  draftLoading.value = true
  try {
    const token = localStorage.getItem('userToken') || localStorage.getItem('adminToken')
    const blogData = {
      ...blogForm.value,
      images: JSON.stringify(blogForm.value.images),
      tags: JSON.stringify(blogForm.value.tags),
      isPublished: false
    }

    // 如果不是编辑模式，设置初始计数
    if (!isEditMode.value) {
      blogData.viewCount = 0
      blogData.likeCount = 0
    }

    console.log(isEditMode.value ? '更新草稿数据:' : '保存草稿数据:', blogData)

    let response
    if (isEditMode.value && editingBlogId.value) {
      // 编辑模式：更新现有文章
      response = await axios.put(`/api/blogs/${editingBlogId.value}`, blogData, {
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json'
        }
      })
      ElMessage.success('草稿更新成功！')
    } else {
      // 新建模式：创建新草稿
      response = await axios.post('/api/blogs', blogData, {
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json'
        }
      })
      ElMessage.success('草稿保存成功！')
    }
  } catch (error) {
    console.error(isEditMode.value ? '更新草稿失败:' : '保存草稿失败:', error)
    const errorMessage = error.response?.data?.message || error.message
    ElMessage.error((isEditMode.value ? '更新失败：' : '保存失败：') + errorMessage)
  } finally {
    draftLoading.value = false
  }
}

// 发布文章
const publishBlog = async () => {
  // 表单验证
  if (!blogForm.value.title.trim()) {
    ElMessage.warning('请输入文章标题')
    return
  }
  if (blogForm.value.title.length < 5 || blogForm.value.title.length > 100) {
    ElMessage.warning('文章标题长度应在5-100个字符之间')
    return
  }
  if (!blogForm.value.content.trim()) {
    ElMessage.warning('请输入文章内容')
    return
  }
  if (!blogForm.value.category) {
    ElMessage.warning('请选择文章分类')
    return
  }

  publishLoading.value = true
  try {
    const token = localStorage.getItem('userToken') || localStorage.getItem('adminToken')
    const blogData = {
      ...blogForm.value,
      images: JSON.stringify(blogForm.value.images),
      tags: JSON.stringify(blogForm.value.tags),
      isPublished: true
    }

    // 如果不是编辑模式，设置初始计数
    if (!isEditMode.value) {
      blogData.viewCount = 0
      blogData.likeCount = 0
    }

    console.log(isEditMode.value ? '更新文章数据:' : '发布文章数据:', blogData)

    let response
    if (isEditMode.value && editingBlogId.value) {
      // 编辑模式：更新现有文章
      response = await axios.put(`/api/blogs/${editingBlogId.value}`, blogData, {
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json'
        }
      })
      ElMessage.success('文章更新成功！')
    } else {
      // 新建模式：创建新文章
      response = await axios.post('/api/blogs', blogData, {
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json'
        }
      })
      ElMessage.success('文章发布成功！')
    }

    if (response.data) {
      // 跳转到文章详情页或文章列表
      router.push('/articles')
    }
  } catch (error) {
    console.error(isEditMode.value ? '更新文章失败:' : '发布文章失败:', error)
    const errorMessage = error.response?.data?.message || error.message
    ElMessage.error((isEditMode.value ? '更新失败：' : '发布失败：') + errorMessage)
  } finally {
    publishLoading.value = false
  }
}

// 预览文章
const previewBlog = () => {
  previewVisible.value = true
}

// 获取分类列表
const fetchCategories = async () => {
  try {
    const response = await axios.get('/api/categories')
    if (response.data && Array.isArray(response.data)) {
      categories.value = response.data
    } else {
      // 提供默认分类
      categories.value = [
        { id: 1, name: "技术分享" },
        { id: 2, name: "生活随笔" },
        { id: 3, name: "学习笔记" },
        { id: 4, name: "项目经验" }
      ]
    }
  } catch (error) {
    console.error('获取分类失败:', error)
    categories.value = [
      { id: 1, name: "技术分享" },
      { id: 2, name: "生活随笔" },
      { id: 3, name: "学习笔记" },
      { id: 4, name: "项目经验" }
    ]
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

// 组件挂载时获取数据
onMounted(() => {
  // 更新上传请求头
  const token = localStorage.getItem('userToken') || localStorage.getItem('adminToken')
  uploadHeaders.value = {
    'Authorization': `Bearer ${token}`
  }
  
  fetchCategories()
  fetchTags()
  
  // 检查是否是编辑模式
  const editingBlogData = sessionStorage.getItem('editingBlog')
  if (editingBlogData) {
    try {
      const blog = JSON.parse(editingBlogData)
      
      // 设置编辑模式
      isEditMode.value = true
      editingBlogId.value = blog.id
      
      blogForm.value = {
        title: blog.title || '',
        content: blog.content || '',
        summary: blog.summary || '',
        category: blog.category || '',
        tags: blog.tags ? (typeof blog.tags === 'string' ? 
          (blog.tags.startsWith('[') && blog.tags.endsWith(']') ? 
            JSON.parse(blog.tags) : 
            blog.tags.split(',').filter(tag => tag.trim())
          ) : blog.tags
        ) : [],
        images: blog.images ? (typeof blog.images === 'string' ? JSON.parse(blog.images) : blog.images) : []
      }
      
      // 设置封面图片
      if (blogForm.value.images.length > 0) {
        coverImageUrl.value = blogForm.value.images[0]
      }
      
      // 清除sessionStorage中的编辑数据
      sessionStorage.removeItem('editingBlog')
      
      ElMessage.success('已加载文章数据，可以继续编辑')
    } catch (error) {
      console.error('解析编辑数据失败:', error)
      ElMessage.error('加载编辑数据失败')
    }
  }
})
</script>

<style scoped>
.publish-page {
  min-height: 100vh;
  background-color: #f5f5f5;
}

.publish-header {
  background: white;
  border-bottom: 1px solid #e4e7ed;
  position: sticky;
  top: 0;
  z-index: 100;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.header-content {
  max-width: 1400px;
  margin: 0 auto;
  padding: 0 20px;
  height: 64px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  min-width: 0;
}

.header-left {
  display: flex;
  flex-direction: row;
  align-items: center;
  gap: 12px;
  min-width: 0;
}

.header-left .el-button {
  margin: 0;
  vertical-align: middle;
}

.header-left h1 {
  margin: 0;
  font-size: 1.5rem;
  color: #303133;
  white-space: nowrap;
  line-height: 1.2;
  display: inline-block;
}

.header-right {
  display: flex;
  gap: 12px;
  flex-shrink: 0;
}

.publish-main {
  padding: 20px;
}

.publish-container {
  max-width: 1400px;
  margin: 0 auto;
  display: grid;
  grid-template-columns: 1fr 320px;
  gap: 20px;
  align-items: start;
}

.editor-section {
  background: white;
  border-radius: 8px;
  padding: 24px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.title-section {
  margin-bottom: 24px;
}

.title-input {
  font-size: 1.2rem;
}

.title-input :deep(.el-input__inner) {
  font-size: 1.2rem;
  font-weight: 500;
}

.inspiration-section {
  margin-bottom: 24px;
  padding: 16px;
  background: #f8f9fa;
  border-radius: 8px;
}

.inspiration-section h3 {
  margin: 0 0 12px 0;
  color: #606266;
  font-size: 14px;
}

.inspiration-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.inspiration-tag {
  cursor: pointer;
  transition: all 0.3s ease;
}

.inspiration-tag:hover {
  background-color: #409eff;
  color: white;
}

.content-section {
  margin-bottom: 24px;
}

.content-editor :deep(.el-textarea__inner) {
  font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace;
  line-height: 1.6;
  resize: vertical;
}

.editor-toolbar {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 12px;
  padding: 8px 0;
  border-bottom: 1px solid #e4e7ed;
}

.image-upload-btn {
  display: inline-block;
}

.image-upload-btn .el-button {
  display: flex;
  align-items: center;
  gap: 4px;
}

.settings-section {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.setting-card {
  background: white;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.setting-card h3 {
  margin: 0 0 16px 0;
  color: #303133;
  font-size: 16px;
}



.publish-options {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.publish-type {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.preview-dialog {
  max-height: 80vh;
}

.preview-content {
  max-height: 60vh;
  overflow-y: auto;
}

.preview-title {
  font-size: 1.8rem;
  margin-bottom: 16px;
  color: #303133;
}

.preview-meta {
  display: flex;
  gap: 16px;
  margin-bottom: 16px;
  color: #909399;
  font-size: 14px;
}

.preview-summary {
  padding: 12px;
  background: #f5f7fa;
  border-radius: 4px;
  margin-bottom: 16px;
  color: #606266;
}

.preview-body {
  line-height: 1.8;
  color: #303133;
}

.preview-body pre {
  white-space: pre-wrap;
  word-wrap: break-word;
  font-family: inherit;
  margin: 0;
}

/* 图片管理样式 */
.no-images {
  text-align: center;
  color: #909399;
  padding: 20px;
  font-size: 14px;
}

.upload-hint {
  font-size: 12px;
  color: #c0c4cc;
  margin-top: 8px;
}

.image-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
  max-height: 300px;
  overflow-y: auto;
}

.image-item {
  position: relative;
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 8px;
  border: 1px solid #e4e7ed;
  border-radius: 6px;
  background: #fafafa;
  transition: all 0.3s ease;
}

.image-item:hover {
  border-color: #409eff;
  background: #f0f9ff;
}

.image-item.is-cover {
  border-color: #67c23a;
  background: #f0f9ff;
  box-shadow: 0 2px 4px rgba(103, 194, 58, 0.2);
}

.thumbnail {
  width: 60px;
  height: 60px;
  object-fit: cover;
  border-radius: 4px;
  border: 1px solid #e4e7ed;
}

.image-actions {
  display: flex;
  gap: 8px;
  margin-left: auto;
}

.image-actions .el-button {
  padding: 4px 8px;
  font-size: 12px;
}

.cover-badge {
  position: absolute;
  top: -8px;
  right: -8px;
  background: #67c23a;
  color: white;
  font-size: 10px;
  padding: 2px 6px;
  border-radius: 10px;
  font-weight: bold;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

/* 预览对话框样式 */
.preview-dialog {
  .preview-content {
    padding: 20px;
  }
  
  .preview-title {
    font-size: 2rem;
    font-weight: bold;
    margin-bottom: 16px;
    color: #303133;
    border-bottom: 2px solid #e4e7ed;
    padding-bottom: 12px;
  }
  
  .preview-meta {
    display: flex;
    gap: 20px;
    margin-bottom: 16px;
    color: #909399;
    font-size: 14px;
  }
  
  .preview-summary {
    background: #f5f7fa;
    padding: 12px 16px;
    border-radius: 6px;
    margin-bottom: 20px;
    border-left: 4px solid #409eff;
  }
  
  .preview-body {
    line-height: 1.8;
    font-size: 16px;
    color: #303133;
    
    /* 富文本内容样式 */
    h1, h2, h3, h4, h5, h6 {
      margin: 1.5em 0 0.8em 0;
      font-weight: bold;
      line-height: 1.4;
    }
    
    h1 { font-size: 2em; }
    h2 { font-size: 1.5em; }
    h3 { font-size: 1.17em; }
    h4 { font-size: 1em; }
    h5 { font-size: 0.83em; }
    h6 { font-size: 0.75em; }
    
    p {
      margin: 1em 0;
    }
    
    img {
      max-width: 100%;
      height: auto;
      display: block;
      margin: 1em auto;
      border-radius: 6px;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    }
    
    blockquote {
      border-left: 4px solid #ddd;
      margin: 1em 0;
      padding-left: 1em;
      color: #666;
      background: #f9f9f9;
      padding: 12px 16px;
      border-radius: 0 6px 6px 0;
    }
    
    code {
      background-color: #f4f4f4;
      border: 1px solid #ddd;
      border-radius: 3px;
      padding: 2px 6px;
      font-family: 'Courier New', monospace;
      font-size: 0.9em;
    }
    
    pre {
      background-color: #f4f4f4;
      border: 1px solid #ddd;
      border-radius: 6px;
      padding: 16px;
      overflow-x: auto;
      font-family: 'Courier New', monospace;
      margin: 1em 0;
    }
    
    ul, ol {
      padding-left: 2em;
      margin: 1em 0;
    }
    
    li {
      margin: 0.5em 0;
    }
    
    a {
      color: #409eff;
      text-decoration: none;
    }
    
    a:hover {
      text-decoration: underline;
    }
    
    table {
      width: 100%;
      border-collapse: collapse;
      margin: 1em 0;
    }
    
    th, td {
      border: 1px solid #ddd;
      padding: 8px 12px;
      text-align: left;
    }
    
    th {
      background-color: #f5f7fa;
      font-weight: bold;
    }
  }
}

/* 响应式设计 */
@media (max-width: 1200px) {
  .publish-container {
    max-width: 100%;
    grid-template-columns: 1fr 280px;
    gap: 16px;
  }
}

@media (max-width: 1024px) {
  .publish-container {
    grid-template-columns: 1fr;
    gap: 16px;
  }
  
  .settings-section {
    order: -1;
  }
}

@media (max-width: 768px) {
  .header-content {
    padding: 0 16px;
  }
  
  .header-left h1 {
    font-size: 1.2rem;
  }
  
  .publish-main {
    padding: 16px;
  }
  
  .editor-section,
  .setting-card {
    padding: 16px;
  }
  
  .image-item {
    flex-direction: column;
    align-items: flex-start;
  }
  
  .image-actions {
    margin-left: 0;
    width: 100%;
    justify-content: space-between;
  }
}
</style>