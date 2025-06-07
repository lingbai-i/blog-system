<template>
  <div class="tag-management">
    <div class="section-header">
      <h2 class="section-title">标签管理</h2>
      <el-button type="primary" @click="showCreateDialog" :icon="Plus">
        新建标签
      </el-button>
    </div>

    <!-- 搜索和筛选 -->
    <div class="search-filters">
      <div class="search-row">
        <div class="search-group">
          <el-input
            v-model="searchKeyword" 
            placeholder="搜索标签名称或描述..."
            class="search-input"
            @keyup.enter="searchTags"
            clearable
            :prefix-icon="Search"
          >
          </el-input>
          <el-button type="primary" @click="searchTags" :icon="Search">
            搜索
          </el-button>
        </div>
        
        <div class="filter-group">
          <el-select
            v-model="statusFilter"
            placeholder="状态筛选"
            clearable
            @change="searchTags"
            class="filter-select"
          >
            <el-option label="全部状态" value="" />
            <el-option label="激活" value="true" />
            <el-option label="禁用" value="false" />
          </el-select>
          
          <el-select
            v-model="sortBy"
            placeholder="排序方式"
            @change="searchTags"
            class="filter-select"
          >
            <el-option label="默认排序" value="" />
            <el-option label="使用频率（高到低）" value="usage_desc" />
            <el-option label="使用频率（低到高）" value="usage_asc" />
            <el-option label="创建时间" value="created_desc" />
          </el-select>
        </div>
      </div>
    </div>

    <!-- 标签列表 -->
    <div class="tag-table">
      <el-table
        :data="tags"
        v-loading="loading"
        stripe
        style="width: 100%"
      >
        <el-table-column prop="id" label="ID" width="80" />
        
        <el-table-column prop="name" label="名称" min-width="150" />
        
        <el-table-column prop="slug" label="别名" width="150" />
        
        <el-table-column prop="description" label="描述" min-width="200">
          <template #default="{ row }">
            {{ row.description || '无描述' }}
          </template>
        </el-table-column>
        
        <el-table-column prop="blogCount" label="文章数" width="100">
          <template #default="{ row }">
            {{ row.blogCount || 0 }}
          </template>
        </el-table-column>
        
        <el-table-column prop="usageFrequency" label="使用频率" width="120" sortable>
          <template #default="{ row }">
            <div class="usage-frequency">
              <el-progress 
                :percentage="getUsagePercentage(row.blogCount)" 
                :stroke-width="8"
                :show-text="false"
                :color="getUsageColor(row.blogCount)"
              />
              <span class="usage-text">{{ row.blogCount || 0 }}次</span>
            </div>
          </template>
        </el-table-column>
        
        <el-table-column prop="isActive" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.isActive ? 'success' : 'info'">
              {{ row.isActive ? '激活' : '禁用' }}
            </el-tag>
          </template>
        </el-table-column>
        
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="{ row }">
            <div class="action-buttons">

              <el-button 
                size="small" 
                :type="row.isActive ? 'warning' : 'success'" 
                @click="toggleTagStatus(row)"
                :icon="row.isActive ? 'Close' : 'Check'"
              >
                {{ row.isActive ? '禁用' : '激活' }}
              </el-button>
              <el-button 
                size="small" 
                type="danger" 
                @click="deleteTag(row)" 
                :icon="Delete"
              >
                删除
              </el-button>
            </div>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <!-- 分页 -->
    <div class="pagination">
      <el-pagination
        v-model:current-page="currentPage"
        v-model:page-size="pageSize"
        :total="total"
        :page-sizes="[10, 20, 50, 100]"
        layout="total, sizes, prev, pager, next, jumper"
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
      />
    </div>

    <!-- 创建/编辑标签对话框 -->
    <el-dialog
      v-model="dialogVisible"
      title="新建标签"
      width="500px"
      :before-close="handleDialogClose"
    >
      <el-form
        ref="tagFormRef"
        :model="tagForm"
        :rules="tagRules"
        label-width="80px"
      >
        <el-form-item label="名称" prop="name">
          <el-input v-model="tagForm.name" placeholder="请输入标签名称" />
        </el-form-item>
        
        <el-form-item label="别名" prop="slug">
          <el-input v-model="tagForm.slug" placeholder="请输入标签别名（用于URL）" />
        </el-form-item>
        
        <el-form-item label="描述" prop="description">
          <el-input
            v-model="tagForm.description"
            type="textarea"
            :rows="3"
            placeholder="请输入标签描述"
          />
        </el-form-item>
        

        
        <el-form-item label="状态" prop="isActive">
          <el-switch
            v-model="tagForm.isActive"
            :active-text="'激活'"
            :inactive-text="'禁用'"
          />
        </el-form-item>
      </el-form>
      
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button type="primary" @click="saveTag" :loading="saving">
            {{ saving ? '保存中...' : '保存' }}
          </el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import {
  Plus, Search, Delete, Check, Close, Refresh
} from '@element-plus/icons-vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import axios from 'axios'

