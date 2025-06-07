<template>
  <div class="articles-page">
    <!-- 头部导航 -->
    <header class="header">
      <div class="container">
        <div class="header-content">
          <h1 class="logo" @click="goHome">个人博客</h1>
          <nav class="nav">
            <router-link to="/" class="nav-link">首页</router-link>
            <router-link to="/articles" class="nav-link active">文章</router-link>
          </nav>
        </div>
      </div>
    </header>

    <!-- 主要内容 -->
    <main class="main">
      <div class="container">
        <!-- 搜索和筛选区域 -->
        <div class="search-section">
          <div class="search-header">
            <h1>文章浏览</h1>
            <div class="search-stats-inline">
              <el-icon><TrendCharts /></el-icon>
              <span>{{ total }} 篇文章</span>
            </div>
          </div>
          
          <!-- 搜索框 -->
          <div class="search-form">
            <el-input
              v-model="searchKeyword"
              placeholder="输入关键字搜索文章..."
              class="search-input"
              size="large"
              @keyup.enter="handleKeywordEnter"
              @input="handleSearch"
              clearable
            >
              <template #prefix>
                <el-icon class="search-icon"><Search /></el-icon>
              </template>
            </el-input>
          </div>

          <!-- 筛选和排序选项 -->
          <div class="filter-options">
            <div class="filter-group">
              <label class="filter-label">
                <el-icon><Folder /></el-icon>
                分类筛选
              </label>
              <el-select
                v-model="categoryFilter"
                placeholder="全部分类"
                clearable
                @change="handleSearch"
                class="filter-select category-select"
                size="large"
              >
                <el-option label="全部分类" value="">
                  <span class="option-content">
                    <el-icon><Folder /></el-icon>
                    全部分类
                  </span>
                </el-option>
                <el-option
                  v-for="category in categories"
                  :key="category.id || category"
                  :label="category.name || category"
                  :value="category.name || category"
                >
                  <span class="option-content">
                    <el-icon><Folder /></el-icon>
                    {{ category.name || category }}
                  </span>
                </el-option>
              </el-select>
            </div>

            <div class="filter-group">
              <label class="filter-label">
                <el-icon><Star /></el-icon>
                标签筛选
              </label>
              <el-select
                v-model="tagFilter"
                placeholder="全部标签"
                clearable
                @change="handleSearch"
                class="filter-select tag-select"
                size="large"
              >
                <el-option label="全部标签" value="">
                  <span class="option-content">
                    <el-icon><Star /></el-icon>
                    全部标签
                  </span>
                </el-option>
                <el-option
                  v-for="tag in tags"
                  :key="tag.id || tag"
                  :label="tag.name || tag"
                  :value="tag.name || tag"
                >
                  <span class="option-content">
                    <el-icon><Star /></el-icon>
                    {{ tag.name || tag }}
                  </span>
                </el-option>
              </el-select>
            </div>

            <div class="filter-group">
              <label class="filter-label">
                <el-icon><TrendCharts /></el-icon>
                排序方式
              </label>
              <el-select
                v-model="sortBy"
                @change="handleSortChange"
                class="filter-select sort-select"
                size="large"
              >
                <el-option label="发布时间" value="publishTime">
                  <span class="option-content">
                    <el-icon><Calendar /></el-icon>
                    发布时间
                  </span>
                </el-option>
                <el-option label="最多点赞" value="liked">
                  <span class="option-content">
                    <el-icon><Star /></el-icon>
                    最多点赞
                  </span>
                </el-option>
                <el-option label="热度排序" value="popular">
                  <span class="option-content">
                    <el-icon><TrendCharts /></el-icon>
                    热度排序
                  </span>
                </el-option>
              </el-select>
            </div>

            <div class="filter-actions">
              <el-button 
                @click="clearSearch" 
                v-if="hasSearchCriteria"
                class="clear-btn"
                size="large"
                :icon="Delete"
              >
                清空筛选
              </el-button>
              <el-button 
                @click="handleSearch" 
                type="primary"
                class="search-btn"
                size="large"
                :icon="Search"
                :loading="loading"
              >
                搜索
              </el-button>
            </div>
          </div>
        </div>

        <!-- 搜索统计 -->
        <div class="search-stats">
          <p>
            <span v-if="searchKeyword">搜索 "{{ searchKeyword }}"</span>
            <span v-if="categoryFilter"> 在分类 "{{ categoryFilter }}" 中</span>
            <span v-if="tagFilter"> 标签 "{{ tagFilter }}"</span>
            <span v-if="!searchKeyword && !categoryFilter && !tagFilter">共有</span>
            <span v-if="searchKeyword || categoryFilter || tagFilter">找到</span>
            {{ total }} 篇文章
          </p>
        </div>

        <!-- 加载状态 -->
        <div v-if="loading" class="loading">
          <el-skeleton :rows="3" animated />
        </div>

        <!-- 文章列表 -->
        <div v-else-if="articles.length > 0" class="articles-list">
          <div
            v-for="article in articles"
            :key="article.id"
            class="article-card"
            @click="goToArticleDetail(article.id)"
          >
            <div class="article-content">
              <!-- 左侧文本内容 -->
              <div class="article-text">
                <h3 class="article-title">{{ article.title }}</h3>
                <p class="article-summary">
                  {{ article.summary || article.content?.substring(0, 150) + "..." }}
                </p>
                <div class="article-meta">
                  <span class="author">
                    <el-icon><User /></el-icon>
                    {{ article.authorName }}
                  </span>
                  <span class="date">
                    <el-icon><Calendar /></el-icon>
                    {{ formatDate(article.publishedAt || article.createdAt) }}
                  </span>
                  <span class="category" v-if="article.category">
                    <el-icon><Folder /></el-icon>
                    {{ article.category }}
                  </span>
                  <span class="views">
                    <el-icon><TrendCharts /></el-icon>
                    热度 {{ article.viewCount || 0 }}
                  </span>
                  <span class="likes">
                    <el-icon><Star /></el-icon>
                    {{ article.likeCount || 0 }} 点赞
                  </span>
                  <span class="comments">
                    <el-icon><ChatDotRound /></el-icon>
                    {{ article.commentCount || 0 }} 评论
                  </span>
                </div>
                <div class="article-tags" v-if="article.tags">
                  <el-tag
                    v-for="tag in article.tags.split(',')"
                    :key="tag"
                    size="small"
                    class="tag"
                  >
                    {{ tag.trim() }}
                  </el-tag>
                </div>
              </div>
              <!-- 右侧文章图片 -->
              <div v-if="getFirstImage(article)" class="article-image">
                <img :src="getFirstImage(article)" :alt="article.title" />
              </div>
            </div>
          </div>
        </div>

        <!-- 无文章 -->
        <div v-else class="no-articles">
          <el-empty :description="hasSearchCriteria ? '没有找到相关文章' : '暂无文章'">
            <el-button v-if="hasSearchCriteria" type="primary" @click="clearSearch">清空搜索</el-button>
            <el-button v-else type="primary" @click="goHome">返回首页</el-button>
          </el-empty>
        </div>

        <!-- 搜索建议 -->
        <div v-if="!hasSearchCriteria && articles.length === 0 && !loading" class="search-suggestions">
          <h3>热门标签</h3>
          <div class="suggestion-tags">
            <el-tag
              v-for="suggestion in searchSuggestions"
              :key="suggestion"
              class="suggestion-tag"
              @click="searchSuggestion(suggestion)"
            >
              {{ suggestion }}
            </el-tag>
          </div>
        </div>

        <!-- 分页 -->
        <div v-if="total > pageSize" class="pagination">
          <el-pagination
            v-model:current-page="currentPage"
            v-model:page-size="pageSize"
            :page-sizes="[10, 20, 50]"
            :total="total"
            layout="total, sizes, prev, pager, next, jumper"
            @size-change="handleSizeChange"
            @current-change="handleCurrentChange"
          />
        </div>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, onMounted, computed, watch } from "vue";
