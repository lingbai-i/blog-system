<template>
  <div class="announcement-banner" v-if="announcements.length > 0">
    <div class="announcement-container">
      <div class="announcement-icon">
        <el-icon><Bell /></el-icon>
      </div>
      <div class="announcement-content">
        <div class="announcement-slider" v-if="announcements.length > 1">
          <el-carousel 
            :interval="5000" 
            :show-arrow="'hover'"
            indicator-position="none"
            height="auto"
            class="announcement-carousel"
          >
            <el-carousel-item v-for="announcement in announcements" :key="announcement.id">
              <div class="announcement-item" @click="showAnnouncementDetail(announcement)">
                <span class="announcement-badge" v-if="announcement.isPinned">置顶</span>
                <span class="announcement-title">{{ announcement.title }}</span>
                <span class="announcement-time">{{ formatTime(announcement.publishedAt) }}</span>
              </div>
            </el-carousel-item>
          </el-carousel>
        </div>
        <div v-else class="announcement-single" @click="showAnnouncementDetail(announcements[0])">
          <span class="announcement-badge" v-if="announcements[0].isPinned">置顶</span>
          <span class="announcement-title">{{ announcements[0].title }}</span>
          <span class="announcement-time">{{ formatTime(announcements[0].publishedAt) }}</span>
        </div>
      </div>
      <div class="announcement-close">
        <el-button 
          text 
          @click="closeAnnouncement"
          :icon="Close"
          size="small"
        />
      </div>
    </div>

    <!-- 公告详情弹窗 -->
    <el-dialog
      v-model="dialogVisible"
      :title="selectedAnnouncement?.title"
      width="600px"
      class="announcement-dialog"
    >
      <div class="announcement-detail">
        <div class="announcement-meta">
          <span class="announcement-author">发布者：{{ selectedAnnouncement?.authorName }}</span>
          <span class="announcement-date">发布时间：{{ formatDateTime(selectedAnnouncement?.publishedAt) }}</span>
        </div>
        <div class="announcement-body" v-html="selectedAnnouncement?.content"></div>
      </div>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { Bell, Close } from '@element-plus/icons-vue'
import axios from 'axios'

// 响应式数据
const announcements = ref([])
const dialogVisible = ref(false)
const selectedAnnouncement = ref(null)
const isVisible = ref(true)

// 获取公告数据
const fetchAnnouncements = async () => {
  try {
    const response = await axios.get('/api/announcements/pinned')
    if (response.data.success) {
      announcements.value = response.data.data.slice(0, 3) // 最多显示3条置顶公告
    }
  } catch (error) {
    console.error('获取公告失败:', error)
  }
}

// 跳转到公告详情页面
const router = useRouter()
const showAnnouncementDetail = (announcement) => {
  // 使用router跳转到公告详情页
  router.push(`/announcements/${announcement.id}`)
}

// 关闭公告横幅
const closeAnnouncement = () => {
  isVisible.value = false
  // 可以在这里添加本地存储逻辑，记住用户关闭状态
  localStorage.setItem('announcementClosed', Date.now().toString())
}

// 格式化时间
const formatTime = (dateTime) => {
  if (!dateTime) return ''
  const date = new Date(dateTime)
  const now = new Date()
  const diff = now - date
  const days = Math.floor(diff / (1000 * 60 * 60 * 24))
  
  if (days === 0) {
    return '今天'
  } else if (days === 1) {
    return '昨天'
  } else if (days < 7) {
    return `${days}天前`
  } else {
    return date.toLocaleDateString()
  }
}

// 格式化完整日期时间
const formatDateTime = (dateTime) => {
  if (!dateTime) return ''
  return new Date(dateTime).toLocaleString()
}

// 检查是否应该显示公告
const shouldShowAnnouncement = () => {
  const closedTime = localStorage.getItem('announcementClosed')
  if (!closedTime) return true
  
  // 如果关闭时间超过24小时，重新显示
  const now = Date.now()
  const closed = parseInt(closedTime)
  return (now - closed) > 24 * 60 * 60 * 1000
}

// 组件挂载时获取数据
onMounted(() => {
  if (shouldShowAnnouncement()) {
    fetchAnnouncements()
  } else {
    isVisible.value = false
  }
})
</script>

<style scoped>
.announcement-banner {
  background: rgba(248, 249, 250, 0.6);
  border-left: 2px solid rgba(0, 123, 255, 0.3);
  color: #495057;
  padding: 4px 0;
  position: relative;
  box-shadow: none;
  border-radius: 0;
  margin: 5px 0;
  backdrop-filter: blur(5px);
  transition: all 0.3s ease;
}

.announcement-banner:hover {
  background: rgba(248, 249, 250, 0.8);
  border-left-color: rgba(0, 123, 255, 0.5);
}

.announcement-container {
  max-width: 1200px;
  margin: 0 auto;
  display: flex;
  align-items: center;
  padding: 0 16px;
  gap: 12px;
}

