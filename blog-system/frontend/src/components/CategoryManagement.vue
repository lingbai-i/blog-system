<template>
  <div class="category-management">
    <div class="section-header">
      <h2 class="section-title">分类管理</h2>
      <el-button type="primary" @click="showCreateDialog" :icon="Plus">
        新建分类
      </el-button>
    </div>

    <!-- 搜索和筛选 -->
    <div class="search-filters">
      <div class="search-row">
        <div class="search-group">
          <el-input
            v-model="searchKeyword"
            placeholder="搜索分类名称或描述..."
            class="search-input"
            @keyup.enter="searchCategories"
            clearable
            :prefix-icon="Search"
          >
          </el-input>
          <el-button type="primary" @click="searchCategories" :icon="Search">
            搜索
          </el-button>
        </div>
        
        <div class="filter-group">
          <el-select 
            v-model="statusFilter" 
            placeholder="状态筛选" 
            clearable 
            @change="fetchCategories"
            class="status-filter"
          >
            <el-option label="全部状态" value="" />
            <el-option label="激活" value="true" />
            <el-option label="禁用" value="false" />
          </el-select>
          
          <el-button 
            @click="resetFilters" 
            :icon="Refresh"
            class="reset-btn"
          >
            重置
          </el-button>
        </div>
      </div>
    </div>

    <!-- 分类列表 -->
    <div class="category-table">
      <el-table
        :data="categories"
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
                @click="toggleCategoryStatus(row)"
                :icon="row.isActive ? 'Close' : 'Check'"
              >
                {{ row.isActive ? '禁用' : '激活' }}
              </el-button>
              <el-button 
                size="small" 
                type="danger" 
                @click="deleteCategory(row)" 
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

    <!-- 创建/编辑分类对话框 -->
    <el-dialog
      v-model="dialogVisible"
      title="新建分类"
      width="500px"
      :before-close="handleDialogClose"
    >
      <el-form
        ref="categoryFormRef"
        :model="categoryForm"
        :rules="categoryRules"
        label-width="80px"
      >
        <el-form-item label="名称" prop="name">
          <el-input v-model="categoryForm.name" placeholder="请输入分类名称" />
        </el-form-item>
        
        <el-form-item label="别名" prop="slug">
          <el-input v-model="categoryForm.slug" placeholder="请输入分类别名（用于URL）" />
        </el-form-item>
        
        <el-form-item label="描述" prop="description">
          <el-input
            v-model="categoryForm.description"
            type="textarea"
            :rows="3"
            placeholder="请输入分类描述"
          />
        </el-form-item>
        

        
        <el-form-item label="状态" prop="isActive">
          <el-switch
            v-model="categoryForm.isActive"
            :active-text="'激活'"
            :inactive-text="'禁用'"
          />
        </el-form-item>
      </el-form>
      
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button type="primary" @click="saveCategory" :loading="saving">
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
const categories = ref([])
const loading = ref(false)
const searchKeyword = ref('')
const statusFilter = ref('')
const currentPage = ref(1)
const pageSize = ref(10)
const total = ref(0)

// 对话框相关
const dialogVisible = ref(false)

const saving = ref(false)
const categoryFormRef = ref()

const categoryForm = reactive({
  name: '',
  slug: '',
  description: '',
  isActive: true
})

const categoryRules = {
  name: [
    { required: true, message: '请输入分类名称', trigger: 'blur' },
    { min: 1, max: 100, message: '名称长度在 1 到 100 个字符', trigger: 'blur' }
  ],
  slug: [
    { required: true, message: '请输入分类别名', trigger: 'blur' },
    { min: 1, max: 50, message: '别名长度在 1 到 50 个字符', trigger: 'blur' },
    { pattern: /^[a-z0-9-]+$/, message: '别名只能包含小写字母、数字和连字符', trigger: 'blur' }
  ],
  description: [
    { max: 500, message: '描述长度不能超过 500 个字符', trigger: 'blur' }
  ]
}