import { useRouter, useRoute } from "vue-router";
import axios from "axios";
import { ElMessage } from "element-plus";
import {
  Search,
  User,
  Calendar,
  Folder,
  TrendCharts,
  View,
  Star,
  Delete,
  ChatDotRound,
} from "@element-plus/icons-vue";

const router = useRouter();
const route = useRoute();

// 响应式数据
const articles = ref([]);
const categories = ref([]);
const tags = ref([]);
const total = ref(0);
const currentPage = ref(1);
const pageSize = ref(10);
const loading = ref(false);
const sortBy = ref("publishTime");
const searchKeyword = ref("");
const categoryFilter = ref("");
const tagFilter = ref("");

// 搜索建议
const searchSuggestions = ref([
  "Vue.js",
  "Spring Boot",
  "JavaScript",
  "Java",
  "MySQL",
  "前端开发",
  "后端开发",
  "数据库",
  "算法",
  "架构设计",
]);

// 计算属性
const hasSearchCriteria = computed(() => {
  return searchKeyword.value.trim() !== "" || categoryFilter.value !== "" || tagFilter.value !== "";
});

// 组件挂载时初始化
onMounted(() => {
  // 从路由参数获取搜索条件
  if (route.query.keyword) {
    searchKeyword.value = route.query.keyword;
  }
  if (route.query.category) {
    categoryFilter.value = route.query.category;
  }
  if (route.query.tag) {
    tagFilter.value = route.query.tag;
  }
  if (route.query.sort) {
    sortBy.value = route.query.sort;
  }
  
  fetchCategories();
  fetchTags();
  performSearch();
});

