<template>
  <div class="comment-section">
    <div class="comment-header">
      <h3 class="comment-title">
        <el-icon><ChatDotRound /></el-icon>
        评论 ({{ commentCount }})
      </h3>
    </div>

    <!-- 评论表单 -->
    <div class="comment-form-section">
      <el-card class="comment-form-card">
        <template #header>
          <span>发表评论</span>
        </template>
        <el-form :model="commentForm" :rules="commentRules" ref="commentFormRef">
          <el-form-item prop="content">
            <el-input
              v-model="commentForm.content"
              type="textarea"
              :rows="4"
              placeholder="请输入评论内容..."
              maxlength="500"
              show-word-limit
            />
          </el-form-item>
          <el-form-item>
            <el-button
              type="primary"
              @click="submitComment"
              :loading="submitting"
              :icon="EditPen"
            >
              发表评论
            </el-button>
            <el-button @click="resetForm">重置</el-button>
          </el-form-item>
        </el-form>
      </el-card>
    </div>

    <!-- 评论列表 -->
    <div class="comment-list-section">
      <div v-if="loading" class="loading-section">
        <el-skeleton :rows="3" animated />
      </div>
      
      <div v-else-if="comments.length === 0" class="empty-comments">
        <el-empty description="暂无评论，快来发表第一条评论吧！" />
      </div>
      
      <div v-else class="comment-list">
        <div
          v-for="comment in comments"
          :key="comment.id"
          class="comment-item"
        >
          <div class="comment-content">
            <div class="comment-header-info">
              <div class="comment-author">
                <el-avatar :size="40" :icon="UserFilled" />
                <div class="author-info">
                  <span class="author-name">{{ comment.authorName }}</span>
                  <span class="comment-time">{{ formatDate(comment.createdAt) }}</span>
                </div>
              </div>
              <div class="comment-actions">
                <el-button
                  text
                  type="primary"
                  size="small"
                  @click="showReplyForm(comment.id)"
                  :icon="ChatLineRound"
                >
                  回复
                </el-button>
              </div>
            </div>
            <div class="comment-text">{{ comment.content }}</div>
            
            <!-- 回复表单 -->
            <div v-if="replyingTo === comment.id" class="reply-form">
              <el-card>
                <template #header>
                  <span>回复 {{ comment.authorName }}</span>
                </template>
                <el-form :model="replyForm" :rules="replyRules" :ref="`replyForm_${comment.id}`" :data-reply-form="comment.id">
                  <el-form-item prop="content">
                    <el-input
                      v-model="replyForm.content"
                      type="textarea"
                      :rows="3"
                      placeholder="请输入回复内容..."
                      maxlength="300"
                      show-word-limit
                    />
                  </el-form-item>
                  <el-form-item>
                    <el-button
                      type="primary"
                      size="small"
                      @click="submitReply(comment.id)"
                      :loading="replySubmitting"
                      :icon="EditPen"
                    >
                      发表回复
                    </el-button>
                    <el-button size="small" @click="cancelReply">取消</el-button>
                  </el-form-item>
                </el-form>
              </el-card>
            </div>
            
            <!-- 回复列表 -->
            <div v-if="comment.replies && comment.replies.length > 0" class="replies-section">
              <div
                v-for="reply in comment.replies"
                :key="reply.id"
                class="reply-item"
              >
                <div class="reply-content">
                  <div class="reply-header">
                    <el-avatar :size="32" :icon="UserFilled" />
                    <div class="reply-author-info">
                      <span class="reply-author-name">{{ reply.authorName }}</span>
                      <span class="reply-time">{{ formatDate(reply.createdAt) }}</span>
                    </div>
                  </div>
                  <div class="reply-text">{{ reply.content }}</div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, watch, nextTick, getCurrentInstance } from 'vue'
import {
  ChatDotRound,
  EditPen,
  UserFilled,
  ChatLineRound
} from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import axios from 'axios'

// Props
const props = defineProps({
  blogId: {
    type: [String, Number],
    required: true
  }
})

// 响应式数据
const comments = ref([])
const commentCount = ref(0)
const loading = ref(false)
const submitting = ref(false)
const replySubmitting = ref(false)
const replyingTo = ref(null)

// 表单引用
const commentFormRef = ref()
const replyFormRef = ref()

// 评论表单
const commentForm = ref({
  content: ''
})

// 回复表单
const replyForm = ref({
  content: ''
})

