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
        <div v-if="!checkLoginStatus()" class="login-prompt">
          <el-alert
            title="请先登录后再发表评论"
            type="info"
            :closable="false"
            show-icon
          >
            <template #default>
              <div style="margin-top: 10px;">
                <el-button type="primary" size="small" @click="goToLogin">去登录</el-button>
              </div>
            </template>
          </el-alert>
        </div>
        <el-form v-else :model="commentForm" :rules="commentRules" ref="commentFormRef">
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
          <!-- 评论图片上传 -->
          <el-form-item label="图片">
            <div class="image-upload-section">
              <el-upload
                :action="uploadUrl"
                :headers="uploadHeaders"
                :file-list="commentImageList"
                :on-success="handleCommentImageSuccess"
                :on-error="handleImageError"
                :on-remove="handleCommentImageRemove"
                :before-upload="beforeImageUpload"
                :limit="3"
                :on-exceed="handleImageExceed"
                name="file"
                accept="image/*"
                list-type="picture-card"
                multiple
              >
                <el-icon class="avatar-uploader-icon"><Plus /></el-icon>
              </el-upload>
              <div class="upload-tip">
                <p>支持上传jpg、png、gif格式图片，单张图片不超过2MB，最多3张</p>
              </div>
            </div>
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
                <el-avatar 
                  :size="40" 
                  :src="comment.authorAvatar" 
                  :icon="UserFilled" 
                  class="comment-avatar"
                />
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
                  @click="showReplyForm(comment.id, comment.authorName)"
                  :icon="ChatLineRound"
                  :disabled="!checkLoginStatus()"
                >
                  {{ checkLoginStatus() ? '回复' : '登录后回复' }}
                </el-button>
                <el-button
                  v-if="canDeleteComment(comment)"
                  text
                  type="danger"
                  size="small"
                  @click="deleteComment(comment.id)"
                  :icon="Delete"
                >
                  删除
                </el-button>
              </div>
            </div>
            <div class="comment-text">{{ comment.content }}</div>
            
            <!-- 评论图片显示 -->
            <div v-if="comment.images && comment.images.length > 0" class="comment-images">
              <div class="image-grid">
                <el-image
                  v-for="(image, index) in comment.images"
                  :key="index"
                  :src="getImageUrl(image)"
                  :preview-src-list="comment.images.map(img => getImageUrl(img))"
                  :initial-index="index"
                  fit="cover"
                  class="comment-image"
                  preview-teleported
                />
              </div>
            </div>
            
            <!-- 回复表单 -->
            <div v-if="replyingTo === comment.id && !replyingToReplyId" class="reply-form">
              <el-card>
                <template #header>
                  <span>{{ replyToText }}</span>
                </template>
                <el-form :model="replyForm" :rules="replyRules" :ref="`replyForm_${comment.id}`" :data-reply-form="comment.id">
                  <el-form-item prop="content">
                    <el-input
                      v-model="replyForm.content"
                      type="textarea"
                      :rows="3"
                      :placeholder="replyPlaceholder"
                      maxlength="300"
                      show-word-limit
                    />
                  </el-form-item>
                  <!-- 回复图片上传 -->
                  <el-form-item label="图片">
                    <div class="image-upload-section">
                      <el-upload
                        :action="uploadUrl"
                        :headers="uploadHeaders"
                        :file-list="replyImageList"
                        :on-success="handleReplyImageSuccess"
                        :on-error="handleImageError"
                        :on-remove="handleReplyImageRemove"
                        :before-upload="beforeImageUpload"
                        :limit="3"
                        :on-exceed="handleImageExceed"
                        name="file"
                        accept="image/*"
                        list-type="picture-card"
                        multiple
                      >
                        <el-icon class="avatar-uploader-icon"><Plus /></el-icon>
                      </el-upload>
                      <div class="upload-tip">
                        <p>支持上传jpg、png、gif格式图片，单张图片不超过2MB，最多3张</p>
                      </div>
                    </div>
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
                v-for="reply in getVisibleReplies(comment.replies, comment.id)"
                :key="reply.id"
                class="reply-item"
              >
                <div class="reply-content">
                  <div class="reply-header">
                    <el-avatar 
                      :size="32" 
                      :src="reply.authorAvatar" 
                      :icon="UserFilled" 
                      class="reply-avatar"
                    />
                    <div class="reply-author-info">
                      <span class="reply-author-name">{{ reply.authorName }}</span>
                      <span v-if="reply.replyToName" class="reply-to-name">回复 {{ reply.replyToName }}</span>
                      <span class="reply-time">{{ formatDate(reply.createdAt) }}</span>
                    </div>
                  </div>
                  <div class="reply-text">{{ reply.content }}</div>
                  
                  <!-- 回复图片显示 -->
                  <div v-if="reply.images && reply.images.length > 0" class="reply-images">
                    <div class="image-grid">
                      <el-image
                        v-for="(image, index) in reply.images"
                        :key="index"
                        :src="getImageUrl(image)"
                        :preview-src-list="reply.images.map(img => getImageUrl(img))"
                        :initial-index="index"
                        fit="cover"
                        class="reply-image"
                        preview-teleported
                      />
                    </div>
                  </div>
                  
                  <div class="reply-actions">
                    <el-button
                      text
                      type="primary"
                      size="small"
                      @click="showReplyForm(comment.id, reply.authorName, reply.id)"
                      :icon="ChatLineRound"
                      :disabled="!checkLoginStatus()"
                    >
                      {{ checkLoginStatus() ? '回复' : '登录后回复' }}
                    </el-button>
                    <el-button
                      v-if="canDeleteComment(reply)"
                      text
                      type="danger"
                      size="small"
                      @click="deleteComment(reply.id)"
                      :icon="Delete"
                    >
                      删除
                    </el-button>
                  </div>
                  
                  <!-- 嵌套回复表单 -->
                  <div v-if="replyingTo === comment.id && replyingToReplyId === reply.id" class="nested-reply-form">
                    <el-card>
                      <template #header>
                        <span>{{ replyToText }}</span>
                      </template>
                      <el-form :model="replyForm" :rules="replyRules" :ref="`nestedReplyForm_${reply.id}`">
                        <el-form-item prop="content">
                          <el-input
                            v-model="replyForm.content"
                            type="textarea"
                            :rows="3"
                            :placeholder="replyPlaceholder"
                            maxlength="300"
                            show-word-limit
                          />
                        </el-form-item>
                        <!-- 嵌套回复图片上传 -->
                        <el-form-item label="图片">
                          <div class="image-upload-section">
                            <el-upload
                              :action="uploadUrl"
                              :headers="uploadHeaders"
                              :file-list="replyImageList"
                              :on-success="handleReplyImageSuccess"
                              :on-error="handleImageError"
                              :on-remove="handleReplyImageRemove"
                              :before-upload="beforeImageUpload"
                              :limit="3"
                              :on-exceed="handleImageExceed"
                              name="file"
                              accept="image/*"
                              list-type="picture-card"
                              multiple
                            >
                              <el-icon class="avatar-uploader-icon"><Plus /></el-icon>
                            </el-upload>
                            <div class="upload-tip">
                              <p>支持上传jpg、png、gif格式图片，单张图片不超过2MB，最多3张</p>
                            </div>
                          </div>
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
                </div>
              </div>
              
              <!-- 展开/折叠按钮 -->
              <div v-if="shouldShowToggleButton(comment.replies)" class="toggle-replies-btn">
                <el-button
                  text
                  type="primary"
                  size="small"
                  @click="toggleRepliesCollapse(comment.id)"
                  class="toggle-btn"
                >
                  {{ getToggleButtonText(comment.replies, comment.id) }}
                </el-button>
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
  ChatLineRound,
  Delete,
  Plus
} from '@element-plus/icons-vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import axios from 'axios'