// 监听路由变化
watch(
  () => route.query,
  (newQuery) => {
    searchKeyword.value = newQuery.keyword || "";
    categoryFilter.value = newQuery.category || "";
    tagFilter.value = newQuery.tag || "";
    sortBy.value = newQuery.sort || "publishTime";
    performSearch();
  }
);

// 获取分类列表
const fetchCategories = async () => {
  try {
    const response = await axios.get("/api/categories");
    if (response.data) {
      categories.value = response.data;
    }
  } catch (error) {
    console.error("获取分类失败:", error);
    // 使用旧接口作为备选
    try {
      const fallbackResponse = await axios.get("/api/blogs/categories");
      if (fallbackResponse.data) {
        categories.value = fallbackResponse.data.map(cat => 
          typeof cat === 'string' ? { name: cat } : cat
        );
      }
    } catch (fallbackError) {
      console.error("获取分类失败（备选接口）:", fallbackError);
      // 提供默认分类数据
      categories.value = [
        { id: 1, name: "技术分享" },
        { id: 2, name: "生活随笔" },
        { id: 3, name: "学习笔记" },
        { id: 4, name: "项目经验" }
      ];
    }
  }
};

// 获取标签列表
const fetchTags = async () => {
  try {
    const response = await axios.get("/api/tags/active");
    if (response.data) {
      tags.value = response.data;
    }
  } catch (error) {
    console.error("获取标签失败:", error);
    // 提供默认标签数据
    tags.value = [
      { id: 1, name: "Vue.js", isActive: true },
      { id: 2, name: "Spring Boot", isActive: true },
      { id: 3, name: "JavaScript", isActive: true },
      { id: 4, name: "Java", isActive: true },
      { id: 5, name: "MySQL", isActive: true },
      { id: 6, name: "前端开发", isActive: true },
      { id: 7, name: "后端开发", isActive: true }
    ];
   }
 };

// 执行搜索
const performSearch = async () => {
  loading.value = true;

  try {
    const params = {
      page: currentPage.value - 1,
      size: pageSize.value,
    };

    // 添加搜索条件
    if (searchKeyword.value.trim()) {
      params.keyword = searchKeyword.value.trim();
    }
    if (categoryFilter.value) {
      params.category = categoryFilter.value;
    }
    if (tagFilter.value) {
      params.tag = tagFilter.value;
    }
    if (sortBy.value) {
      params.sort = sortBy.value;
    }

    // 调试日志
    console.log('搜索参数:', params);
    console.log('当前排序方式:', sortBy.value);

    const response = await axios.get("/api/blogs", { params });

    if (response.data && response.data.content) {
      articles.value = response.data.content;
      total.value = response.data.totalElements;
      
      // 为每个文章获取评论数量
      await fetchCommentCounts();
    } else {
      articles.value = [];
      total.value = 0;
    }

    // 更新URL参数
    updateUrlParams();
  } catch (error) {
    console.error("搜索失败:", error);
    ElMessage.error("搜索失败，请稍后重试");
    articles.value = [];
    total.value = 0;
  } finally {
    loading.value = false;
  }
};

