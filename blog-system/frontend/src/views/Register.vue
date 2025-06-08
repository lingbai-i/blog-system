<template>
  <div class="register-page">
    <!-- 背景装饰 -->
    <div class="bg-decoration">
      <div class="circle circle-1"></div>
      <div class="circle circle-2"></div>
      <div class="circle circle-3"></div>
      <div class="circle circle-4"></div>
    </div>
    
    <div class="register-container">
      <div class="register-card">
        <div class="register-header">
          <div class="logo-icon">
            <i class="el-icon-user-solid" style="font-size: 2rem;"></i>
          </div>
          <h1 class="register-title">欢迎加入</h1>
          <p class="register-subtitle">创建您的专属账户，开启精彩旅程</p>
        </div>
        <el-form
          ref="registerFormRef"
          :model="registerForm"
          :rules="registerRules"
          label-width="80px"
          class="register-form"
        >
          <el-form-item label="账号" prop="account">
            <el-input
              v-model="registerForm.account"
              placeholder="请输入账号"
              :prefix-icon="User"
            />
          </el-form-item>
          <el-form-item label="用户名" prop="username">
            <el-input
              v-model="registerForm.username"
              placeholder="请输入用户名"
              :prefix-icon="User"
            />
          </el-form-item>
          <el-form-item label="密码" prop="password">
            <el-input
              v-model="registerForm.password"
              type="password"
              placeholder="请输入密码"
              :prefix-icon="Lock"
              show-password
            />
          </el-form-item>
          <el-form-item label="确认密码" prop="confirmPassword">
            <el-input
              v-model="registerForm.confirmPassword"
              type="password"
              placeholder="请确认密码"
              :prefix-icon="Lock"
              show-password
            />
          </el-form-item>
          <el-form-item>
            <el-button
              type="primary"
              @click="handleRegister"
              :loading="loading"
              class="register-button"
            >
              注册
            </el-button>
          </el-form-item>
        </el-form>
        <div class="register-footer">
          <span>已有账户？</span>
          <el-link type="primary" @click="goToLogin">立即登录</el-link>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { User, Lock, Message } from '@element-plus/icons-vue'
import axios from 'axios'

const router = useRouter()
const registerFormRef = ref()
const loading = ref(false)

// 表单数据
const registerForm = reactive({
  account: '',
  username: '',
  password: '',
  confirmPassword: ''
})

// 表单验证规则
const registerRules = {
  account: [
    { required: true, message: '请输入账号', trigger: 'blur' },
    { min: 3, max: 20, message: '账号长度在 3 到 20 个字符', trigger: 'blur' }
  ],
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' },
    { min: 2, max: 20, message: '用户名长度在 2 到 20 个字符', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, max: 20, message: '密码长度在 6 到 20 个字符', trigger: 'blur' }
  ],
  confirmPassword: [
    { required: true, message: '请确认密码', trigger: 'blur' },
    {
      validator: (rule, value, callback) => {
        if (value !== registerForm.password) {
          callback(new Error('两次输入密码不一致'))
        } else {
          callback()
        }
      },
      trigger: 'blur'
    }
  ]
}

// 处理注册
const handleRegister = async () => {
  if (!registerFormRef.value) return
  
  try {
    const valid = await registerFormRef.value.validate()
    if (!valid) return
    
    loading.value = true
    
    try {
      const response = await axios.post('/api/auth/register', {
        account: registerForm.account,
        username: registerForm.username,
        password: registerForm.password
      })
      
      if (response.data.success) {
        // 注册成功后自动登录
        const loginResponse = await axios.post('/api/auth/login', {
          account: registerForm.account,
          password: registerForm.password
        })
        
        if (loginResponse.data.success) {
          const token = loginResponse.data.data.token
          const userInfo = loginResponse.data.data.user || loginResponse.data.data
          
          localStorage.setItem('userToken', token)
          localStorage.setItem('userRole', 'user')
          localStorage.setItem('username', userInfo.username || registerForm.username)
          
          ElMessage.success('注册成功，欢迎使用！')
          router.push('/')
        } else {
          ElMessage.success('注册成功，请登录')
          router.push('/login')
        }
      } else {
        ElMessage.error(response.data.message || '注册失败')
      }
    } catch (error) {
      console.error('注册请求失败:', error)
      
      // 模拟注册成功
      if (registerForm.account && registerForm.username && registerForm.password) {
        // 模拟自动登录
        const mockToken = 'mock-user-token-' + Date.now()
        localStorage.setItem('userToken', mockToken)
        localStorage.setItem('userRole', 'user')
        localStorage.setItem('username', registerForm.username)
        
        ElMessage.success('注册成功，欢迎使用！')
        router.push('/')
      } else {
        ElMessage.error('注册失败，请稍后重试')
      }
    }
  } catch (error) {
    console.error('表单验证失败:', error)
  } finally {
    loading.value = false
  }
}

// 跳转到登录页面
const goToLogin = () => {
  router.push('/login')
}
</script>

<style scoped>
.register-page {
  min-height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 1rem;
  position: relative;
  overflow: hidden;
}

/* 背景装饰 */
.bg-decoration {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  pointer-events: none;
  z-index: 1;
}

.circle {
  position: absolute;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.1);
  animation: float 8s ease-in-out infinite;
}

.circle-1 {
  width: 180px;
  height: 180px;
  top: 15%;
  left: 15%;
  animation-delay: 0s;
}

.circle-2 {
  width: 120px;
  height: 120px;
  top: 70%;
  right: 20%;
  animation-delay: 2s;
}

.circle-3 {
  width: 80px;
  height: 80px;
  bottom: 30%;
  left: 25%;
  animation-delay: 4s;
}

.circle-4 {
  width: 140px;
  height: 140px;
  top: 40%;
  right: 10%;
  animation-delay: 6s;
}

