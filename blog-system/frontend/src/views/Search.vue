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
                  {{ formatDate(blog.createdAt) }}
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
              <div class="blog-tags" v-if="blog.tags">
                <el-tag
                  v-for="tag in blog.tags.split(',')"
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
  backdrop-filter: blur(10px);
  border-radius: 15px;
  padding: 3rem;
  text-align: center;
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
}
</style>
