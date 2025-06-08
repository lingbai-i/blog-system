<template>
  <div class="announcement-detail-page">
    <!-- 加载状态 -->
    <div v-if="loading" class="loading-container">
      <el-skeleton :rows="8" animated />
    </div>

    <!-- 公告详情 -->
    <div v-else-if="announcement" class="announcement-detail">
      <!-- 返回按钮 -->
      <div class="back-button">
        <el-button @click="goBack" :icon="ArrowLeft" type="info" plain>
          返回公告列表
        </el-button>
      </div>

      <!-- 公告头部 -->
      <div class="announcement-header">
        <div class="title-section">
          <h1 class="announcement-title">
            <el-icon v-if="announcement.isPinned" class="pin-icon"><Top /></el-icon>
            {{ announcement.title }}
          </h1>
          <div class="announcement-meta">
            <div class="meta-item">
              <el-icon><User /></el-icon>
              <span>{{ announcement.authorName }}</span>
            </div>
            <div class="meta-item">
              <el-icon><Calendar /></el-icon>
              <span>{{ formatDate(announcement.publishedAt) }}</span>
            </div>
            <div v-if="announcement.updatedAt !== announcement.createdAt" class="meta-item">
              <el-icon><Edit /></el-icon>
              <span>更新于 {{ formatDate(announcement.updatedAt) }}</span>
            </div>
          </div>
        </div>
        
        <!-- 置顶标签 -->
        <div v-if="announcement.isPinned" class="pinned-badge">
          <el-tag type="danger" size="large">
            <el-icon><Top /></el-icon>
            置顶公告
          </el-tag>
        </div>
      </div>

      <!-- 公告内容 -->
      <div class="announcement-content">
        <div class="content-wrapper" v-html="announcement.content"></div>
      </div>

      <!-- 操作按钮 -->
      <div class="action-buttons">
        <el-button @click="goBack" size="large">
          返回列表
        </el-button>
        <el-button type="primary" @click="shareAnnouncement" size="large">
          <el-icon><Share /></el-icon>
          分享
        </el-button>
      </div>
    </div>

    <!-- 错误状态 -->
    <div v-else class="error-state">
      <el-result
        icon="warning"
        title="公告不存在"
        sub-title="您访问的公告可能已被删除或不存在"
      >
        <template #extra>
          <el-button type="primary" @click="goBack">返回公告列表</el-button>
        </template>
      </el-result>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import axios from 'axios'
import { ElMessage, ElSkeleton, ElButton, ElIcon, ElTag, ElResult } from 'element-plus'
import { ArrowLeft, Top, User, Calendar, Edit, Share } from '@element-plus/icons-vue'

const route = useRoute()
const router = useRouter()
const announcement = ref(null)
const loading = ref(true)

// 获取公告详情
const fetchAnnouncementDetail = async () => {
  try {
    loading.value = true
    const id = route.params.id
    const response = await axios.get(`/api/announcements/${id}`)
    
    if (response.data.success) {
      announcement.value = response.data.data
      // 设置页面标题
      document.title = `${announcement.value.title} - 公告详情`
    } else {
      ElMessage.error('获取公告详情失败')
    }
  } catch (error) {
    console.error('获取公告详情失败:', error)
    if (error.response?.status === 404) {
      ElMessage.error('公告不存在')
    } else {
      ElMessage.error('获取公告详情失败，请稍后重试')
    }
  } finally {
    loading.value = false
  }
}

// 返回公告列表
const goBack = () => {
  router.push('/announcements')
}

// 分享公告
const shareAnnouncement = () => {
  if (navigator.share) {
    navigator.share({
      title: announcement.value.title,
      text: announcement.value.title,
      url: window.location.href
    }).catch(err => {
      console.log('分享失败:', err)
      copyToClipboard()
    })
  } else {
    copyToClipboard()
  }
}

// 复制链接到剪贴板
const copyToClipboard = () => {
  navigator.clipboard.writeText(window.location.href).then(() => {
    ElMessage.success('链接已复制到剪贴板')
  }).catch(() => {
    ElMessage.error('复制失败，请手动复制链接')
  })
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

onMounted(() => {
  fetchAnnouncementDetail()
})
</script>

<style scoped>
.announcement-detail-page {
  max-width: 900px;
  margin: 0 auto;
  padding: 20px;
  min-height: 80vh;
}

.loading-container {
  padding: 40px 20px;
}

.back-button {
  margin-bottom: 20px;
}

.announcement-detail {
  background: white;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
}

.announcement-header {
  padding: 40px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  position: relative;
}

.title-section {
  flex: 1;
}

.announcement-title {
  font-size: 2.2rem;
  font-weight: 600;
  margin: 0 0 20px 0;
  line-height: 1.3;
  display: flex;
  align-items: center;
  gap: 12px;
}

.pin-icon {
  color: #ffd700;
  font-size: 1.5rem;
}

.announcement-meta {
  display: flex;
  flex-wrap: wrap;
  gap: 24px;
  opacity: 0.9;
}

.meta-item {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 0.95rem;
}

.pinned-badge {
  position: absolute;
  top: 20px;
  right: 20px;
}

.announcement-content {
  padding: 40px;
}

.content-wrapper {
  line-height: 1.8;
  font-size: 1.05rem;
  color: #303133;
}

/* 内容样式 */
.content-wrapper :deep(h1),
.content-wrapper :deep(h2),
.content-wrapper :deep(h3),
.content-wrapper :deep(h4),
.content-wrapper :deep(h5),
.content-wrapper :deep(h6) {
  margin: 24px 0 16px 0;
  color: #303133;
  font-weight: 600;
}

.content-wrapper :deep(p) {
  margin: 16px 0;
  text-align: justify;
}

.content-wrapper :deep(ul),
.content-wrapper :deep(ol) {
  margin: 16px 0;
  padding-left: 24px;
}

.content-wrapper :deep(li) {
  margin: 8px 0;
}

.content-wrapper :deep(blockquote) {
  margin: 20px 0;
  padding: 16px 20px;
  background: #f8f9fa;
  border-left: 4px solid #409eff;
  border-radius: 4px;
}

.content-wrapper :deep(code) {
  background: #f5f5f5;
  padding: 2px 6px;
  border-radius: 4px;
  font-family: 'Courier New', monospace;
  font-size: 0.9em;
}

.content-wrapper :deep(pre) {
  background: #f5f5f5;
  padding: 16px;
  border-radius: 8px;
  overflow-x: auto;
  margin: 16px 0;
}

.content-wrapper :deep(img) {
  max-width: 100%;
  height: auto;
  border-radius: 8px;
  margin: 16px 0;
}

.action-buttons {
  padding: 30px 40px;
  background: #f8f9fa;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.error-state {
  padding: 60px 20px;
  text-align: center;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .announcement-detail-page {
    padding: 10px;
  }
  
  .announcement-header {
    padding: 30px 20px;
  }
  
  .announcement-title {
    font-size: 1.8rem;
  }
  
  .announcement-meta {
    flex-direction: column;
    gap: 12px;
  }
  
  .pinned-badge {
    position: static;
    margin-top: 20px;
  }
  
  .announcement-content {
    padding: 30px 20px;
  }
  
  .action-buttons {
    padding: 20px;
    flex-direction: column;
    gap: 12px;
  }
  
  .action-buttons .el-button {
    width: 100%;
  }
}
</style>