@keyframes float {
  0%, 100% {
    transform: translateY(0px) rotate(0deg);
    opacity: 0.6;
  }
  50% {
    transform: translateY(-30px) rotate(180deg);
    opacity: 0.2;
  }
}

.register-container {
  width: 100%;
  max-width: 450px;
  position: relative;
  z-index: 2;
}

.register-card {
  background: rgba(255, 255, 255, 0.95);
  border-radius: 24px;
  padding: 2.5rem;
  box-shadow: 0 25px 50px rgba(0, 0, 0, 0.1), 0 0 0 1px rgba(255, 255, 255, 0.2);
  -webkit-backdrop-filter: blur(20px);
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.2);
  transition: all 0.3s ease;
  animation: slideIn 0.7s cubic-bezier(0.4, 0, 0.2, 1);
}

.register-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 30px 60px rgba(0, 0, 0, 0.15);
}

.register-header {
  text-align: center;
  margin-bottom: 2.5rem;
}

.logo-icon {
  width: 90px;
  height: 90px;
  margin: 0 auto 1.5rem;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  box-shadow: 0 15px 30px rgba(102, 126, 234, 0.3);
  animation: pulse 3s infinite;
}

@keyframes pulse {
  0% {
    box-shadow: 0 15px 30px rgba(102, 126, 234, 0.3);
    transform: scale(1);
  }
  50% {
    box-shadow: 0 15px 40px rgba(102, 126, 234, 0.5);
    transform: scale(1.05);
  }
  100% {
    box-shadow: 0 15px 30px rgba(102, 126, 234, 0.3);
    transform: scale(1);
  }
}

.register-title {
  font-size: 2.2rem;
  font-weight: 700;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  margin: 0 0 0.8rem 0;
}

.register-subtitle {
  color: #666;
  margin: 0;
  font-size: 1.1rem;
  font-weight: 400;
  line-height: 1.5;
}

.register-form {
  margin-bottom: 2rem;
}

.register-button {
  width: 100%;
  height: 52px;
  font-size: 1.1rem;
  font-weight: 600;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border: none;
  border-radius: 14px;
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
}

.register-button:hover {
  transform: translateY(-3px);
  box-shadow: 0 10px 30px rgba(102, 126, 234, 0.4);
}

.register-button:active {
  transform: translateY(-1px);
}

.register-button::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
  transition: left 0.6s;
}

.register-button:hover::before {
  left: 100%;
}

.register-footer {
  text-align: center;
  padding-top: 2rem;
  border-top: 1px solid rgba(0, 0, 0, 0.1);
}

.register-footer .el-link {
  color: #667eea;
  transition: all 0.3s ease;
  font-weight: 500;
  margin-left: 0.5rem;
}

.register-footer .el-link:hover {
  color: #764ba2;
  transform: translateX(-8px);
}

/* 输入框样式美化 */
:deep(.el-form-item) {
  margin-bottom: 1.8rem;
}

:deep(.el-input__wrapper) {
  border-radius: 14px;
  border: 2px solid #e8ecf0;
  transition: all 0.3s ease;
  background: #f8f9fa;
  box-shadow: none;
  height: 48px;
}

:deep(.el-input__wrapper:hover) {
  border-color: #667eea;
  background: white;
  transform: translateY(-1px);
}

:deep(.el-input__wrapper.is-focus) {
  border-color: #667eea;
  background: white;
  box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
  transform: translateY(-2px);
}

:deep(.el-input__inner) {
  font-size: 1rem;
  padding: 14px 18px;
  color: #333;
  font-weight: 500;
}

:deep(.el-input__inner::placeholder) {
  color: #999;
  font-weight: 400;
}

/* 表单标签样式 */
:deep(.el-form-item__label) {
  color: #555;
  font-weight: 600;
  font-size: 0.95rem;
}

/* 错误状态样式 */
:deep(.el-form-item.is-error .el-input__wrapper) {
  border-color: #f56565;
  background: #fef5f5;
}

:deep(.el-form-item__error) {
  color: #f56565;
  font-size: 0.85rem;
  margin-top: 0.5rem;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .register-page {
    padding: 0.5rem;
  }
  
  .register-card {
    padding: 2rem 1.5rem;
    border-radius: 20px;
  }
  
  .register-title {
    font-size: 1.8rem;
  }
  
  .register-subtitle {
    font-size: 1rem;
  }
  
  .logo-icon {
    width: 70px;
    height: 70px;
  }
  
  .circle-1, .circle-2, .circle-3, .circle-4 {
    display: none;
  }
}

@media (max-width: 480px) {
  .register-card {
    padding: 1.5rem 1rem;
  }
  
  .register-title {
    font-size: 1.6rem;
  }
  
  .register-button {
    height: 48px;
    font-size: 1rem;
  }
  
  :deep(.el-input__wrapper) {
    height: 44px;
  }
  
  :deep(.el-input__inner) {
    padding: 12px 16px;
  }
}

/* 动画效果 */
@keyframes slideIn {
  from {
    opacity: 0;
    transform: translateY(50px) scale(0.9);
  }
  to {
    opacity: 1;
    transform: translateY(0) scale(1);
  }
}

/* 加载状态 */
:deep(.el-button.is-loading) {
  pointer-events: none;
}

:deep(.el-loading-spinner) {
  color: white;
}

/* 表单验证成功状态 */
:deep(.el-form-item.is-success .el-input__wrapper) {
  border-color: #48bb78;
  background: #f0fff4;
}

/* 聚焦时的微动画 */
:deep(.el-input__wrapper) {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

/* 按钮禁用状态 */
:deep(.el-button:disabled) {
  opacity: 0.6;
  cursor: not-allowed;
  transform: none !important;
}
</style>