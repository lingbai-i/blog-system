<template>
  <div class="search-redirect">
    <div class="loading-container">
      <el-loading-directive v-loading="true" text="正在跳转到文章页面..." />
    </div>

    <!-- 搜索结果 -->
    <div class="search-results">
      <div class="container">
        <!-- 搜索统计 -->
        <div class="search-stats" v-if="searchPerformed || (!searchKeyword && !categoryFilter)">
          <p>
            <span v-if="searchKeyword">搜索 "{{ searchKeyword }}"</span>
            <span v-if="categoryFilter"> 在分类 "{{ categoryFilter }}" 中</span>
            <span v-if="!searchKeyword && !categoryFilter">共有</span>
            <span v-if="searchKeyword || categoryFilter">找到</span>
            {{ total }} 篇文章
          </p>
        </div>

        <!-- 加载状态 -->
        <div v-if="loading" class="loading">
          <el-skeleton :rows="3" animated />
        </div>

        <!-- 搜索结果列表 -->
        <div v-else-if="blogs.length > 0" class="blog-list">
          <div
            v-for="blog in blogs"
            :key="blog.id"
            class="blog-card"
            @click="goToBlogDetail(blog.id)"
          >
            <div class="blog-content">
              <!-- 文章图片 -->
              <div v-if="getFirstImage(blog)" class="blog-image">
                <img :src="getFirstImage(blog)" :alt="blog.title" />
              </div>
              <h3 class="blog-title">{{ blog.title }}</h3>
              <p class="blog-summary">
                {{ blog.summary || blog.content?.substring(0, 150) + "..." }}
              </p>
              <div class="blog-meta">
                <span class="author">
                  <el-icon><User /></el-icon>
                  {{ blog.authorName }}
                </span>
                <span class="date">
                  <el-icon><Calendar /></el-icon>
                  {{ formatDate(blog.publishedAt || blog.createdAt) }}
                </span>
                <span class="category" v-if="blog.category">
                  <el-icon><Folder /></el-icon>
                  {{ blog.category }}
                </span>
                <span class="views">
                  <el-icon><View /></el-icon>
                  {{ blog.viewCount || 0 }}
                </span>
                <span class="likes">
                  <el-icon><Star /></el-icon>
                  {{ blog.likeCount || 0 }}
                </span>
              </div>
              <div class="blog-tags" v-if="blog.tags && getTagsArray(blog.tags).length > 0">
                <el-tag
                  v-for="tag in getTagsArray(blog.tags)"
                  :key="tag"
                  size="small"
                  class="tag"
                >
                  {{ tag.trim() }}
                </el-tag>
              </div>
            </div>
          </div>
        </div>

        <!-- 无结果 -->
        <div v-else-if="searchPerformed" class="no-results">
          <el-empty description="没有找到相关文章">
            <el-button type="primary" @click="clearSearch">清空搜索</el-button>
          </el-empty>
        </div>

        <!-- 搜索建议 -->
        <div v-else-if="!searchPerformed && searchKeyword.trim() === '' && categoryFilter === '' && blogs.length === 0" class="search-suggestions">
          <h3>搜索建议</h3>
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
    </div>
  </div>
</template>

<script setup>
import { onMounted } from "vue";
import { useRouter, useRoute } from "vue-router";

const router = useRouter();
const route = useRoute();

// 组件挂载时重定向到Articles页面
onMounted(() => {
  // 保持原有的查询参数
  const query = { ...route.query };
  
  // 重定向到Articles页面
  router.replace({
    path: "/articles",
    query: query
  });
});

// 获取文章的第一张图片
const getFirstImage = (blog) => {
  console.log('获取搜索博客图片:', blog.id, blog.images);
  
  if (!blog.images) {
    console.log('搜索博客无images字段:', blog.id);
    return null;
  }
  
  try {
    const images = typeof blog.images === 'string' 
      ? JSON.parse(blog.images) 
      : blog.images;
    
    console.log('解析后的images:', images);
    
    if (Array.isArray(images) && images.length > 0) {
      const imageUrl = images[0];
      // 确保URL是完整的访问路径
      const fullUrl = imageUrl.startsWith('http') ? imageUrl : `http://localhost:8080${imageUrl}`;
      console.log('返回图片URL:', fullUrl);
      return fullUrl;
    }
  } catch (error) {
    console.error('解析图片数据失败:', error, blog.images);
  }
  
  return null;
};

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

</script>

<style scoped>
.search-redirect {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.loading-container {
  background: rgba(255, 255, 255, 0.9);
  -webkit-backdrop-filter: blur(10px);
  backdrop-filter: blur(10px);
  border-radius: 15px;
  padding: 3rem;
  text-align: center;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
}

.blog-image {
  margin-bottom: 1rem;
  border-radius: 8px;
  overflow: hidden;
}

.blog-image img {
  width: 100%;
  height: 200px;
  object-fit: cover;
  transition: transform 0.3s ease;
}

.blog-image:hover img {
  transform: scale(1.05);
}
</style>
