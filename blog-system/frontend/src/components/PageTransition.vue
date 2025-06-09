<template>
  <div class="page-transition-wrapper">
    <!-- 页面加载指示器 -->
    <div v-if="isLoading" class="page-loading">
      <div class="loading-spinner">
        <div class="spinner"></div>
        <p class="loading-text">页面加载中...</p>
      </div>
    </div>
    
    <!-- 页面内容 -->
    <div class="page-content" :class="{ 'content-loading': isLoading }">
      <slot />
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
const isLoading = ref(false)
let loadingTimer = null

// 监听路由变化
const handleRouteStart = () => {
  isLoading.value = true
  // 设置最小加载时间，避免闪烁
  loadingTimer = setTimeout(() => {
    isLoading.value = false
  }, 300)
}

const handleRouteEnd = () => {
  if (loadingTimer) {
    clearTimeout(loadingTimer)
    loadingTimer = null
  }
  // 延迟隐藏加载指示器，确保页面渲染完成
  setTimeout(() => {
    isLoading.value = false
  }, 100)
}

onMounted(() => {
  router.beforeEach((to, from, next) => {
    if (to.path !== from.path) {
      handleRouteStart()
    }
    next()
  })
  
  router.afterEach(() => {
    handleRouteEnd()
  })
})

onUnmounted(() => {
  if (loadingTimer) {
    clearTimeout(loadingTimer)
  }
})
</script>

<style scoped>
.page-transition-wrapper {
  position: relative;
  min-height: 100vh;
}

.page-loading {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(255, 255, 255, 0.9);
  backdrop-filter: blur(2px);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 9999;
  animation: fadeIn 0.2s ease-in-out;
}

.loading-spinner {
  text-align: center;
}

.spinner {
  width: 40px;
  height: 40px;
  border: 3px solid #f3f3f3;
  border-top: 3px solid #409EFF;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin: 0 auto 16px;
}

.loading-text {
  color: #666;
  font-size: 14px;
  margin: 0;
}

.page-content {
  transition: opacity 0.3s ease;
}

.content-loading {
  opacity: 0.7;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

/* 移动端优化 */
@media (max-width: 768px) {
  .spinner {
    width: 32px;
    height: 32px;
    border-width: 2px;
  }
  
  .loading-text {
    font-size: 12px;
  }
}
</style>