// 更新URL参数
const updateUrlParams = () => {
  const query = {};
  if (searchKeyword.value.trim()) {
    query.keyword = searchKeyword.value.trim();
  }
  if (categoryFilter.value) {
    query.category = categoryFilter.value;
  }
  if (tagFilter.value) {
    query.tag = tagFilter.value;
  }
  if (sortBy.value !== "publishTime") {
    query.sort = sortBy.value;
  }
  
  router.replace({ query });
};

// 清空搜索
const clearSearch = () => {
  searchKeyword.value = "";
  categoryFilter.value = "";
  tagFilter.value = "";
  sortBy.value = "publishTime";
  currentPage.value = 1;
  router.replace({ query: {} });
  performSearch();
};

// 搜索建议点击
const searchSuggestion = (suggestion) => {
  searchKeyword.value = suggestion;
  performSearch();
};

// 获取评论数量
const fetchCommentCounts = async () => {
  try {
    const promises = articles.value.map(async (article) => {
      try {
        const response = await axios.get(`/api/comments/blog/${article.id}/count`);
        article.commentCount = response.data.count || 0;
      } catch (error) {
        console.error(`获取文章 ${article.id} 评论数量失败:`, error);
        article.commentCount = 0;
      }
    });
    await Promise.all(promises);
  } catch (error) {
    console.error('获取评论数量失败:', error);
  }
};

// 搜索处理
const handleSearch = () => {
  currentPage.value = 1;
  performSearch();
};

// 回车搜索
const handleKeywordEnter = () => {
  handleSearch();
};

// 分页处理
const handleSizeChange = (newSize) => {
  pageSize.value = newSize;
  currentPage.value = 1;
  performSearch();
};

const handleCurrentChange = (newPage) => {
  currentPage.value = newPage;
  performSearch();
};

// 处理排序变化
const handleSortChange = () => {
  console.log('排序方式已改变为:', sortBy.value);
  currentPage.value = 1;
  performSearch();
};

// 跳转到文章详情
const goToArticleDetail = (id) => {
  console.log('文章列表页点击文章，ID:', id)
  router.push(`/blog/${id}`);
};

// 跳转到首页
const goHome = () => {
  router.push("/");
};

// 格式化日期
const formatDate = (dateString) => {
  if (!dateString) return "";
  const date = new Date(dateString);
  return date.toLocaleDateString("zh-CN");
};

// 获取文章的第一张图片
const getFirstImage = (article) => {
  if (!article.images) return null;
  
  try {
    const images = typeof article.images === 'string' 
      ? JSON.parse(article.images) 
      : article.images;
    
    if (Array.isArray(images) && images.length > 0) {
      return images[0];
    }
  } catch (error) {
    console.error('解析图片数据失败:', error);
  }
  
  return null;
};
</script>