// 表单验证规则
const commentRules = {
  content: [
    { required: true, message: '请输入评论内容', trigger: 'blur' },
    { min: 5, max: 500, message: '评论内容长度在 5 到 500 个字符', trigger: 'blur' }
  ]
}

const replyRules = {
  content: [
    { required: true, message: '请输入回复内容', trigger: 'blur' },
    { min: 5, max: 300, message: '回复内容长度在 5 到 300 个字符', trigger: 'blur' }
  ]
}

// 获取评论列表
const fetchComments = async () => {
  if (!props.blogId) return
  
  loading.value = true
  try {
    const response = await axios.get(`/api/comments/blog/${props.blogId}`)
    if (response.data) {
      comments.value = response.data
      // 获取回复
      await fetchRepliesForComments()
    }
  } catch (error) {
    console.error('获取评论失败:', error)
    ElMessage.error('获取评论失败')
  } finally {
    loading.value = false
  }
}

// 获取评论的回复
const fetchRepliesForComments = async () => {
  for (const comment of comments.value) {
    try {
      const response = await axios.get(`/api/comments/${comment.id}/replies`)
      if (response.data) {
        comment.replies = response.data
      }
    } catch (error) {
      console.error(`获取评论 ${comment.id} 的回复失败:`, error)
      comment.replies = []
    }
  }
}

// 获取评论数量
const fetchCommentCount = async () => {
  if (!props.blogId) return
  
  try {
    const response = await axios.get(`/api/comments/blog/${props.blogId}/count`)
    if (response.data) {
      commentCount.value = response.data.count || 0
    }
  } catch (error) {
    console.error('获取评论数量失败:', error)
    commentCount.value = 0
  }
}

// 提交评论
const submitComment = async () => {
  if (!commentFormRef.value) return
  
  try {
    await commentFormRef.value.validate()
    
    submitting.value = true
    
    // 获取用户ID
    let userId = null
    const token = localStorage.getItem('userToken') || localStorage.getItem('adminToken')
    if (token && token.startsWith('token_')) {
      const parts = token.split('_')
      if (parts.length >= 3) {
        userId = parseInt(parts[1])
      }
    }
    
    const requestData = {
      blogId: props.blogId,
      content: commentForm.value.content
    }
    
    if (userId) {
      requestData.userId = userId
    }
    
    const response = await axios.post('/api/comments', requestData)
    
    if (response.data && response.data.success) {
      ElMessage.success('评论提交成功')
      resetForm()
      // 重新获取评论列表和数量
      await fetchComments()
      await fetchCommentCount()
    } else {
      ElMessage.error(response.data?.message || '评论提交失败')
    }
  } catch (error) {
    console.error('提交评论失败:', error)
    if (error.response?.data?.message) {
      ElMessage.error(error.response.data.message)
    } else {
      ElMessage.error('评论提交失败，请稍后重试')
    }
  } finally {
    submitting.value = false
  }
}

// 提交回复
const submitReply = async (parentId) => {
  // 检查是否正在回复该评论
  if (replyingTo.value !== parentId) {
    ElMessage.error('表单未准备就绪，请重试')
    return
  }
  
  // 等待DOM更新，确保表单已渲染
  await nextTick()
  
  try {
    // 简单的表单验证
    if (!replyForm.value.content || replyForm.value.content.trim() === '') {
      ElMessage.error('请输入回复内容')
      return
    }
    
    if (replyForm.value.content.length > 300) {
      ElMessage.error('回复内容不能超过300个字符')
      return
    }
    
    replySubmitting.value = true
    
    // 获取用户ID
    let userId = null
    const token = localStorage.getItem('userToken') || localStorage.getItem('adminToken')
    if (token && token.startsWith('token_')) {
      const parts = token.split('_')
      if (parts.length >= 3) {
        userId = parseInt(parts[1])
      }
    }
    
    const requestData = {
      blogId: props.blogId,
      parentId: parentId,
      content: replyForm.value.content
    }
    
    if (userId) {
      requestData.userId = userId
    }
    
    const response = await axios.post('/api/comments/reply', requestData)
    
    if (response.data && response.data.success) {
      ElMessage.success('回复发布成功！')
      replyForm.value.content = ''
      replyingTo.value = null
      
      await fetchComments()
      await fetchCommentCount()
    } else {
      ElMessage.error(response.data?.message || '回复提交失败')
    }
  } catch (error) {
    console.error('提交回复失败:', error)
    if (error.response?.data?.message) {
      ElMessage.error(error.response.data.message)
    } else {
      ElMessage.error('回复提交失败，请稍后重试')
    }
  } finally {
    replySubmitting.value = false
  }
}