// Props
const props = defineProps({
  blogId: {
    type: [String, Number],
    required: true
  },
  blogAuthorId: {
    type: Number,
    required: false
  }
})

// 响应式数据
const comments = ref([])
const commentCount = ref(0)
const loading = ref(false)
const submitting = ref(false)
const replySubmitting = ref(false)
const replyingTo = ref(null)
const replyingToReplyId = ref(null) // 新增：记录回复的是哪个回复
const replyToName = ref('') // 新增：记录回复的目标用户名
const replyToText = ref('') // 新增：回复表单标题文本
const replyPlaceholder = ref('') // 新增：回复输入框占位符
const collapsedReplies = ref(new Set()) // 新增：记录折叠状态的评论ID集合

// 图片上传相关
const commentImageList = ref([])
const replyImageList = ref([])
const uploadUrl = ref('/api/upload/image')
const uploadHeaders = ref({})

// 表单引用
const commentFormRef = ref()
const replyFormRef = ref()

// 评论表单
const commentForm = ref({
  content: '',
  images: []
})

// 回复表单
const replyForm = ref({
  content: '',
  images: []
})

// 自定义验证函数
const validateCommentContent = (rule, value, callback) => {
  const content = value ? value.trim() : ''
  const hasImages = commentForm.value.images && commentForm.value.images.length > 0
  
  if (!content && !hasImages) {
    callback(new Error('请输入评论内容或上传图片'))
  } else if (content && content.length > 500) {
    callback(new Error('评论内容不能超过 500 个字符'))
  } else {
    callback()
  }
}