// 获取分类列表
const fetchCategories = async () => {
  loading.value = true
  try {
    let url = '/api/categories/paged'
    let params = {
      page: currentPage.value - 1,
      size: pageSize.value
    }
    
    // 优先级：搜索关键词 > 状态筛选 > 全部
    if (searchKeyword.value) {
      // 如果有搜索关键词，使用搜索接口
      url = '/api/categories/search'
      params.keyword = searchKeyword.value
      // 如果同时有状态筛选，添加状态参数
      if (statusFilter.value !== '') {
        params.isActive = statusFilter.value
      }
    } else if (statusFilter.value !== '') {
      // 如果只有状态筛选，使用状态筛选接口
      url = `/api/categories/status/${statusFilter.value}`
    }
    // 否则使用默认的分页接口
    
    const response = await axios.get(url, { params })
    categories.value = response.data.content
    total.value = response.data.totalElements
  } catch (error) {
    console.error('获取分类列表失败:', error)
    ElMessage.error('获取分类列表失败，请稍后重试')
    // 使用模拟数据
    categories.value = getMockCategories()
    total.value = categories.value.length
  } finally {
    loading.value = false
  }
}

// 搜索分类
const searchCategories = () => {
  currentPage.value = 1
  fetchCategories()
}

// 重置筛选条件
const resetFilters = () => {
  searchKeyword.value = ''
  statusFilter.value = ''
  currentPage.value = 1
  fetchCategories()
}

// 处理分页大小变化
const handleSizeChange = (size) => {
  pageSize.value = size
  fetchCategories()
}

// 处理页码变化
const handleCurrentChange = (page) => {
  currentPage.value = page
  fetchCategories()
}

// 显示创建对话框
const showCreateDialog = () => {
  resetCategoryForm()
  dialogVisible.value = true
}

// 保存分类
const saveCategory = async () => {
  await categoryFormRef.value.validate(async (valid) => {
    if (!valid) return
    
    saving.value = true
    try {
      let response
      // 创建分类
      response = await axios.post('/api/categories', categoryForm)
      ElMessage.success('分类创建成功')
      
      dialogVisible.value = false
      fetchCategories()
    } catch (error) {
      console.error('保存分类失败:', error)
      ElMessage.error(error.response?.data?.error || '保存分类失败，请稍后重试')
    } finally {
      saving.value = false
    }
  })
}

// 切换分类状态
const toggleCategoryStatus = async (category) => {
  try {
    const updatedCategory = { ...category, isActive: !category.isActive }
    await axios.put(`/api/categories/${category.id}`, updatedCategory)
    ElMessage.success(`分类已${updatedCategory.isActive ? '激活' : '禁用'}`)
    fetchCategories()
  } catch (error) {
    console.error('更新分类状态失败:', error)
    ElMessage.error('更新分类状态失败，请稍后重试')
  }
}

// 删除分类
const deleteCategory = (category) => {
  ElMessageBox.confirm(
    `确定要删除分类 "${category.name}" 吗？此操作不可逆。`,
    '删除确认',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }
  ).then(async () => {
    try {
      await axios.delete(`/api/categories/${category.id}`)
      ElMessage.success('分类删除成功')
      fetchCategories()
    } catch (error) {
      console.error('删除分类失败:', error)
      ElMessage.error(error.response?.data?.error || '删除分类失败，请稍后重试')
    }
  }).catch(() => {
    // 用户取消删除
  })
}

// 重置表单
const resetCategoryForm = () => {
  categoryForm.name = ''
  categoryForm.slug = ''
  categoryForm.description = ''
  categoryForm.isActive = true
  
  if (categoryFormRef.value) {
    categoryFormRef.value.resetFields()
  }
}

// 对话框关闭前的处理
const handleDialogClose = (done) => {
  if (saving.value) return
  done()
}

// 模拟数据
const getMockCategories = () => {
  return [
    {
      id: 1,
      name: '技术分享',
      slug: 'tech-sharing',
      description: '分享各种技术知识和经验',
      colorCode: '#409EFF',
      isActive: true,
      blogCount: 15,
      createdAt: '2024-01-01T12:00:00',
      updatedAt: '2024-01-15T14:30:00'
    },
    {
      id: 2,
      name: '学习笔记',
      slug: 'study-notes',
      description: '记录学习过程中的笔记和心得',
      colorCode: '#67C23A',
      isActive: true,
      blogCount: 8,
      createdAt: '2024-01-02T10:00:00',
      updatedAt: '2024-01-10T16:20:00'
    },
    {
      id: 3,
      name: '项目实战',
      slug: 'project-practice',
      description: '实际项目开发中的经验和案例分析',
      colorCode: '#E6A23C',
      isActive: true,
      blogCount: 5,
      createdAt: '2024-01-03T09:30:00',
      updatedAt: '2024-01-12T11:45:00'
    }
  ]
}

// 生命周期钩子
onMounted(() => {
  fetchCategories()
})
</script>

<style scoped>
.category-management {
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

.category-table {
  margin-bottom: 1rem;
}

.category-name-cell {
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
</style>