<template>
  <transition name="fade">
    <div
      v-show="visible"
      class="back-to-top"
      @click="scrollToTop"
      :title="'回到顶部'"
    >
      <el-icon size="24">
        <ArrowUp />
      </el-icon>
    </div>
  </transition>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import { ArrowUp } from '@element-plus/icons-vue'

const visible = ref(false)
const scrollThreshold = 300 // 滚动超过300px时显示按钮

// 检查滚动位置
const checkScroll = () => {
  visible.value = window.pageYOffset > scrollThreshold
}

// 平滑滚动到顶部
const scrollToTop = () => {
  window.scrollTo({
    top: 0,
    behavior: 'smooth'
  })
}

// 节流函数，优化性能
let ticking = false
const throttledCheckScroll = () => {
  if (!ticking) {
    requestAnimationFrame(() => {
      checkScroll()
      ticking = false
    })
    ticking = true
  }
}

onMounted(() => {
  window.addEventListener('scroll', throttledCheckScroll)
  checkScroll() // 初始检查
})

onUnmounted(() => {
  window.removeEventListener('scroll', throttledCheckScroll)
})
</script>

<style scoped>
.back-to-top {
  position: fixed;
  bottom: 30px;
  right: 30px;
  width: 50px;
  height: 50px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
  transition: all 0.3s ease;
  z-index: 1000;
  color: white;
}

.back-to-top:hover {
  transform: translateY(-3px);
  box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
  background: linear-gradient(135deg, #5a6fd8 0%, #6a4190 100%);
}

.back-to-top:active {
  transform: translateY(-1px);
}

/* 淡入淡出动画 */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .back-to-top {
    bottom: 20px;
    right: 20px;
    width: 45px;
    height: 45px;
  }
}

@media (max-width: 480px) {
  .back-to-top {
    bottom: 15px;
    right: 15px;
    width: 40px;
    height: 40px;
  }
}
</style>