<style scoped>
.articles-page {
  min-height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.header {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  padding: 1rem 0;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.header-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.logo {
  color: white;
  font-size: 1.5rem;
  font-weight: 600;
  cursor: pointer;
  margin: 0;
}

.nav {
  display: flex;
  gap: 2rem;
}

.nav-link {
  color: rgba(255, 255, 255, 0.8);
  text-decoration: none;
  font-weight: 500;
  transition: color 0.3s;
}

.nav-link:hover,
.nav-link.active {
  color: white;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 2rem;
}

.main {
  padding: 2rem 0;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 2rem;
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  padding: 2rem;
  border-radius: 12px;
}

.page-header h1 {
  color: white;
  margin: 0;
  font-size: 2.5rem;
  font-weight: 600;
}

.sort-options {
  min-width: 150px;
}

.articles-stats {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  padding: 1rem 2rem;
  border-radius: 8px;
  margin-bottom: 2rem;
}

.articles-stats p {
  color: white;
  margin: 0;
  font-size: 1.1rem;
}

.loading {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  padding: 2rem;
  border-radius: 12px;
}

.articles-list {
  display: grid;
  gap: 1.5rem;
}

.article-card {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border-radius: 12px;
  padding: 1.2rem;
  cursor: pointer;
  transition: all 0.3s ease;
  border: 1px solid rgba(255, 255, 255, 0.1);
  min-height: 180px;
  display: flex;
  flex-direction: column;
}

.article-card:hover {
  transform: translateY(-5px);
  background: rgba(255, 255, 255, 0.15);
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
}

.article-content {
  display: flex;
  gap: 2rem;
  align-items: flex-start;
  flex: 1;
  overflow: hidden;
}

.article-text {
  flex: 1;
  min-width: 0;
}

.article-title {
  color: white;
  font-size: 1.5rem;
  font-weight: 600;
  margin: 0 0 1rem 0;
  line-height: 1.4;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  text-overflow: ellipsis;
  max-height: 4.2rem;
}

.article-summary {
  color: rgba(255, 255, 255, 0.8);
  font-size: 1rem;
  line-height: 1.6;
  margin: 0 0 1.5rem 0;
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
  text-overflow: ellipsis;
  max-height: 4.8rem;
}

.article-meta {
  display: flex;
  flex-wrap: wrap;
  gap: 1.5rem;
  margin-bottom: 1rem;
}

.article-meta span {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  color: rgba(255, 255, 255, 0.7);
  font-size: 0.9rem;
}

.article-meta .el-icon {
  font-size: 1rem;
}

.article-image {
  flex: 0 0 150px;
  border-radius: 8px;
  overflow: hidden;
  height: 120px;
  align-self: center;
}

.article-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s ease;
}

.article-image:hover img {
  transform: scale(1.05);
}

.comments {
  color: rgba(16, 185, 129, 0.9) !important;
}

.comments:hover {
  color: rgba(5, 150, 105, 1) !important;
}



.article-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
}

.tag {
  background: rgba(255, 255, 255, 0.2) !important;
  border: none !important;
  color: white !important;
}

.no-articles {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  padding: 4rem 2rem;
  border-radius: 12px;
  text-align: center;
}

.pagination {
  display: flex;
  justify-content: center;
  margin-top: 3rem;
  padding: 2rem;
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border-radius: 12px;
}

/* 搜索栏样式 */
.search-section {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border-radius: 16px;
  padding: 2.5rem;
  margin-bottom: 2rem;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.search-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 2rem;
}

.search-header h1 {
  color: white;
  margin: 0;
  font-size: 2.5rem;
  font-weight: 600;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
}

.search-stats-inline {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  color: rgba(255, 255, 255, 0.8);
  font-size: 1.1rem;
  background: rgba(255, 255, 255, 0.1);
  padding: 0.75rem 1.25rem;
  border-radius: 25px;
  backdrop-filter: blur(5px);
}

.search-form {
  margin-bottom: 2rem;
}

.search-input {
  border-radius: 25px;
  overflow: hidden;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
}

.search-input :deep(.el-input__wrapper) {
  border-radius: 25px;
  border: 2px solid rgba(255, 255, 255, 0.2);
  background: rgba(255, 255, 255, 0.9);
  backdrop-filter: blur(10px);
  transition: all 0.3s ease;
  padding: 0 20px;
}

.search-input :deep(.el-input__wrapper:hover) {
  border-color: rgba(64, 158, 255, 0.5);
  box-shadow: 0 0 0 2px rgba(64, 158, 255, 0.1);
}

.search-input :deep(.el-input__wrapper.is-focus) {
  border-color: #409eff;
  box-shadow: 0 0 0 2px rgba(64, 158, 255, 0.2);
}

.search-icon {
  color: #409eff;
  font-size: 1.2rem;
}

.filter-options {
  display: grid;
  grid-template-columns: 1fr 1fr auto;
  gap: 2rem;
  align-items: end;
}

.filter-group {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.filter-label {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  color: white;
  font-weight: 500;
  font-size: 0.95rem;
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.3);
}

.filter-select {
  min-width: 180px;
}