// 显示回复表单
const showReplyForm = async (commentId) => {
  replyingTo.value = commentId
  // 清空回复表单
  replyForm.value = {
    authorName: '',
    authorEmail: '',
    content: ''
  }
  
  // 等待 DOM 更新完成，确保表单引用正确绑定
  await nextTick()
}

// 取消回复
const cancelReply = () => {
  replyingTo.value = null
  replyForm.value = {
    content: ''
  }
}

// 重置评论表单
const resetForm = () => {
  commentForm.value = {
    content: ''
  }
  if (commentFormRef.value) {
    commentFormRef.value.resetFields()
  }
}

// 格式化日期
const formatDate = (date) => {
  if (!date) return ''
  const d = new Date(date)
  const now = new Date()
  const diff = now - d
  
  // 小于1分钟
  if (diff < 60000) {
    return '刚刚'
  }
  // 小于1小时
  if (diff < 3600000) {
    return `${Math.floor(diff / 60000)}分钟前`
  }
  // 小于1天
  if (diff < 86400000) {
    return `${Math.floor(diff / 3600000)}小时前`
  }
  // 小于7天
  if (diff < 604800000) {
    return `${Math.floor(diff / 86400000)}天前`
  }
  
  // 超过7天显示具体日期
  return d.toLocaleDateString('zh-CN', {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  })
}

// 监听 blogId 变化
watch(
  () => props.blogId,
  (newBlogId) => {
    if (newBlogId) {
      fetchComments()
      fetchCommentCount()
    }
  },
  { immediate: true }
)

// 组件挂载时获取数据
onMounted(() => {
  if (props.blogId) {
    fetchComments()
    fetchCommentCount()
  }
})
</script>

<style scoped>
.comment-section {
  margin-top: 2rem;
}

.comment-header {
  margin-bottom: 1.5rem;
}

.comment-title {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 1.5rem;
  font-weight: 600;
  color: #333;
  margin: 0;
}

.comment-form-section {
  margin-bottom: 2rem;
}

.comment-form-card {
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.loading-section {
  background: white;
  border-radius: 8px;
  padding: 1.5rem;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.empty-comments {
  background: white;
  border-radius: 8px;
  padding: 2rem;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  text-align: center;
}

.comment-list {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.comment-item {
  background: white;
  border-radius: 8px;
  padding: 1.5rem;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  transition: box-shadow 0.3s ease;
}

.comment-item:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.comment-header-info {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1rem;
}

.comment-author {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.author-info {
  display: flex;
  flex-direction: column;
}

.author-name {
  font-weight: 600;
  color: #333;
  font-size: 0.95rem;
}

.comment-time {
  color: #666;
  font-size: 0.8rem;
}

.comment-text {
  color: #333;
  line-height: 1.6;
  margin-bottom: 1rem;
  white-space: pre-wrap;
}

.reply-form {
  margin-top: 1rem;
  margin-left: 2rem;
}

.replies-section {
  margin-top: 1rem;
  margin-left: 2rem;
  border-left: 3px solid #e0e0e0;
  padding-left: 1rem;
}

.reply-item {
  background: #f8f9fa;
  border-radius: 6px;
  padding: 1rem;
  margin-bottom: 0.75rem;
}

.reply-item:last-child {
  margin-bottom: 0;
}

.reply-header {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin-bottom: 0.75rem;
}

.reply-author-info {
  display: flex;
  flex-direction: column;
}

.reply-author-name {
  font-weight: 600;
  color: #333;
  font-size: 0.9rem;
}

.reply-time {
  color: #666;
  font-size: 0.75rem;
}

.reply-text {
  color: #333;
  line-height: 1.5;
  font-size: 0.9rem;
  white-space: pre-wrap;
}

.comment-actions {
  display: flex;
  gap: 0.5rem;
}

@media (max-width: 768px) {
  .comment-header-info {
    flex-direction: column;
    align-items: flex-start;
    gap: 0.5rem;
  }
  
  .reply-form,
  .replies-section {
    margin-left: 1rem;
  }
  
  .comment-title {
    font-size: 1.3rem;
  }
}
</style>