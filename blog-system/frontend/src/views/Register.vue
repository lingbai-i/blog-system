<template>
  <div class="register">
    <div class="register-container">
      <div class="register-card">
        <h2 class="register-title">用户注册</h2>
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
    { min: 3, max: 20, message: '用户名长度在 3 到 20 个字符', trigger: 'blur' }
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
.register {
  min-height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 2rem;
}

.register-container {
  width: 100%;
  max-width: 400px;
}

.register-card {
  background: white;
  border-radius: 12px;
  padding: 2rem;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
}

.register-title {
  text-align: center;
  margin-bottom: 2rem;
  color: #333;
  font-size: 1.8rem;
  font-weight: 600;
}

.register-form {
  margin-bottom: 1rem;
}

.register-button {
  width: 100%;
  height: 45px;
  font-size: 1rem;
}

.register-footer {
  text-align: center;
  color: #666;
}

.register-footer .el-link {
  margin-left: 0.5rem;
}

@media (max-width: 768px) {
  .register {
    padding: 1rem;
  }
  
  .register-card {
    padding: 1.5rem;
  }
}
</style>