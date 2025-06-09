<template>
  <div id="app">
    <router-view v-slot="{ Component, route }">
      <transition :name="getTransitionName(route)" mode="out-in">
        <component :is="Component" :key="route.path" />
      </transition>
    </router-view>
    <BackToTop />
    <PageTransition v-if="isLoading" />
  </div>
</template>

<script setup>
import BackToTop from './components/BackToTop.vue'
import PageTransition from './components/PageTransition.vue'
import { useRoute, useRouter } from 'vue-router'
import { ref, watch } from 'vue'

const route = useRoute()
const router = useRouter()
const isLoading = ref(false)

// 路由历史记录，用于判断前进后退
const routeHistory = ref([])
const isBack = ref(false)

// 监听路由变化
route && watch(() => route.path, (newPath, oldPath) => {
  if (oldPath) {
    const oldIndex = routeHistory.value.indexOf(oldPath)
    const newIndex = routeHistory.value.indexOf(newPath)
    
    if (newIndex > -1 && oldIndex > newIndex) {
      // 后退操作
      isBack.value = true
      routeHistory.value = routeHistory.value.slice(0, newIndex + 1)
    } else {
      // 前进操作
      isBack.value = false
      if (newIndex === -1) {
        routeHistory.value.push(newPath)
      }
    }
  } else {
    routeHistory.value.push(newPath)
  }
})

// 监听路由变化
watch(route, (to, from) => {
  if (to.path !== from.path) {
    isLoading.value = true
    
    // 模拟页面加载时间
    setTimeout(() => {
      isLoading.value = false
    }, 300)
  }
}, { immediate: false })

// 获取过渡动画名称
function getTransitionName(route) {
  // 管理员页面使用淡入淡出
  if (route.path.startsWith('/admin')) {
    return 'fade'
  }
  
  // 登录注册页面使用缩放效果
  if (route.path === '/login' || route.path === '/register') {
    return 'scale'
  }
  
  // 详情页面根据历史判断方向
  if (route.path.includes('/blog/') || route.path.includes('/announcement/')) {
    const currentIndex = routeHistory.value.indexOf(route.path)
    const prevRoute = routeHistory.value[routeHistory.value.length - 2]
    
    if (prevRoute && !prevRoute.includes('/blog/') && !prevRoute.includes('/announcement/')) {
      return 'slide-left' // 从列表进入详情
    } else {
      return 'slide-right' // 从详情返回列表
    }
  }
  
  // 其他页面根据历史判断方向
  const currentIndex = routeHistory.value.indexOf(route.path)
  if (currentIndex > 0) {
    return 'slide-right' // 后退
  } else {
    return 'slide-left' // 前进
  }
}
</script>

<style>
#app {
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #2c3e50;
  min-height: 100vh;
}

* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  background-color: #f5f5f5;
}

/* 页面切换动画 */
/* 基础过渡设置 */
.fade-enter-active,
.fade-leave-active,
.scale-enter-active,
.scale-leave-active,
.slide-left-enter-active,
.slide-left-leave-active,
.slide-right-enter-active,
.slide-right-leave-active {
  position: relative;
  will-change: transform, opacity;
  backface-visibility: hidden;
  perspective: 1000px;
}

/* 淡入淡出效果 */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

/* 缩放效果 */
.scale-enter-active,
.scale-leave-active {
  transition: all 0.4s cubic-bezier(0.25, 0.8, 0.25, 1);
}

.scale-enter-from {
  opacity: 0;
  transform: scale3d(0.9, 0.9, 1) translateY(20px);
}

.scale-leave-to {
  opacity: 0;
  transform: scale3d(1.1, 1.1, 1) translateY(-20px);
}

/* 向左滑动效果 */
.slide-left-enter-active,
.slide-left-leave-active {
  transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
}

.slide-left-enter-from {
  opacity: 0;
  transform: translate3d(30px, 0, 0);
}

.slide-left-leave-to {
  opacity: 0;
  transform: translate3d(-30px, 0, 0);
}

/* 向右滑动效果 */
.slide-right-enter-active,
.slide-right-leave-active {
  transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
}

.slide-right-enter-from {
  opacity: 0;
  transform: translate3d(-30px, 0, 0);
}

.slide-right-leave-to {
  opacity: 0;
  transform: translate3d(30px, 0, 0);
}

/* 页面容器优化 */
.fade-enter-active .page-content,
.fade-leave-active .page-content,
.scale-enter-active .page-content,
.scale-leave-active .page-content,
.slide-left-enter-active .page-content,
.slide-left-leave-active .page-content,
.slide-right-enter-active .page-content,
.slide-right-leave-active .page-content {
  transform: translateZ(0);
}

/* 减少重绘和回流 */
.fade-enter-active,
.fade-leave-active {
  contain: layout style paint;
}

.scale-enter-active,
.scale-leave-active,
.slide-left-enter-active,
.slide-left-leave-active,
.slide-right-enter-active,
.slide-right-leave-active {
  contain: layout style paint;
  transform-origin: center center;
}

/* 优化移动端体验 */
@media (max-width: 768px) {
  .scale-enter-from {
    transform: scale3d(0.95, 0.95, 1) translateY(10px);
  }
  
  .scale-leave-to {
    transform: scale3d(1.05, 1.05, 1) translateY(-10px);
  }
  
  .slide-left-enter-from,
  .slide-right-enter-from {
    transform: translate3d(20px, 0, 0);
  }
  
  .slide-left-leave-to {
    transform: translate3d(-20px, 0, 0);
  }
  
  .slide-right-leave-to {
    transform: translate3d(20px, 0, 0);
  }
  
  /* 移动端减少动画时间 */
  .fade-enter-active,
  .fade-leave-active {
    transition-duration: 0.2s;
  }
  
  .scale-enter-active,
  .scale-leave-active,
  .slide-left-enter-active,
  .slide-left-leave-active,
  .slide-right-enter-active,
  .slide-right-leave-active {
    transition-duration: 0.25s;
  }
}

/* 减少动画偏好设置 */
@media (prefers-reduced-motion: reduce) {
  .fade-enter-active,
  .fade-leave-active,
  .scale-enter-active,
  .scale-leave-active,
  .slide-left-enter-active,
  .slide-left-leave-active,
  .slide-right-enter-active,
  .slide-right-leave-active {
    transition-duration: 0.1s;
  }
  
  .scale-enter-from,
  .scale-leave-to {
    transform: none;
  }
  
  .slide-left-enter-from,
  .slide-left-leave-to,
  .slide-right-enter-from,
  .slide-right-leave-to {
    transform: none;
  }
}
</style>