const validateReplyContent = (rule, value, callback) => {
  const content = value ? value.trim() : ''
  const hasImages = replyForm.value.images && replyForm.value.images.length > 0
  
  if (!content && !hasImages) {
    callback(new Error('请输入回复内容或上传图片'))
  } else if (content && content.length > 300) {
    callback(new Error('回复内容不能超过 300 个字符'))
  } else {
    callback()
  }
}

// 表单验证规则
const commentRules = {
  content: [
    { validator: validateCommentContent, trigger: 'blur' }
  ]
}

const replyRules = {
  content: [
    { validator: validateReplyContent, trigger: 'blur' }
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
      // 处理评论作者头像路径和图片数据
      comments.value.forEach(comment => {
        if (comment.authorAvatar && !comment.authorAvatar.startsWith('http')) {
          comment.authorAvatar = `http://localhost:8080${comment.authorAvatar}`
        }
        // 解析评论图片JSON字符串
        if (comment.images && typeof comment.images === 'string') {
          try {
            comment.images = JSON.parse(comment.images)
          } catch (e) {
            console.warn('解析评论图片数据失败:', e)
            comment.images = []
          }
        } else if (!comment.images) {
          comment.images = []
        }
      })
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
        // 处理回复作者头像路径和图片数据
        comment.replies.forEach(reply => {
          if (reply.authorAvatar && !reply.authorAvatar.startsWith('http')) {
            reply.authorAvatar = `http://localhost:8080${reply.authorAvatar}`
          }
          // 解析回复图片JSON字符串
          if (reply.images && typeof reply.images === 'string') {
            try {
              reply.images = JSON.parse(reply.images)
            } catch (e) {
              console.warn('解析回复图片数据失败:', e)
              reply.images = []
            }
          } else if (!reply.images) {
            reply.images = []
          }
        })
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

// 跳转到登录页面
const goToLogin = () => {
  // 使用router进行页面跳转
  window.location.href = '/login'
}

// 提交评论
const submitComment = async () => {
  if (!commentFormRef.value) return
  
  // 检查登录状态
  if (!checkLoginStatus()) {
    ElMessage.warning('请先登录后再发表评论')
    goToLogin()
    return
  }
  
  try {
    await commentFormRef.value.validate()
    
    submitting.value = true
    
    // 获取用户ID
    let userId = null
    const token = localStorage.getItem('userToken') || localStorage.getItem('adminToken')
    if (token) {
      if (token.startsWith('token_')) {
        // 真实token格式: token_userId_timestamp
        const parts = token.split('_')
        if (parts.length >= 3) {
          // 再次验证token是否过期
          const timestamp = parseInt(parts[2])
          const currentTime = Date.now()
          const tokenExpiry = 24 * 60 * 60 * 1000 // 24小时
          if (currentTime - timestamp > tokenExpiry) {
            ElMessage.error('登录已过期，请重新登录')
            localStorage.removeItem('userToken')
            localStorage.removeItem('adminToken')
            goToLogin()
            return
          }
          userId = parseInt(parts[1])
        }
      } else {
        // 模拟token或其他格式，尝试从后端获取用户信息
        try {
          const userResponse = await axios.get('/api/auth/profile', {
            headers: { Authorization: `Bearer ${token}` }
          })
          if (userResponse.data && userResponse.data.id) {
            userId = userResponse.data.id
          }
        } catch (error) {
          console.warn('无法从token获取用户信息:', error)
          ElMessage.error('登录状态异常，请重新登录')
          goToLogin()
          return
        }
      }
    }
    
    const requestData = {
      blogId: props.blogId,
      content: commentForm.value.content,
      images: JSON.stringify(commentForm.value.images)
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
  // 检查登录状态
  if (!checkLoginStatus()) {
    ElMessage.warning('请先登录后再回复评论')
    goToLogin()
    return
  }
  
  // 检查是否正在回复该评论
  if (replyingTo.value !== parentId) {
    ElMessage.error('表单未准备就绪，请重试')
    return
  }
  
  // 等待DOM更新，确保表单已渲染
  await nextTick()
  
  try {
    // 验证回复内容或图片
    const content = replyForm.value.content ? replyForm.value.content.trim() : ''
    const hasImages = replyForm.value.images && replyForm.value.images.length > 0
    
    if (!content && !hasImages) {
      ElMessage.error('请输入回复内容或上传图片')
      return
    }
    
    if (content && content.length > 300) {
      ElMessage.error('回复内容不能超过300个字符')
      return
    }
    
    replySubmitting.value = true
    
    // 获取用户ID
    let userId = null
    const token = localStorage.getItem('userToken') || localStorage.getItem('adminToken')
    if (token) {
      if (token.startsWith('token_')) {
        // 真实token格式: token_userId_timestamp
        const parts = token.split('_')
        if (parts.length >= 3) {
          // 再次验证token是否过期
          const timestamp = parseInt(parts[2])
          const currentTime = Date.now()
          const tokenExpiry = 24 * 60 * 60 * 1000 // 24小时
          if (currentTime - timestamp > tokenExpiry) {
            ElMessage.error('登录已过期，请重新登录')
            localStorage.removeItem('userToken')
            localStorage.removeItem('adminToken')
            goToLogin()
            return
          }
          userId = parseInt(parts[1])
        }
      } else {
        // 模拟token或其他格式，尝试从后端获取用户信息
        try {
          const userResponse = await axios.get('/api/auth/profile', {
            headers: { Authorization: `Bearer ${token}` }
          })
          if (userResponse.data && userResponse.data.id) {
            userId = userResponse.data.id
          }
        } catch (error) {
          console.warn('无法从token获取用户信息:', error)
          ElMessage.error('登录状态异常，请重新登录')
          goToLogin()
          return
        }
      }
    }
    
    const requestData = {
      blogId: props.blogId,
      parentId: parentId,
      content: replyForm.value.content,
      images: JSON.stringify(replyForm.value.images)
    }
    
    if (userId) {
      requestData.userId = userId
    }
    
    // 添加被回复的用户名
    if (replyToName.value) {
      requestData.replyToName = replyToName.value
    }
    
    const response = await axios.post('/api/comments/reply', requestData)
    
    if (response.data && response.data.success) {
      ElMessage.success('回复发布成功！')
      replyForm.value = {
        content: '',
        images: []
      }
      replyImageList.value = []
      replyingTo.value = null
      replyingToReplyId.value = null
      replyToName.value = ''
      
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

// 显示回复表单 - 修改为支持多级回复
const showReplyForm = async (commentId, targetUserName, replyId = null) => {
  // 检查登录状态
  if (!checkLoginStatus()) {
    ElMessage.warning('请先登录后再回复评论')
    return
  }
  
  replyingTo.value = commentId
  replyingToReplyId.value = replyId
  replyToName.value = targetUserName
  
  // 设置回复表单的文本
  if (replyId) {
    // 回复某个回复
    replyToText.value = `回复 @${targetUserName}`
    replyPlaceholder.value = `回复 @${targetUserName}...`
  } else {
    // 回复评论
    replyToText.value = `回复 ${targetUserName}`
    replyPlaceholder.value = `回复 ${targetUserName}...`
  }
  
  // 清空回复表单
  replyForm.value = {
    content: '',
    images: []
  }
  replyImageList.value = []
  
  // 等待 DOM 更新完成，确保表单引用正确绑定
  await nextTick()
}

// 取消回复
const cancelReply = () => {
  replyingTo.value = null
  replyingToReplyId.value = null
  replyToName.value = ''
  replyForm.value = {
    content: '',
    images: []
  }
  replyImageList.value = []
}

// 重置评论表单
const resetForm = () => {
  commentForm.value = {
    content: '',
    images: []
  }
  commentImageList.value = []
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

// 检查是否可以删除评论
const canDeleteComment = (comment) => {
  if (!checkLoginStatus()) {
    return false
  }
  
  // 获取当前用户ID
  let currentUserId = null
  const token = localStorage.getItem('userToken') || localStorage.getItem('adminToken')
  if (token && token.startsWith('token_')) {
    const parts = token.split('_')
    if (parts.length >= 3) {
      currentUserId = parseInt(parts[1])
    }
  }
  
  if (!currentUserId) {
    return false
  }
  
  // 用户可以删除自己的评论
  if (comment.userId === currentUserId) {
    return true
  }
  
  // 文章作者可以删除任何评论（需要从props或其他地方获取文章作者信息）
  if (props.blogAuthorId && props.blogAuthorId === currentUserId) {
    return true
  }
  
  return false
}

// 删除评论
const deleteComment = async (commentId) => {
  try {
    await ElMessageBox.confirm(
      '确定要删除这条评论吗？删除后无法恢复。',
      '确认删除',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      }
    )
    
    // 获取token并设置Authorization头
    const userToken = localStorage.getItem('userToken')
    const adminToken = localStorage.getItem('adminToken')
    const token = userToken || adminToken
    
    const config = {}
    if (token) {
      config.headers = {
        'Authorization': `Bearer ${token}`
      }
    }
    
    const response = await axios.delete(`/api/comments/${commentId}`, config)
    
    if (response.data && response.data.success) {
      ElMessage.success('评论删除成功')
      // 重新获取评论列表
      await fetchComments()
      await fetchCommentCount()
    } else {
      ElMessage.error('删除失败：' + (response.data.message || '未知错误'))
    }
  } catch (error) {
    if (error === 'cancel') {
      // 用户取消删除
      return
    }
    console.error('删除评论失败:', error)
    if (error.response && error.response.data && error.response.data.message) {
      ElMessage.error('删除失败：' + error.response.data.message)
    } else {
      ElMessage.error('删除评论失败，请稍后重试')
    }
  }
}

// 切换回复折叠状态
const toggleRepliesCollapse = (commentId) => {
  const collapsed = collapsedReplies.value
  if (collapsed.has(commentId)) {
    collapsed.delete(commentId)
  } else {
    collapsed.add(commentId)
  }
}

// 获取显示的回复列表
const getVisibleReplies = (replies, commentId) => {
  if (!replies || replies.length === 0) return []
  
  const isCollapsed = collapsedReplies.value.has(commentId)
  if (isCollapsed || replies.length <= 3) {
    return replies
  }
  
  return replies.slice(0, 3)
}

// 检查是否需要显示展开/折叠按钮
const shouldShowToggleButton = (replies) => {
  return replies && replies.length > 3
}

// 获取折叠按钮文本
const getToggleButtonText = (replies, commentId) => {
  if (!replies || replies.length <= 3) return ''
  
  const isCollapsed = collapsedReplies.value.has(commentId)
  const hiddenCount = replies.length - 3
  
  return isCollapsed ? `展开全部 ${replies.length} 条回复` : `收起 ${hiddenCount} 条回复`
}

// 图片上传相关方法
const updateUploadHeaders = () => {
  const userToken = localStorage.getItem('userToken')
  const adminToken = localStorage.getItem('adminToken')
  const token = userToken || adminToken
  
  if (token) {
    uploadHeaders.value = {
      'Authorization': `Bearer ${token}`
    }
  }
}

// 上传前检查
const beforeImageUpload = (file) => {
  const isImage = file.type.startsWith('image/')
  const isLt2M = file.size / 1024 / 1024 < 2
  
  if (!isImage) {
    ElMessage.error('只能上传图片文件!')
    return false
  }
  if (!isLt2M) {
    ElMessage.error('图片大小不能超过 2MB!')
    return false
  }
  
  updateUploadHeaders()
  return true
}

// 评论图片上传成功
const handleCommentImageSuccess = (response, file) => {
  if (response && response.success && response.url) {
    commentForm.value.images.push(response.url)
    ElMessage.success('图片上传成功')
    // 触发表单验证以更新验证状态
    nextTick(() => {
      if (commentFormRef.value) {
        commentFormRef.value.validateField('content')
      }
    })
  } else {
    ElMessage.error('图片上传失败')
  }
}

// 回复图片上传成功
const handleReplyImageSuccess = (response, file) => {
  if (response && response.success && response.url) {
    replyForm.value.images.push(response.url)
    ElMessage.success('图片上传成功')
    // 触发表单验证以更新验证状态
    nextTick(() => {
      if (replyFormRef.value) {
        replyFormRef.value.validateField('content')
      }
    })
  } else {
    ElMessage.error('图片上传失败')
  }
}

// 图片上传失败
const handleImageError = (error) => {
  console.error('图片上传失败:', error)
  ElMessage.error('图片上传失败，请重试')
}

// 移除评论图片
const handleCommentImageRemove = (file) => {
  const index = commentImageList.value.findIndex(item => item.uid === file.uid)
  if (index > -1) {
    commentForm.value.images.splice(index, 1)
    // 触发表单验证以更新验证状态
    nextTick(() => {
      if (commentFormRef.value) {
        commentFormRef.value.validateField('content')
      }
    })
  }
}

// 移除回复图片
const handleReplyImageRemove = (file) => {
  const index = replyImageList.value.findIndex(item => item.uid === file.uid)
  if (index > -1) {
    replyForm.value.images.splice(index, 1)
    // 触发表单验证以更新验证状态
    nextTick(() => {
      if (replyFormRef.value) {
        replyFormRef.value.validateField('content')
      }
    })
  }
}

// 超出图片数量限制
const handleImageExceed = () => {
  ElMessage.warning('最多只能上传3张图片')
}

// 获取图片URL
const getImageUrl = (imagePath) => {
  if (!imagePath) return ''
  if (imagePath.startsWith('http')) {
    return imagePath
  }
  return `http://localhost:8080${imagePath}`
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

.comment-avatar {
  flex-shrink: 0;
  border: 2px solid #f0f0f0;
}

.reply-avatar {
  flex-shrink: 0;
  border: 1px solid #e0e0e0;
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
  align-items: center;
  gap: 0.5rem;
  flex-wrap: wrap;
}

.reply-author-name {
  font-weight: 600;
  color: #333;
  font-size: 0.9rem;
}

.reply-to-name {
  color: #1890ff;
  font-size: 0.85rem;
  font-weight: 500;
  background: #f0f8ff;
  padding: 2px 6px;
  border-radius: 4px;
  border: 1px solid #e6f4ff;
}

.reply-time {
  color: #666;
  font-size: 0.75rem;
  margin-left: auto;
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

.reply-actions {
  display: flex;
  gap: 0.5rem;
  margin-top: 0.5rem;
  justify-content: flex-end;
}

.nested-reply-form {
  margin-top: 1rem;
  margin-left: 1rem;
  border-left: 2px solid #d9d9d9;
  padding-left: 1rem;
}

.toggle-replies-btn {
  margin-top: 0.5rem;
  text-align: center;
  padding: 0.5rem 0;
}

.toggle-btn {
  font-size: 0.875rem;
  color: #1890ff;
  transition: all 0.3s ease;
}

.toggle-btn:hover {
  background-color: #f0f8ff;
  border-radius: 4px;
}

/* 图片上传样式 */
.image-upload-section {
  width: 100%;
}

.upload-tip {
  margin-top: 8px;
}

.upload-tip p {
  margin: 0;
  font-size: 12px;
  color: #999;
  line-height: 1.4;
}

.avatar-uploader-icon {
  font-size: 28px;
  color: #8c939d;
  width: 100%;
  height: 100%;
  text-align: center;
  display: flex;
  align-items: center;
  justify-content: center;
}

/* 评论图片显示样式 */
.comment-images {
  margin: 1rem 0;
}

.reply-images {
  margin: 0.5rem 0;
}

.image-grid {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.comment-image {
  width: 120px;
  height: 120px;
  border-radius: 8px;
  cursor: pointer;
  transition: transform 0.3s ease;
}

.comment-image:hover {
  transform: scale(1.05);
}

.reply-image {
  width: 80px;
  height: 80px;
  border-radius: 6px;
  cursor: pointer;
  transition: transform 0.3s ease;
}

.reply-image:hover {
  transform: scale(1.05);
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
  
  .nested-reply-form {
    margin-left: 0.5rem;
  }
  
  .comment-title {
    font-size: 1.3rem;
  }
  
  .comment-image {
    width: 80px;
    height: 80px;
  }
  
  .reply-image {
    width: 60px;
    height: 60px;
  }
  
  .image-grid {
    gap: 6px;
  }
}
</style>