.filter-select :deep(.el-input__wrapper) {
  border-radius: 12px;
  border: 2px solid rgba(255, 255, 255, 0.2);
  background: rgba(255, 255, 255, 0.9);
  backdrop-filter: blur(10px);
  transition: all 0.3s ease;
}

.filter-select :deep(.el-input__wrapper:hover) {
  border-color: rgba(64, 158, 255, 0.5);
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.filter-select :deep(.el-input__wrapper.is-focus) {
  border-color: #409eff;
  box-shadow: 0 0 0 2px rgba(64, 158, 255, 0.2);
}

.option-content {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.filter-actions {
  display: flex;
  gap: 1rem;
  align-items: center;
}

.clear-btn {
  background: rgba(245, 101, 101, 0.1);
  border: 2px solid rgba(245, 101, 101, 0.3);
  color: #f56565;
  border-radius: 12px;
  transition: all 0.3s ease;
}

.clear-btn:hover {
  background: rgba(245, 101, 101, 0.2);
  border-color: #f56565;
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(245, 101, 101, 0.2);
}

.search-btn {
  background: linear-gradient(45deg, #409eff, #67c23a);
  border: none;
  border-radius: 12px;
  transition: all 0.3s ease;
  box-shadow: 0 4px 12px rgba(64, 158, 255, 0.3);
}

.search-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(64, 158, 255, 0.4);
}

.search-stats {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  padding: 1rem 2rem;
  border-radius: 12px;
  margin-bottom: 2rem;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.search-stats p {
  color: rgba(255, 255, 255, 0.9);
  margin: 0;
  font-size: 1rem;
}

.search-suggestions {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border-radius: 12px;
  padding: 2rem;
  margin-bottom: 2rem;
  text-align: center;
}

.search-suggestions h3 {
  color: white;
  margin-bottom: 1.5rem;
  font-size: 1.2rem;
}

.suggestion-tags {
  display: flex;
  justify-content: center;
  flex-wrap: wrap;
  gap: 0.75rem;
}

.suggestion-tag {
  background: linear-gradient(45deg, rgba(64, 158, 255, 0.2), rgba(103, 194, 58, 0.2));
  border: 1px solid rgba(255, 255, 255, 0.3);
  color: white;
  border-radius: 20px;
  padding: 0.5rem 1rem;
  cursor: pointer;
  transition: all 0.3s ease;
  font-size: 0.9rem;
  backdrop-filter: blur(5px);
}

.suggestion-tag:hover {
  background: linear-gradient(45deg, rgba(64, 158, 255, 0.3), rgba(103, 194, 58, 0.3));
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
}

/* 响应式设计 */
@media (max-width: 768px) {
  .page-header {
    flex-direction: column;
    gap: 1rem;
    text-align: center;
  }
  
  .page-header h1 {
    font-size: 2rem;
  }
  
  .article-meta {
    flex-direction: column;
    gap: 0.5rem;
  }
  
  .container {
    padding: 0 1rem;
  }

  /* 搜索栏响应式 */
  .search-section {
    padding: 1.5rem;
  }

  .search-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 1rem;
  }

  .search-header h1 {
    font-size: 2rem;
  }

  .search-stats-inline {
    font-size: 1rem;
    padding: 0.5rem 1rem;
  }

  .filter-options {
    grid-template-columns: 1fr;
    gap: 1.5rem;
  }

  .filter-actions {
    justify-content: center;
    flex-wrap: wrap;
  }

  .filter-select {
    min-width: 100%;
  }

  .suggestion-tags {
    justify-content: flex-start;
  }

  .suggestion-tag {
    font-size: 0.8rem;
    padding: 0.4rem 0.8rem;
  }

  .article-card {
    padding: 1rem;
    min-height: 200px;
  }

  .article-content {
    flex-direction: column;
    gap: 1rem;
  }

  .article-image {
    flex: none;
    width: 100%;
    height: 130px;
    align-self: stretch;
  }

  .article-title {
    font-size: 1.3rem;
  }

  .article-meta {
    gap: 1rem;
  }

  .article-meta span {
    font-size: 0.8rem;
  }
}
</style>