// 响应式数据
const tags = ref([])
const loading = ref(false)
const searchKeyword = ref('')
const statusFilter = ref('')
const sortBy = ref('')
const currentPage = ref(1)
const pageSize = ref(10)
const total = ref(0)
const maxUsageCount = ref(0)

// 对话框相关
const dialogVisible = ref(false)
const saving = ref(false)
const tagFormRef = ref()

const tagForm = reactive({
  name: '',
  slug: '',
  description: '',
  isActive: true
})

const tagRules = {
  name: [
    { required: true, message: '请输入标签名称', trigger: 'blur' },
    { min: 1, max: 50, message: '名称长度在 1 到 50 个字符', trigger: 'blur' }
  ],
  slug: [
    { required: true, message: '请输入标签别名', trigger: 'blur' },
    { min: 1, max: 50, message: '别名长度在 1 到 50 个字符', trigger: 'blur' },
    { pattern: /^[a-z0-9-]+$/, message: '别名只能包含小写字母、数字和连字符', trigger: 'blur' }
  ],
  description: [
    { max: 200, message: '描述长度不能超过 200 个字符', trigger: 'blur' }
  ]
}

// 获取标签列表
const fetchTags = async () => {
  loading.value = true
  try {
    let url = '/api/tags'
    let params = {
      page: currentPage.value - 1,
      size: pageSize.value
    }
    
    // 添加排序参数
    if (sortBy.value) {
      params.sort = sortBy.value
    }
    
    // 优先级：搜索关键词 > 状态筛选 > 全部
    if (searchKeyword.value) {
      // 如果有搜索关键词，使用搜索接口
      url = '/api/tags/search'
      params.keyword = searchKeyword.value
      // 如果同时有状态筛选，添加状态参数
      if (statusFilter.value !== '') {
        params.isActive = statusFilter.value === 'true'
      }
    } else if (statusFilter.value !== '') {
      // 如果只有状态筛选，使用状态筛选接口
      const isActiveValue = statusFilter.value === 'true'
      url = `/api/tags/status/${isActiveValue}`
    }
    // 否则使用默认的全部标签接口
    
    const response = await axios.get(url, { params })
    tags.value = response.data.content
    total.value = response.data.totalElements
    
    // 计算最大使用次数，用于进度条显示
    if (tags.value.length > 0) {
      maxUsageCount.value = Math.max(...tags.value.map(tag => tag.blogCount || 0))
    }
  } catch (error) {
    console.error('获取标签列表失败:', error)
    ElMessage.error('获取标签列表失败，请稍后重试')
    tags.value = []
    total.value = 0
    maxUsageCount.value = 0
  } finally {
    loading.value = false
  }
}

// 搜索标签
const searchTags = () => {
  currentPage.value = 1
  fetchTags()
}

// 重置筛选条件
const resetFilters = () => {
  searchKeyword.value = ''
  statusFilter.value = ''
  currentPage.value = 1
  fetchTags()
}

// 处理分页大小变化
const handleSizeChange = (size) => {
  pageSize.value = size
  fetchTags()
}

// 处理页码变化
const handleCurrentChange = (page) => {
  currentPage.value = page
  fetchTags()
}

// 显示创建对话框
const showCreateDialog = () => {
  resetTagForm()
  dialogVisible.value = true
}

