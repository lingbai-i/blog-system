<template>
  <component 
    :is="tag" 
    :class="[
      'nav-button',
      `nav-button--${type}`,
      `nav-button--${size}`,
      {
        'nav-button--loading': loading,
        'nav-button--disabled': disabled
      }
    ]"
    :disabled="disabled || loading"
    @click="handleClick"
    v-bind="$attrs"
  >
    <!-- 加载状态 -->
    <div v-if="loading" class="nav-button__loading">
      <div class="loading-spinner"></div>
    </div>
    
    <!-- 图标 -->
    <el-icon v-if="icon && !loading" class="nav-button__icon">
      <component :is="icon" />
    </el-icon>
    
    <!-- 内容 -->
    <span v-if="$slots.default" class="nav-button__content">
      <slot />
    </span>
    
    <!-- 涟漪效果 -->
    <div class="nav-button__ripple" ref="rippleRef"></div>
  </component>
</template>

<script setup>
import { ref, nextTick } from 'vue'
import { useRouter } from 'vue-router'

const props = defineProps({
  tag: {
    type: String,
    default: 'button'
  },
  type: {
    type: String,
    default: 'default', // default, primary, success, warning, danger
    validator: (value) => ['default', 'primary', 'success', 'warning', 'danger'].includes(value)
  },
  size: {
    type: String,
    default: 'medium', // small, medium, large
    validator: (value) => ['small', 'medium', 'large'].includes(value)
  },
  icon: {
    type: [String, Object],
    default: null
  },
  to: {
    type: [String, Object],
    default: null
  },
  loading: {
    type: Boolean,
    default: false
  },
  disabled: {
    type: Boolean,
    default: false
  },
  ripple: {
    type: Boolean,
    default: true
  }
})

const emit = defineEmits(['click'])
const router = useRouter()
const rippleRef = ref(null)

const handleClick = async (event) => {
  if (props.disabled || props.loading) return
  
  // 添加涟漪效果
  if (props.ripple) {
    createRipple(event)
  }
  
  // 触发点击事件
  emit('click', event)
  
  // 路由导航
  if (props.to) {
    await nextTick()
    if (typeof props.to === 'string') {
      router.push(props.to)
    } else {
      router.push(props.to)
    }
  }
}

const createRipple = (event) => {
  const button = event.currentTarget
  const ripple = rippleRef.value
  
  if (!ripple) return
  
  const rect = button.getBoundingClientRect()
  const size = Math.max(rect.width, rect.height)
  const x = event.clientX - rect.left - size / 2
  const y = event.clientY - rect.top - size / 2
  
  ripple.style.width = ripple.style.height = size + 'px'
  ripple.style.left = x + 'px'
  ripple.style.top = y + 'px'
  ripple.classList.add('nav-button__ripple--active')
  
  setTimeout(() => {
    ripple.classList.remove('nav-button__ripple--active')
  }, 600)
}
</script>

<style scoped>
.nav-button {
  position: relative;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  font-weight: 500;
  text-decoration: none;
  transition: all 0.2s cubic-bezier(0.25, 0.8, 0.25, 1);
  overflow: hidden;
  user-select: none;
  outline: none;
  background: transparent;
}

/* 尺寸 */
.nav-button--small {
  padding: 6px 12px;
  font-size: 12px;
  min-height: 28px;
}

.nav-button--medium {
  padding: 8px 16px;
  font-size: 14px;
  min-height: 32px;
}

.nav-button--large {
  padding: 12px 20px;
  font-size: 16px;
  min-height: 40px;
}

/* 类型 */
.nav-button--default {
  background: #ffffff;
  color: #606266;
  border: 1px solid #dcdfe6;
}

.nav-button--default:hover {
  background: #ecf5ff;
  border-color: #c6e2ff;
  color: #409eff;
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(64, 158, 255, 0.15);
}

.nav-button--primary {
  background: #409eff;
  color: #ffffff;
  border: 1px solid #409eff;
}

.nav-button--primary:hover {
  background: #66b1ff;
  border-color: #66b1ff;
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(64, 158, 255, 0.3);
}

.nav-button--success {
  background: #67c23a;
  color: #ffffff;
  border: 1px solid #67c23a;
}

.nav-button--success:hover {
  background: #85ce61;
  border-color: #85ce61;
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(103, 194, 58, 0.3);
}

.nav-button--warning {
  background: #e6a23c;
  color: #ffffff;
  border: 1px solid #e6a23c;
}

.nav-button--warning:hover {
  background: #ebb563;
  border-color: #ebb563;
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(230, 162, 60, 0.3);
}

.nav-button--danger {
  background: #f56c6c;
  color: #ffffff;
  border: 1px solid #f56c6c;
}

.nav-button--danger:hover {
  background: #f78989;
  border-color: #f78989;
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(245, 108, 108, 0.3);
}

/* 状态 */
.nav-button--loading,
.nav-button--disabled {
  cursor: not-allowed;
  opacity: 0.6;
}

.nav-button--loading:hover,
.nav-button--disabled:hover {
  transform: none;
  box-shadow: none;
}

/* 元素 */
.nav-button__icon {
  margin-right: 6px;
}

.nav-button__icon:only-child {
  margin-right: 0;
}

.nav-button__content {
  display: inline-block;
}

.nav-button__loading {
  margin-right: 6px;
}

.loading-spinner {
  width: 14px;
  height: 14px;
  border: 2px solid transparent;
  border-top: 2px solid currentColor;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

/* 涟漪效果 */
.nav-button__ripple {
  position: absolute;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.3);
  pointer-events: none;
  transform: scale(0);
  transition: transform 0.6s ease-out;
}

.nav-button__ripple--active {
  transform: scale(1);
}

/* 按下效果 */
.nav-button:active {
  transform: translateY(0) scale(0.98);
}

.nav-button--loading:active,
.nav-button--disabled:active {
  transform: none;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

/* 移动端优化 */
@media (max-width: 768px) {
  .nav-button {
    min-height: 36px;
    padding: 10px 16px;
  }
  
  .nav-button--small {
    min-height: 32px;
    padding: 8px 12px;
  }
  
  .nav-button--large {
    min-height: 44px;
    padding: 14px 24px;
  }
}
</style>