.announcement-icon {
  font-size: 16px;
  color: rgba(0, 123, 255, 0.7);
  background: rgba(0, 123, 255, 0.05);
  padding: 6px;
  border-radius: 50%;
  animation: none;
}

@keyframes pulse {
  0% {
    transform: scale(1);
    box-shadow: 0 0 0 0 rgba(0, 123, 255, 0.4);
  }
  50% {
    transform: scale(1.05);
    box-shadow: 0 0 0 8px rgba(0, 123, 255, 0);
  }
  100% {
    transform: scale(1);
    box-shadow: 0 0 0 0 rgba(0, 123, 255, 0);
  }
}

.announcement-content {
  flex: 1;
  overflow: hidden;
}

.announcement-carousel {
  height: auto;
}

.announcement-item,
.announcement-single {
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  padding: 4px 8px;
  border-radius: 4px;
  transition: all 0.3s ease;
  background: rgba(255, 255, 255, 0.5);
  backdrop-filter: blur(5px);
}

.announcement-item:hover,
.announcement-single:hover {
  background: rgba(0, 123, 255, 0.08);
  transform: translateX(4px);
  box-shadow: 0 2px 8px rgba(0, 123, 255, 0.15);
}

.announcement-badge {
  background: linear-gradient(135deg, #ff6b6b 0%, #ee5a24 100%);
  color: white;
  padding: 3px 8px;
  border-radius: 12px;
  font-size: 10px;
  font-weight: 500;
  line-height: 1.2;
  letter-spacing: 0.3px;
  box-shadow: 0 2px 4px rgba(238, 90, 36, 0.3);
  animation: glow 2s ease-in-out infinite alternate;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'PingFang SC', 'Hiragino Sans GB', 'Microsoft YaHei', 'Helvetica Neue', Helvetica, Arial, sans-serif;
}

@keyframes glow {
  from {
    box-shadow: 0 2px 4px rgba(238, 90, 36, 0.3);
  }
  to {
    box-shadow: 0 2px 8px rgba(238, 90, 36, 0.5), 0 0 12px rgba(238, 90, 36, 0.2);
  }
}

.announcement-title {
  font-weight: 500;
  flex: 1;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  color: #2c3e50;
  font-size: 14px;
  line-height: 1.4;
  letter-spacing: 0.3px;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'PingFang SC', 'Hiragino Sans GB', 'Microsoft YaHei', 'Helvetica Neue', Helvetica, Arial, sans-serif;
}

.announcement-time {
  font-size: 11px;
  color: #6c757d;
  white-space: nowrap;
  background: rgba(108, 117, 125, 0.1);
  padding: 2px 6px;
  border-radius: 10px;
  font-weight: 400;
  line-height: 1.2;
  letter-spacing: 0.2px;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'PingFang SC', 'Hiragino Sans GB', 'Microsoft YaHei', 'Helvetica Neue', Helvetica, Arial, sans-serif;
}

.announcement-close {
  opacity: 0.6;
  transition: all 0.3s ease;
  padding: 4px;
  border-radius: 50%;
  background: rgba(108, 117, 125, 0.1);
}

.announcement-close:hover {
  opacity: 1;
  background: rgba(220, 53, 69, 0.1);
  transform: scale(1.1);
}

.announcement-dialog {
  border-radius: 16px;
  overflow: hidden;
}

.announcement-dialog :deep(.el-dialog__header) {
  background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
  color: white;
  padding: 20px 24px;
  margin: 0;
}

.announcement-dialog :deep(.el-dialog__title) {
  color: white;
  font-weight: 600;
}

.announcement-dialog :deep(.el-dialog__headerbtn .el-dialog__close) {
  color: white;
}

.announcement-detail {
  padding: 24px;
}

.announcement-meta {
  display: flex;
  justify-content: space-between;
  margin-bottom: 24px;
  padding: 16px;
  background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
  border-radius: 12px;
  border-left: 4px solid #007bff;
  font-size: 14px;
  color: #495057;
}

.announcement-body {
  line-height: 1.8;
  color: #2c3e50;
  font-size: 15px;
  background: white;
  padding: 20px;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.announcement-body :deep(p) {
  margin-bottom: 16px;
}

.announcement-body :deep(img) {
  max-width: 100%;
  height: auto;
  border-radius: 12px;
  margin: 16px 0;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

/* 响应式设计 */
@media (max-width: 768px) {
  .announcement-banner {
    margin: 16px 8px;
    border-radius: 0 12px 12px 0;
  }
  
  .announcement-container {
    padding: 0 12px;
    gap: 8px;
  }
  
  .announcement-icon {
    font-size: 14px;
    padding: 4px;
  }
  
  .announcement-title {
    font-size: 13px;
    line-height: 1.3;
    letter-spacing: 0.2px;
  }
  
  .announcement-time {
    display: none;
  }
  
  .announcement-item,
  .announcement-single {
    padding: 3px 6px;
  }
  
  .announcement-meta {
    flex-direction: column;
    gap: 12px;
    padding: 12px;
  }
  
  .announcement-detail {
    padding: 16px;
  }
  
  .announcement-body {
    padding: 16px;
  }
}
</style>