// 保存标签
const saveTag = async () => {
  await tagFormRef.value.validate(async (valid) => {
    if (!valid) return
    
    saving.value = true
    try {
      // 创建标签
      const response = await axios.post('/api/tags', tagForm)
      ElMessage.success('标签创建成功')
      
      dialogVisible.value = false
      fetchTags()
    } catch (error) {
      console.error('保存标签失败:', error)
      ElMessage.error(error.response?.data?.error || '保存标签失败，请稍后重试')
    } finally {
      saving.value = false
    }
  })
}

// 切换标签状态
const toggleTagStatus = async (tag) => {
  try {
    const updatedTag = { ...tag, isActive: !tag.isActive }
    await axios.put(`/api/tags/${tag.id}`, updatedTag)
    ElMessage.success(`标签已${updatedTag.isActive ? '激活' : '禁用'}`)
    fetchTags()
  } catch (error) {
    console.error('更新标签状态失败:', error)
    ElMessage.error('更新标签状态失败，请稍后重试')
  }
}

// 删除标签
const deleteTag = (tag) => {
  ElMessageBox.confirm(
    `确定要删除标签 "${tag.name}" 吗？此操作不可逆。`,
    '删除确认',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }
  ).then(async () => {
    try {
      await axios.delete(`/api/tags/${tag.id}`)
      ElMessage.success('标签删除成功')
      fetchTags()
    } catch (error) {
      console.error('删除标签失败:', error)
      ElMessage.error(error.response?.data?.error || '删除标签失败，请稍后重试')
    }
  }).catch(() => {
    // 用户取消删除
  })
}

// 重置表单
const resetTagForm = () => {
  tagForm.name = ''
  tagForm.slug = ''
  tagForm.description = ''
  tagForm.isActive = true
  
  if (tagFormRef.value) {
    tagFormRef.value.resetFields()
  }
}

// 对话框关闭前的处理
const handleDialogClose = (done) => {
  if (saving.value) return
  done()
}

// 计算使用频率百分比
const getUsagePercentage = (count) => {
  if (!maxUsageCount.value || maxUsageCount.value === 0) return 0
  return Math.round((count || 0) / maxUsageCount.value * 100)
}

// 根据使用频率获取颜色
const getUsageColor = (count) => {
  const percentage = getUsagePercentage(count)
  if (percentage >= 80) return '#67c23a' // 绿色 - 高频使用
  if (percentage >= 50) return '#e6a23c' // 橙色 - 中频使用
  if (percentage >= 20) return '#409eff' // 蓝色 - 低频使用
  return '#f56c6c' // 红色 - 很少使用
}

// 生命周期钩子
onMounted(() => {
  fetchTags()
})
</script>

<style scoped>
.tag-management {
  margin-bottom: 2rem;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1rem;
}

.section-title {
  font-size: 1.5rem;
  font-weight: 600;
  color: #303133;
}

.search-filters {
  margin-bottom: 1.5rem;
  padding: 1rem;
  background: #f8f9fa;
  border-radius: 8px;
  border: 1px solid #e9ecef;
}

.search-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 1rem;
  flex-wrap: wrap;
}

.search-group {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  flex: 1;
  min-width: 300px;
}

.search-input {
  flex: 1;
  max-width: 400px;
}

.filter-group {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.status-filter {
  width: 120px;
}

.reset-btn {
  color: #6c757d;
}

@media (max-width: 768px) {
  .search-row {
    flex-direction: column;
    align-items: stretch;
  }
  
  .search-group {
    min-width: auto;
  }
  
  .filter-group {
    justify-content: center;
  }
}

.tag-table {
  margin-bottom: 1rem;
}

.tag-name-cell {
  display: flex;
  align-items: center;
}

.custom-tag {
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 14px;
  color: #333;
}

.action-buttons {
  display: flex;
  gap: 8px;
}

.pagination {
  margin-top: 1rem;
  display: flex;
  justify-content: flex-end;
}

.usage-frequency {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 4px;
}

.usage-text {
  font-size: 12px;
  color: #606266;
  font-weight: 500;
}

.filter-select {
  min-width: 120px;
}

.filter-group {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}
</style>